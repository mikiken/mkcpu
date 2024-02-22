package fpga

import chisel3._
import chisel3.stage.ChiselStage
import cpu.Top

object Elaborate_TangPrimer extends App {
  val file = "src/riscv/rv32ui-p-add.hex"
  (new ChiselStage).emitVerilog(
    new Top(file),
    Array(
      "-o",
      "riscv.v",
      "--target-dir",
      "rtl/tang_primer"
    )
  )
}
