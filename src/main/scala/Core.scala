package cpu

import chisel3._
import chisel3.util._
import common.Consts._
import common.Instructions._

class Core extends Module {
  val io = IO(new Bundle {
    val core_inst_io = Flipped(new InstMemoryIO())
    val core_data_io = Flipped(new DataMemoryIO())
    val exit = Output(Bool()) // true when the program is finished
    val gp = Output(UInt(WORD_LEN.W)) // global pointer (x3)
  })

  // registers (32bit width, 32 registers)
  val regfile = Mem(32, UInt(WORD_LEN.W))
  // csr registers (32bit width, 4096 registers)
  val csr_regfile = Mem(4096, UInt(WORD_LEN.W))

  // ********* Pipeline state registers ***********
  // IF/ID Stage
  val id_pc = RegInit(0.U(WORD_LEN.W))
  val id_original_inst = RegInit(0.U(WORD_LEN.W))

  // ID/EX Stage
  val ex_pc = RegInit(0.U(WORD_LEN.W)) // program counter of ID stage
  val ex_rd_addr = RegInit(0.U(ADDR_LEN.W)) // register destination (write back register address)
  val ex_operand1_data = RegInit(0.U(WORD_LEN.W))
  val ex_operand2_data = RegInit(0.U(WORD_LEN.W))
  val ex_rs2_data = RegInit(0.U(WORD_LEN.W))
  val ex_inst_type = RegInit(0.U(EXE_FUN_LEN.W))
  val ex_memory_write_enable = RegInit(0.U(MEN_LEN.W))
  val ex_writeback_enable = RegInit(0.U(REN_LEN.W))
  val ex_writeback_src = RegInit(0.U(WB_SEL_LEN.W))
  val ex_csr_addr = RegInit(0.U(CSR_ADDR_LEN.W))
  val ex_csr_cmd = RegInit(0.U(CSR_LEN.W))
  val ex_imm_i_sext = RegInit(0.U(WORD_LEN.W))
  val ex_imm_s_sext = RegInit(0.U(WORD_LEN.W))
  val ex_imm_b_sext = RegInit(0.U(WORD_LEN.W))
  val ex_imm_u_shifted = RegInit(0.U(WORD_LEN.W))
  val ex_imm_z_uext = RegInit(0.U(WORD_LEN.W))

  // EX/MEM Stage
  val mem_pc = RegInit(0.U(WORD_LEN.W)) // program counter of EX stage
  val mem_rd_addr = RegInit(0.U(ADDR_LEN.W)) // register destination (write back register address)
  val mem_operand1 = RegInit(0.U(WORD_LEN.W))
  val mem_rs2_data = RegInit(0.U(WORD_LEN.W))
  val mem_memory_write_enable = RegInit(0.U(MEN_LEN.W))
  val mem_writeback_enable = RegInit(0.U(REN_LEN.W))
  val mem_writeback_src = RegInit(0.U(WB_SEL_LEN.W))
  val mem_csr_addr = RegInit(0.U(CSR_ADDR_LEN.W))
  val mem_csr_cmd = RegInit(0.U(CSR_LEN.W))
  val mem_imm_z_uext = RegInit(0.U(WORD_LEN.W))
  val mem_alu_out = RegInit(0.U(WORD_LEN.W))
  val mem_writeback_data = Wire(UInt(WORD_LEN.W))

  // MEM/WB Stage
  val wb_rd_addr = RegInit(0.U(ADDR_LEN.W))
  val wb_writeback_enable = RegInit(0.U(REN_LEN.W))
  val wb_writeback_data = RegInit(0.U(WORD_LEN.W))
  // **********************************************

  // *********** instruction fetch stage **********
  val if_pc = RegInit(START_ADDR)
  io.core_inst_io.addr := if_pc
  val if_inst = io.core_inst_io.inst

  val stall_flag = Wire(Bool())
  val ex_branch_flag = Wire(Bool())
  val ex_branch_target = Wire(UInt(WORD_LEN.W))
  val ex_jump_flag = Wire(Bool())
  val ex_alu_out = Wire(UInt(WORD_LEN.W))

  val if_pc_next = MuxCase(
    if_pc + 4.U(WORD_LEN.W),
    // format: off
    Seq(
      ex_branch_flag      -> ex_branch_target,
      ex_jump_flag        -> ex_alu_out,
      (if_inst === ECALL) -> csr_regfile(0x305), // set pc to the trap vector address (stored in mtvec : 0x305)
      stall_flag          -> if_pc               // If stall occurs, set the same pc in the next cycle
    )
    // format: on
  )
  if_pc := if_pc_next
  // **********************************************

  // set signals to the next stage
  id_pc := Mux(stall_flag, id_pc, if_pc) // If stall occurs, set the same pc in the next cycle
  id_original_inst := MuxCase(
    if_inst,
    // format: off
    Seq(
      (ex_branch_flag || ex_jump_flag) -> BUBBLE,
      stall_flag                       -> id_original_inst // If stall occurs, execute the same inst in the next cycle
    )
    // format: on
  )

  // ********** instruction decode stage **********
  val id_inst = Mux((ex_branch_flag || ex_jump_flag || stall_flag), BUBBLE, id_original_inst)

  val id_rs1_addr = id_inst(19, 15)
  val id_rs2_addr = id_inst(24, 20)
  val id_rs1_addr_original = id_original_inst(19, 15)
  val id_rs2_addr_original = id_original_inst(24, 20)
  val id_rd_addr = id_inst(11, 7)
  val id_rs1_data = MuxCase(
    regfile(id_rs1_addr),
    Seq(
      (id_rs1_addr === 0.U) -> 0.U(WORD_LEN.W),
      // foward data from MEM stage
      ((id_rs1_addr === mem_rd_addr) && (mem_writeback_enable === REN_S)) -> mem_writeback_data,
      // foward data from WB stage
      ((id_rs1_addr === wb_rd_addr) && (wb_writeback_enable === REN_S)) -> wb_writeback_data
    )
  )
  val id_rs2_data = MuxCase(
    regfile(id_rs2_addr),
    Seq(
      (id_rs2_addr === 0.U) -> 0.U(WORD_LEN.W),
      // foward data from MEM stage
      ((id_rs2_addr === mem_rd_addr) && (mem_writeback_enable === REN_S)) -> mem_writeback_data,
      // foward data from WB stage
      ((id_rs2_addr === wb_rd_addr) && (wb_writeback_enable === REN_S)) -> wb_writeback_data
    )
  )
  val id_datahazard_rs1 =
    (ex_writeback_enable === REN_S) && (id_rs1_addr_original === ex_rd_addr) && (id_rs1_addr_original =/= 0.U)
  val id_datahazard_rs2 =
    (ex_writeback_enable === REN_S) && (id_rs2_addr_original === ex_rd_addr) && (id_rs2_addr_original =/= 0.U)

  stall_flag := (id_datahazard_rs1 || id_datahazard_rs2)

  val id_imm_i = id_inst(31, 20) // immedeate value for I-type instruction
  val id_imm_i_sext = Cat(Fill(20, id_imm_i(11)), id_imm_i) // sign extension of imm_i

  val id_imm_s = Cat(id_inst(31, 25), id_inst(11, 7)) // immedeate value for S-type instruction
  val id_imm_s_sext = Cat(Fill(20, id_imm_s(11)), id_imm_s) // sign extension of imm_s

  val id_imm_b = Cat(id_inst(31), id_inst(7), id_inst(30, 25), id_inst(11, 8)) // immedeate value for B-type instruction
  val id_imm_b_sext = Cat(Fill(19, id_imm_b(11)), id_imm_b, 0.U(1.U)) // sign extension of imm_b

  val id_imm_j = Cat(id_inst(31), id_inst(19, 12), id_inst(20), id_inst(30, 21)) // immedeate value for J-type instruction
  val id_imm_j_sext = Cat(Fill(11, id_imm_j(19)), id_imm_j, 0.U(1.U)) // sign extension of imm_j

  val id_imm_u = id_inst(31, 12) // immedeate value for U-type instruction
  val id_imm_u_shifted = Cat(id_imm_u, Fill(12, 0.U))

  val id_imm_z = id_inst(19, 15) // immedeate value for CSR instruction
  val id_imm_z_uext = Cat(Fill(27, 0.U), id_imm_z) // zero extension of imm_z

  val decoded_signals = ListLookup(
    id_inst,
    List(ALU_X, OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X, CSR_X),
    // format: off
    Array(
      LW     -> List(ALU_ADD  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_MEM, CSR_X),
      SW     -> List(ALU_ADD  , OP1_RS1, OP2_IMS, MEN_S, REN_X, WB_X  , CSR_X),
      ADD    -> List(ALU_ADD  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),
      ADDI   -> List(ALU_ADD  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),
      SUB    -> List(ALU_SUB  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),
      AND    -> List(ALU_AND  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),
      OR     -> List(ALU_OR   , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),
      XOR    -> List(ALU_XOR  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),
      ANDI   -> List(ALU_AND  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),
      ORI    -> List(ALU_OR   , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),
      XORI   -> List(ALU_XOR  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),
      SLL    -> List(ALU_SLL  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),
      SRL    -> List(ALU_SRL  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),
      SRA    -> List(ALU_SRA  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),
      SLLI   -> List(ALU_SLL  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),
      SRLI   -> List(ALU_SRL  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),
      SRAI   -> List(ALU_SRA  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),
      SLT    -> List(ALU_SLT  , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),
      SLTU   -> List(ALU_SLTU , OP1_RS1, OP2_RS2, MEN_X, REN_S, WB_ALU, CSR_X),
      SLTI   -> List(ALU_SLT  , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),
      SLTIU  -> List(ALU_SLTU , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_ALU, CSR_X),
      BEQ    -> List(BR_BEQ   , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , CSR_X),
      BNE    -> List(BR_BNE   , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , CSR_X),
      BGE    -> List(BR_BLT   , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , CSR_X),
      BGEU   -> List(BR_BGE   , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , CSR_X),
      BLT    -> List(BR_BLTU  , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , CSR_X),
      BLTU   -> List(BR_BGEU  , OP1_RS1, OP2_RS2, MEN_X, REN_X, WB_X  , CSR_X),
      JAL    -> List(ALU_ADD  , OP1_PC , OP2_IMJ, MEN_X, REN_S, WB_PC , CSR_X),
      JALR   -> List(ALU_JALR , OP1_RS1, OP2_IMI, MEN_X, REN_S, WB_PC , CSR_X),
      LUI    -> List(ALU_ADD  , OP1_X  , OP2_IMU, MEN_X, REN_S, WB_ALU, CSR_X),
      AUIPC  -> List(ALU_ADD  , OP1_PC , OP2_IMU, MEN_X, REN_S, WB_ALU, CSR_X),
      CSRRW  -> List(ALU_COPY1, OP1_RS1, OP2_X  , MEN_X, REN_S, WB_CSR, CSR_W),
      CSRRWI -> List(ALU_COPY1, OP1_IMZ, OP2_X  , MEN_X, REN_S, WB_CSR, CSR_W),
      CSRRS  -> List(ALU_COPY1, OP1_RS1, OP2_X  , MEN_X, REN_S, WB_CSR, CSR_S),
      CSRRSI -> List(ALU_COPY1, OP1_IMZ, OP2_X  , MEN_X, REN_S, WB_CSR, CSR_S),
      CSRRC  -> List(ALU_COPY1, OP1_RS1, OP2_X  , MEN_X, REN_S, WB_CSR, CSR_C),
      CSRRCI -> List(ALU_COPY1, OP1_IMZ, OP2_X  , MEN_X, REN_S, WB_CSR, CSR_C),
      ECALL  -> List(ALU_X    , OP1_X  , OP2_X  , MEN_X, REN_X, WB_X  , CSR_E)
    )
    //format: on
  )
  val id_inst_type :: id_operand1_src :: id_operand2_src :: id_memory_write_enable :: id_writeback_enable :: id_writeback_src :: id_csr_cmd :: Nil =
    decoded_signals

  val id_operand1_data = MuxCase(
    0.U(WORD_LEN.W),
    // format: off
    Seq(
      (id_operand1_src === OP1_RS1) -> id_rs1_data,
      (id_operand1_src === OP1_PC)  -> id_pc
    )
    // format: on
  )

  val id_operand2_data = MuxCase(
    0.U(WORD_LEN),
    Seq(
      (id_operand2_src === OP2_RS2) -> id_rs2_data,
      (id_operand2_src === OP2_IMI) -> id_imm_i_sext,
      (id_operand2_src === OP2_IMS) -> id_imm_s_sext,
      (id_operand2_src === OP2_IMJ) -> id_imm_j_sext,
      (id_operand2_src === OP2_IMU) -> id_imm_u_shifted
    )
  )

  val id_csr_addr = Mux(id_csr_cmd === CSR_E, 0x342.U(CSR_ADDR_LEN.W), id_inst(31, 20))
  // **********************************************

  // set signals to the next stage
  ex_pc := id_pc
  ex_operand1_data := id_operand1_data
  ex_operand2_data := id_operand2_data
  ex_rs2_data := id_rs2_data
  ex_rd_addr := id_rd_addr
  ex_writeback_enable := id_writeback_enable
  ex_inst_type := id_inst_type
  ex_writeback_src := id_writeback_src
  ex_imm_i_sext := id_imm_i_sext
  ex_imm_s_sext := id_imm_s_sext
  ex_imm_b_sext := id_imm_b_sext
  ex_imm_u_shifted := id_imm_u_shifted
  ex_imm_z_uext := id_imm_z_uext
  ex_csr_addr := id_csr_addr
  ex_csr_cmd := id_csr_cmd
  ex_memory_write_enable := id_memory_write_enable

  // ********** instruction execute stage *********
  ex_alu_out := MuxCase(
    0.U(WORD_LEN),
    // format: off
    Seq(
      (ex_inst_type === ALU_ADD)   -> (ex_operand1_data + ex_operand2_data),
      (ex_inst_type === ALU_SUB)   -> (ex_operand1_data - ex_operand2_data),
      (ex_inst_type === ALU_AND)   -> (ex_operand1_data & ex_operand2_data),
      (ex_inst_type === ALU_OR)    -> (ex_operand1_data | ex_operand2_data),
      (ex_inst_type === ALU_XOR)   -> (ex_operand1_data ^ ex_operand2_data),
      (ex_inst_type === ALU_SLL)   -> (ex_operand1_data << ex_operand2_data(4, 0))(31, 0),
      (ex_inst_type === ALU_SRL)   -> (ex_operand1_data >> ex_operand2_data(4, 0)).asUInt(),
      (ex_inst_type === ALU_SRA)   -> (ex_operand1_data.asUInt() >> ex_operand2_data(4, 0)).asUInt(),
      (ex_inst_type === ALU_SLT)   -> (ex_operand1_data.asUInt() < ex_operand2_data.asUInt()).asUInt(), // signed
      (ex_inst_type === ALU_SLTU)  -> (ex_operand1_data < ex_operand2_data).asUInt(),                   // unsigned
      (ex_inst_type === ALU_JALR)  -> ((ex_operand1_data + ex_operand2_data) & ~1.U(WORD_LEN.W)),
      (ex_inst_type === ALU_COPY1) -> ex_operand1_data
    )
    // format: on
  )

  ex_branch_flag := MuxCase(
    false.B,
    // format: off
    Seq(
      (ex_inst_type === BR_BEQ)  -> (ex_operand1_data === ex_operand2_data),
      (ex_inst_type === BR_BNE)  -> !(ex_operand1_data === ex_operand2_data),
      (ex_inst_type === BR_BLT)  -> (ex_operand1_data.asSInt() < ex_operand2_data.asSInt()),
      (ex_inst_type === BR_BGE)  -> !(ex_operand1_data.asSInt() < ex_operand2_data.asSInt()),
      (ex_inst_type === BR_BLTU) -> (ex_operand1_data < ex_operand2_data),
      (ex_inst_type === BR_BGEU) -> !(ex_operand1_data < ex_operand2_data)
    )
    // format: on
  )
  ex_branch_target := ex_pc + ex_imm_b_sext

  ex_jump_flag := (ex_writeback_src === WB_PC)
  // **********************************************

  // set signals to the next stage
  mem_pc := ex_pc
  mem_operand1 := ex_operand1_data
  mem_rs2_data := ex_rs2_data
  mem_rd_addr := ex_rd_addr
  mem_alu_out := ex_alu_out
  mem_writeback_enable := ex_writeback_enable
  mem_writeback_src := ex_writeback_src
  mem_csr_addr := ex_csr_addr
  mem_csr_cmd := ex_csr_cmd
  mem_imm_z_uext := ex_imm_z_uext
  mem_memory_write_enable := ex_memory_write_enable

  // ************ memory access stage *************
  io.core_data_io.addr := mem_alu_out
  io.core_data_io.write_enable := mem_memory_write_enable
  io.core_data_io.write_data := mem_rs2_data

  // read csr
  val csr_rdata = csr_regfile(mem_csr_addr)

  // write csr
  val csr_wdata = MuxCase(
    0.U(WORD_LEN.W),
    Seq(
      (mem_csr_cmd === CSR_W) -> mem_operand1, // write
      (mem_csr_cmd === CSR_S) -> (csr_rdata | mem_operand1), // set
      (mem_csr_cmd === CSR_C) -> (csr_rdata & ~mem_operand1), // clear
      (mem_csr_cmd === CSR_E) -> 11.U(WORD_LEN.W) // ecall from machine mode
    )
  )
  when(mem_csr_cmd > 0.U) {
    csr_regfile(mem_csr_addr) := csr_wdata
  }

  mem_writeback_data := MuxCase(
    mem_alu_out,
    // format: off
    Seq(
      (mem_writeback_src === WB_MEM) -> io.core_data_io.read_data,
      (mem_writeback_src === WB_PC)  -> (mem_pc + 4.U(WORD_LEN.W)),
      (mem_writeback_src === WB_CSR) -> csr_rdata
    )
    // format: on
  )
  // **********************************************

  // set signals  to the next stage
  wb_rd_addr := mem_rd_addr
  wb_writeback_enable := mem_writeback_enable
  wb_writeback_data := mem_writeback_data

  // ************** write back stage **************
  when(wb_writeback_enable === REN_S) {
    regfile(wb_rd_addr) := wb_writeback_data
  }
  // **********************************************

  io.gp := regfile(3)
  io.exit := (mem_pc === 0x44.U(WORD_LEN.W))

  // debug signals
  printf(p"if_pc                     : 0x${Hexadecimal(if_pc)}\n")
  printf(p"id_pc                     : 0x${Hexadecimal(id_pc)}\n")
  printf(p"id_original_inst          : 0x${Hexadecimal(id_original_inst)}\n")
  printf(p"id_rs1_data               : 0x${Hexadecimal(id_rs1_data)}\n")
  printf(p"id_rs2_data               : 0x${Hexadecimal(id_rs2_data)}\n")
  printf(p"ex_pc                     : 0x${Hexadecimal(ex_pc)}\n")
  printf(p"ex_operand1_data          : 0x${Hexadecimal(ex_operand1_data)}\n")
  printf(p"ex_operand2_data          : 0x${Hexadecimal(ex_operand2_data)}\n")
  printf(p"ex_alu_out                : 0x${Hexadecimal(ex_alu_out)}\n")
  printf(p"mem_pc                    : 0x${Hexadecimal(mem_pc)}\n")
  printf(p"mem_writeback_data        : 0x${Hexadecimal(mem_writeback_data)}\n")
  printf(p"wb_writeback_data         : 0x${Hexadecimal(wb_writeback_data)}\n")
  printf(p"stall_flg                 : $stall_flag\n")
  printf(p"gp                        : ${regfile(3)}\n")
  printf(p"core_data_io.addr         : ${io.core_data_io.addr}\n")
  printf(p"core_data_io.write_enable : ${io.core_data_io.write_enable}\n")
  printf(p"core_data_io.write_data   : 0x${Hexadecimal(io.core_data_io.write_data)}\n")
  printf("----------------\n")
}
