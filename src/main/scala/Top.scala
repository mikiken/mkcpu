package cpu

import chisel3._
import chisel3.util._
import common.Consts._

class Top(file: String) extends Module {
  val io = IO(new Bundle {
    val exit = Output(Bool())
    val gp = Output(UInt(WORD_LEN.W))
  })

  val core = Module(new Core())
  val memory = Module(new Memory(file))

  // core.io and memory.io are paired,
  // so they are connected with <> at once
  core.io.core_inst_io <> memory.io.memory_inst_io
  core.io.core_data_io <> memory.io.memory_data_io

  io.exit := core.io.exit
  io.gp := core.io.gp
}
