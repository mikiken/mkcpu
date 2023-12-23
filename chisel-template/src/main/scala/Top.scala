package fetch

import chisel3._
import chisel3.util._

class Top extends Module {
  val io = IO(new Bundle {
    val exit = Output(Bool())
  })

  val core = Module(new Core())
  val memory = Module(new Memory())

  // core.io and memory.io are paired,
  // so they are connected with <> at once
  core.io.imem <> memory.io.imem

  io.exit := core.io.exit

}
