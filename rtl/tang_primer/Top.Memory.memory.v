module BindsTo_0_Memory(
  input         clock,
  input  [31:0] io_memory_inst_io_addr,
  output [31:0] io_memory_inst_io_inst,
  input  [31:0] io_memory_data_io_addr,
  output [31:0] io_memory_data_io_read_data,
  input         io_memory_data_io_write_enable,
  input  [31:0] io_memory_data_io_write_data
);

initial begin
  $readmemh("src/riscv/rv32ui-p-add.hex", Memory.memory);
end
                      endmodule

bind Memory BindsTo_0_Memory BindsTo_0_Memory_Inst(.*);