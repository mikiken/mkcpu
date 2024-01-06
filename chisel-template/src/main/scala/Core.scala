package cpu

import chisel3._
import chisel3.util._
import common.Consts._
import common.Instructions._

class Core extends Module {
  val io = IO(new Bundle {
    val imem = Flipped(new ImemPortIo())
    val dmem = Flipped(new DmemPortIo())
    val exit = Output(Bool()) // true when the program is finished

  })

  // registers (32bit width, 32 registers)
  val regfile = Mem(32, UInt(WORD_LEN.W))

  // instruction fetch stage
  // program counter is incremented by 4 for each cycle
  val pc_reg = RegInit(START_ADDR)
  val pc_plus4 = pc_reg + 4.U(WORD_LEN.W)

  val br_flg = Wire(Bool())
  val br_target = Wire(UInt(WORD_LEN.W))
  val jmp_flg = (inst === JAL || inst === JALR)
  val alu_out = Wire(UInt(WORD_LEN.W))

  val pc_next = MuxCase(
    pc_plus4,
    Seq(
      (br_flg === true.B) -> br_target,
      (jmp_flg === true.B) -> alu_out
    )
  )
  pc_reg := pc_next

  // connect pc to imem.addr and inst to imem.inst
  io.imem.addr := pc_reg
  val inst = io.imem.inst

  // instruction decode stage
  val rs1_addr = inst(19, 15)
  val rs2_addr = inst(24, 20)
  val wb_addr = inst(11, 7)
  val rs1_data = Mux(rs1_addr =/= 0.U(WORD_LEN.W), regfile(rs1_addr), 0.U(WORD_LEN.W))
  val rs2_data = Mux(rs2_addr =/= 0.U(WORD_LEN.W), regfile(rs2_addr), 0.U(WORD_LEN.W))

  val imm_i = inst(31, 20) // immedeate value for I-type instruction
  val imm_i_sext = Cat(Fill(20, imm_i(11)), imm_i) // sign extension of imm_i

  val imm_s = Cat(inst(31, 25), inst(11, 7)) // immedeate value for S-type instruction
  val imm_s_sext = Cat(Fill(20, imm_s(11)), imm_s) // sign extension of imm_s

  val imm_b = Cat(inst(31), inst(7), inst(30, 25), inst(11, 8)) // immedeate value for B-type instruction
  val imm_b_sext = Cat(Fill(19, imm_b(11)), imm_b, 0.U(1.U)) // sign extension of imm_b

  val imm_j = Cat(inst(31), inst(19, 12), inst(20), inst(30, 21)) // immedeate value for J-type instruction
  val imm_j_sext = Cat(Fill(11, imm_j(19)), imm_j, 0.U(1.U)) // sign extension of imm_j

  val imm_u = inst(31, 12) // immedeate value for U-type instruction
  val imm_u_shifted = Cat(imm_u, Fill(12, 0.U))

  val csignals = ListLookup(
    inst,
    List(ALU_X, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X),
    Array(
      LW -> List(ALU_ADD, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_MEM),
      SW -> List(ALU_ADD, OP1_RS1, OP2_IMS, MEN_S, REN_X, WB_X),
      ADD -> List(ALU_ADD, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU),
      ADDI -> List(ALU_ADD, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU),
      SUB -> List(ALU_SUB, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU),
      AND -> List(ALU_AND, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU),
      OR -> List(ALU_OR, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU),
      XOR -> List(ALU_XOR, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU),
      ANDI -> List(ALU_AND, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU),
      ORI -> List(ALU_OR, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU),
      XORI -> List(ALU_XOR, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU),
      SLL -> List(ALU_SLL, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU),
      SRL -> List(ALU_SRL, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU),
      SRA -> List(ALU_SRA, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU),
      SLLI -> List(ALU_SLL, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU),
      SRLI -> List(ALU_SRL, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU),
      SRAI -> List(ALU_SRA, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU),
      SLT -> List(ALU_SLT, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU),
      SLTU -> List(ALU_SLTU, OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU),
      SLTI -> List(ALU_SLT, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU),
      SLTIU -> List(ALU_SLTU, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU),
      BEQ -> List(BR_BEQ, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X),
      BNE -> List(BR_BNE, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X),
      BGE -> List(BR_BLT, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X),
      BGEU -> List(BR_BGE, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X),
      BLT -> List(BR_BLTU, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X),
      BLTU -> List(BR_BGEU, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X),
      JAL -> List(ALU_ADD, OP1_PC, OP2_IMJ, MEN_X, REN_S, WB_PC),
      JALR -> List(ALU_JALR, OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_PC),
      LUI -> List(ALU_ADD, OP1_X, OP2_IMU, MEN_X, REN_S, WB_ALU),
      AUIPC -> List(ALU_ADD, OP1_PC, OP2_IMU, MEN_X, REN_S, WB_ALU)
    )
  )
  val exe_fun :: op1_sel :: op2_sel :: mem_wen :: rf_wen :: wb_sel :: Nil = csignals

  val op1_data = MuxCase(
    0.U(WORD_LEN.W),
    Seq(
      (op1_sel === OP1_RS1) -> rs1_data,
      (op1_sel === OP1_PC) -> pc_reg
    )
  )

  val op2_data = MuxCase(
    0.U(WORD_LEN),
    Seq(
      (op2_sel === OP2_RS2) -> rs2_data,
      (op2_sel === OP2_IMI) -> imm_i_sext,
      (op2_sel === OP2_IMS) -> imm_s_sext,
      (op2_sel === OP2_IMJ) -> imm_j_sext,
      (op2_sel === OP2_IMU) -> imm_u_shifted
    )
  )

  // instruction execute stage
  alu_out := MuxCase(
    0.U(WORD_LEN),
    Seq(
      (exe_fun === ALU_ADD) -> (op1_data + op2_data),
      (exe_fun === ALU_SUB) -> (op1_data - op2_data),
      (exe_fun === ALU_AND) -> (op1_data & op2_data),
      (exe_fun === ALU_OR) -> (op1_data | op2_data),
      (exe_fun === ALU_XOR) -> (op1_data ^ op2_data),
      (exe_fun === ALU_SLL) -> (op1_data << op2_data(4, 0))(31, 0),
      (exe_fun === ALU_SRL) -> (op1_data >> op2_data(4, 0)).asUInt(),
      (exe_fun === ALU_SRA) -> (op1_data.asUInt() >> op2_data(4, 0)).asUInt(),
      (exe_fun === ALU_SLT) -> (op1_data.asUInt() < op2_data.asUInt()).asUInt(), // signed
      (exe_fun === ALU_SLTU) -> (op1_data < op2_data).asUInt(), // unsigned
      (exe_fun === ALU_JALR) -> ((op1_data + op2_data) & ~1.U(WORD_LEN.W))
    )
  )

  br_flg := MuxCase(
    false.B,
    Seq(
      (exe_fun === BR_BEQ) -> (op1_data === op2_data),
      (exe_fun === BR_BNE) -> !(op1_data === op2_data),
      (exe_fun === BR_BLT) -> (op1_data.asSInt() < op2_data.asSInt()),
      (exe_fun === BR_BGE) -> !(op1_data.asSInt() < op2_data.asSInt()),
      (exe_fun === BR_BLTU) -> (op1_data < op2_data),
      (exe_fun === BR_BGEU) -> !(op1_data < op2_data)
    )
  )
  br_target := pc_reg + imm_b_sext

  // memory access stage
  io.dmem.addr := alu_out
  io.dmem.wen := mem_wen
  io.dmem.wdata := rs2_data

  // write back stage
  val wb_data = MuxCase(
    alu_out,
    Seq(
      (wb_sel === WB_MEM) -> io.dmem.rdata,
      (wb_sel === WB_PC) -> pc_plus4
    )
  )
  when(rf_wen === REN_S) {
    regfile(wb_addr) := wb_data
  }

  io.exit := (inst === 0x00602823.U(WORD_LEN.W))

  // debug signals
  printf(p"pc_reg     : 0x${Hexadecimal(pc_reg)}\n")
  printf(p"inst       : 0x${Hexadecimal(inst)}\n")
  printf(p"rs1_addr   : $rs1_addr\n")
  printf(p"rs2_addr   : $rs2_addr\n")
  printf(p"wb_addr    : $wb_addr\n")
  printf(p"rs1_data   : 0x${Hexadecimal(rs1_data)}\n")
  printf(p"rs2_data   : 0x${Hexadecimal(rs2_data)}\n")
  printf(p"wb_data    : 0x${Hexadecimal(wb_data)}\n")
  printf(p"dmem.addr  : ${io.dmem.addr}\n")
  printf(p"dmem.wen   : ${io.dmem.wen}\n")
  printf(p"dmem.wdata : 0x${Hexadecimal(io.dmem.wdata)}\n")
  printf("----------------\n")
}
