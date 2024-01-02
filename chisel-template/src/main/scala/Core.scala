package cpu

import chisel3._
import chisel3.util._
import common.Consts._

class Core extends Module {
  val io = IO(new Bundle {
    val imem = Flipped(new ImemPortIo())
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

  // decode inst
  val rs1_addr = inst(19, 15)
  val rs2_addr = inst(24, 20)
  val wb_addr = inst(11, 7)
  val rs1_data = Mux(rs1_addr =/= 0.U(WORD_LEN.W), regfile(rs1_addr), 0.U(WORD_LEN.W))
  val rs2_data = Mux(rs2_addr =/= 0.U(WORD_LEN.W), regfile(rs2_addr), 0.U(WORD_LEN.W))

  io.exit := (inst === 0x34333231.U(WORD_LEN.W))

  // debug signals
  printf(p"pc_reg   : 0x${Hexadecimal(pc_reg)}\n")
  printf(p"inst     : 0x${Hexadecimal(inst)}\n")
  printf(p"rs1_addr : $rs1_addr\n")
  printf(p"rs2_addr : $rs2_addr\n")
  printf(p"wb_addr  : $wb_addr\n")
  printf(p"rs1_data : 0x${Hexadecimal(rs1_data)}\n")
  printf(p"rs2_data : 0x${Hexadecimal(rs2_data)}\n")
  printf("----------------\n")
}
