package cpu

import chisel3._

import org.scalatest._
import chiseltest._

class FetchTest extends FlatSpec with ChiselScalatestTester {
  "mkcpu" should "work through hex" in {
    val file = "src/hex/hazard_ex.hex"
    test(new Top(file)) { c =>
      while (!c.io.exit.peek().litToBoolean) {
        c.clock.step(1)
      }
    }
  }
}
