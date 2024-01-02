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

  // program counter
  // count up by 4 for each cycle
  // START_ADDR = 0
  val pc_reg = RegInit(START_ADDR)
  pc_reg := pc_reg + 4.U(WORD_LEN.W)

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

  // instruction execute stage
  val alu_out = MuxCase(
    0.U(WORD_LEN),
    Seq(
      (inst === LW) -> (rs1_data + imm_i_sext)
    )
  )

  // memory access stage
  io.dmem.addr := alu_out

  // write back stage
  val wb_data = io.dmem.rdata
  when(inst === LW) {
    regfile(wb_addr) := wb_data
  }

  io.exit := (inst === 0x14131211.U(WORD_LEN.W))

  // debug signals
  printf(p"pc_reg    : 0x${Hexadecimal(pc_reg)}\n")
  printf(p"inst      : 0x${Hexadecimal(inst)}\n")
  printf(p"rs1_addr  : $rs1_addr\n")
  printf(p"rs2_addr  : $rs2_addr\n")
  printf(p"wb_addr   : $wb_addr\n")
  printf(p"rs1_data  : 0x${Hexadecimal(rs1_data)}\n")
  printf(p"rs2_data  : 0x${Hexadecimal(rs2_data)}\n")
  printf(p"wb_data   : 0x${Hexadecimal(wb_data)}\n")
  printf(p"dmem.addr : ${io.dmem.addr}\n")
  printf("----------------\n")
}
