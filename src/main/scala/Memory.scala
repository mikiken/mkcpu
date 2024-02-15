package cpu

import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFile
import common.Consts._

class InstMemoryIO extends Bundle {
  val addr = Input(UInt(WORD_LEN.W))
  val inst = Output(UInt(WORD_LEN.W))
}

class DataMemoryIO extends Bundle {
  val addr = Input(UInt(WORD_LEN.W))
  val read_data = Output(UInt(WORD_LEN.W))
  val write_enable = Input(Bool())
  val write_data = Input(UInt(WORD_LEN.W))
}

class Memory(file: String) extends Module {
  val io = IO(new Bundle {
    val memory_inst_io = new InstMemoryIO()
    val memory_data_io = new DataMemoryIO()
  })

  // memory entity (8bit width * 16384 = 16KB)
  val memory = Mem(16384, UInt(8.W))

  // load program from file
  loadMemoryFromFile(memory, file)

  // one instruction is accessed four addresses of memory
  io.memory_inst_io.inst := Cat(
    memory(io.memory_inst_io.addr + 3.U(WORD_LEN.W)),
    memory(io.memory_inst_io.addr + 2.U(WORD_LEN.W)),
    memory(io.memory_inst_io.addr + 1.U(WORD_LEN.W)),
    memory(io.memory_inst_io.addr)
  )

  io.memory_data_io.read_data := Cat(
    memory(io.memory_data_io.addr + 3.U(WORD_LEN.W)),
    memory(io.memory_data_io.addr + 2.U(WORD_LEN.W)),
    memory(io.memory_data_io.addr + 1.U(WORD_LEN.W)),
    memory(io.memory_data_io.addr)
  )

  // store data to memory (`sw` instruction)
  when(io.memory_data_io.write_enable) {
    memory(io.memory_data_io.addr) := io.memory_data_io.write_data(7, 0)
    memory(io.memory_data_io.addr + 1.U) := io.memory_data_io.write_data(15, 8)
    memory(io.memory_data_io.addr + 2.U) := io.memory_data_io.write_data(23, 16)
    memory(io.memory_data_io.addr + 3.U) := io.memory_data_io.write_data(31, 24)
  }
}
