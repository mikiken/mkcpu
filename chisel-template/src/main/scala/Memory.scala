package cpu

import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFile
import common.Consts._

class ImemPortIo extends Bundle {
  val addr = Input(UInt(WORD_LEN.W))
  val inst = Output(UInt(WORD_LEN.W))
}

class DmemPortIo extends Bundle {
  val addr = Input(UInt(WORD_LEN.W))
  val rdata = Output(UInt(WORD_LEN.W))
  val wen = Input(Bool()) // write enable
  val wdata = Input(UInt(WORD_LEN.W))
}

class Memory extends Module {
  val io = IO(new Bundle {
    val imem = new ImemPortIo()
    val dmem = new DmemPortIo()
  })

  // memory entity (8bit width * 16384 = 16KB)
  val mem = Mem(16384, UInt(8.W))

  // load program from file
  loadMemoryFromFile(mem, "src/hex/sw.hex")

  // one instruction is accessed four addresses of memory
  io.imem.inst := Cat(
    mem(io.imem.addr + 3.U(WORD_LEN.W)),
    mem(io.imem.addr + 2.U(WORD_LEN.W)),
    mem(io.imem.addr + 1.U(WORD_LEN.W)),
    mem(io.imem.addr)
  )

  io.dmem.rdata := Cat(
    mem(io.dmem.addr + 3.U(WORD_LEN.W)),
    mem(io.dmem.addr + 2.U(WORD_LEN.W)),
    mem(io.dmem.addr + 1.U(WORD_LEN.W)),
    mem(io.dmem.addr)
  )

  // store data to memory (`sw` instruction)
  when(io.dmem.wen) {
    mem(io.dmem.addr) := io.dmem.wdata(7, 0)
    mem(io.dmem.addr + 1.U) := io.dmem.wdata(15, 8)
    mem(io.dmem.addr + 2.U) := io.dmem.wdata(23, 16)
    mem(io.dmem.addr + 3.U) := io.dmem.wdata(31, 24)
  }
}
