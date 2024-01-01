package fetch

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

  io.exit := (inst === 0x34333231.U(WORD_LEN.W))

  // debug signals
  printf(p"pc_reg : 0x${Hexadecimal(pc_reg)}\n")
  printf(p"inst   : 0x${Hexadecimal(inst)}\n")
  printf("----------------\n")
}
