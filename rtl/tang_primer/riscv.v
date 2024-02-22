module Core(
  input         clock,
  input         reset,
  output [31:0] io_core_inst_io_addr,
  input  [31:0] io_core_inst_io_inst,
  output [31:0] io_core_data_io_addr,
  input  [31:0] io_core_data_io_read_data,
  output        io_core_data_io_write_enable,
  output [31:0] io_core_data_io_write_data,
  output        io_exit,
  output [31:0] io_gp
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] regfile [0:31]; // @[Core.scala 17:20]
  wire [31:0] regfile_id_rs1_data_MPORT_data; // @[Core.scala 17:20]
  wire [4:0] regfile_id_rs1_data_MPORT_addr; // @[Core.scala 17:20]
  wire [31:0] regfile_id_rs2_data_MPORT_data; // @[Core.scala 17:20]
  wire [4:0] regfile_id_rs2_data_MPORT_addr; // @[Core.scala 17:20]
  wire [31:0] regfile_io_gp_MPORT_data; // @[Core.scala 17:20]
  wire [4:0] regfile_io_gp_MPORT_addr; // @[Core.scala 17:20]
  wire [31:0] regfile_MPORT_2_data; // @[Core.scala 17:20]
  wire [4:0] regfile_MPORT_2_addr; // @[Core.scala 17:20]
  wire [31:0] regfile_MPORT_1_data; // @[Core.scala 17:20]
  wire [4:0] regfile_MPORT_1_addr; // @[Core.scala 17:20]
  wire  regfile_MPORT_1_mask; // @[Core.scala 17:20]
  wire  regfile_MPORT_1_en; // @[Core.scala 17:20]
  reg [31:0] csr_regfile [0:4095]; // @[Core.scala 19:24]
  wire [31:0] csr_regfile_if_pc_next_MPORT_data; // @[Core.scala 19:24]
  wire [11:0] csr_regfile_if_pc_next_MPORT_addr; // @[Core.scala 19:24]
  wire [31:0] csr_regfile_csr_rdata_data; // @[Core.scala 19:24]
  wire [11:0] csr_regfile_csr_rdata_addr; // @[Core.scala 19:24]
  wire [31:0] csr_regfile_MPORT_data; // @[Core.scala 19:24]
  wire [11:0] csr_regfile_MPORT_addr; // @[Core.scala 19:24]
  wire  csr_regfile_MPORT_mask; // @[Core.scala 19:24]
  wire  csr_regfile_MPORT_en; // @[Core.scala 19:24]
  reg [31:0] id_pc; // @[Core.scala 23:22]
  reg [31:0] id_original_inst; // @[Core.scala 24:33]
  reg [31:0] ex_pc; // @[Core.scala 27:22]
  reg [4:0] ex_rd_addr; // @[Core.scala 28:27]
  reg [31:0] ex_operand1_data; // @[Core.scala 29:33]
  reg [31:0] ex_operand2_data; // @[Core.scala 30:33]
  reg [31:0] ex_rs2_data; // @[Core.scala 31:28]
  reg [4:0] ex_inst_type; // @[Core.scala 32:29]
  reg [1:0] ex_memory_write_enable; // @[Core.scala 33:39]
  reg [1:0] ex_writeback_enable; // @[Core.scala 34:36]
  reg [2:0] ex_writeback_src; // @[Core.scala 35:33]
  reg [11:0] ex_csr_addr; // @[Core.scala 36:28]
  reg [2:0] ex_csr_cmd; // @[Core.scala 37:27]
  reg [31:0] ex_imm_b_sext; // @[Core.scala 40:30]
  reg [31:0] mem_pc; // @[Core.scala 45:23]
  reg [4:0] mem_rd_addr; // @[Core.scala 46:28]
  reg [31:0] mem_operand1; // @[Core.scala 47:29]
  reg [31:0] mem_rs2_data; // @[Core.scala 48:29]
  reg [1:0] mem_memory_write_enable; // @[Core.scala 49:40]
  reg [1:0] mem_writeback_enable; // @[Core.scala 50:37]
  reg [2:0] mem_writeback_src; // @[Core.scala 51:34]
  reg [11:0] mem_csr_addr; // @[Core.scala 52:29]
  reg [2:0] mem_csr_cmd; // @[Core.scala 53:28]
  reg [31:0] mem_alu_out; // @[Core.scala 55:28]
  reg [4:0] wb_rd_addr; // @[Core.scala 59:27]
  reg [1:0] wb_writeback_enable; // @[Core.scala 60:36]
  reg [31:0] wb_writeback_data; // @[Core.scala 61:34]
  reg [31:0] if_pc; // @[Core.scala 65:22]
  wire [31:0] _if_pc_next_T_1 = if_pc + 32'h4; // @[Core.scala 76:11]
  wire  _if_pc_next_T_3 = 32'h73 == io_core_inst_io_inst; // @[Core.scala 81:16]
  wire  _id_datahazard_rs1_T = ex_writeback_enable == 2'h1; // @[Core.scala 130:26]
  wire [4:0] id_rs1_addr_original = id_original_inst[19:15]; // @[Core.scala 106:46]
  wire  id_datahazard_rs1 = ex_writeback_enable == 2'h1 & id_rs1_addr_original == ex_rd_addr & id_rs1_addr_original != 5'h0
    ; // @[Core.scala 130:78]
  wire [4:0] id_rs2_addr_original = id_original_inst[24:20]; // @[Core.scala 107:46]
  wire  id_datahazard_rs2 = _id_datahazard_rs1_T & id_rs2_addr_original == ex_rd_addr & id_rs2_addr_original != 5'h0; // @[Core.scala 132:78]
  wire  stall_flag = id_datahazard_rs1 | id_datahazard_rs2; // @[Core.scala 134:36]
  wire [31:0] _if_pc_next_T_4 = stall_flag ? if_pc : _if_pc_next_T_1; // @[Mux.scala 98:16]
  wire  ex_jump_flag = ex_writeback_src == 3'h2; // @[Core.scala 281:37]
  wire  _ex_alu_out_T = ex_inst_type == 5'h1; // @[Core.scala 250:21]
  wire [31:0] _ex_alu_out_T_2 = ex_operand1_data + ex_operand2_data; // @[Core.scala 250:57]
  wire  _ex_alu_out_T_3 = ex_inst_type == 5'h2; // @[Core.scala 251:21]
  wire [31:0] _ex_alu_out_T_5 = ex_operand1_data - ex_operand2_data; // @[Core.scala 251:57]
  wire  _ex_alu_out_T_6 = ex_inst_type == 5'h3; // @[Core.scala 252:21]
  wire [31:0] _ex_alu_out_T_7 = ex_operand1_data & ex_operand2_data; // @[Core.scala 252:57]
  wire  _ex_alu_out_T_8 = ex_inst_type == 5'h4; // @[Core.scala 253:21]
  wire [31:0] _ex_alu_out_T_9 = ex_operand1_data | ex_operand2_data; // @[Core.scala 253:57]
  wire  _ex_alu_out_T_10 = ex_inst_type == 5'h5; // @[Core.scala 254:21]
  wire [31:0] _ex_alu_out_T_11 = ex_operand1_data ^ ex_operand2_data; // @[Core.scala 254:57]
  wire  _ex_alu_out_T_12 = ex_inst_type == 5'h6; // @[Core.scala 255:21]
  wire [62:0] _GEN_10 = {{31'd0}, ex_operand1_data}; // @[Core.scala 255:57]
  wire [62:0] _ex_alu_out_T_14 = _GEN_10 << ex_operand2_data[4:0]; // @[Core.scala 255:57]
  wire  _ex_alu_out_T_16 = ex_inst_type == 5'h7; // @[Core.scala 256:21]
  wire [31:0] _ex_alu_out_T_18 = ex_operand1_data >> ex_operand2_data[4:0]; // @[Core.scala 256:57]
  wire  _ex_alu_out_T_19 = ex_inst_type == 5'h8; // @[Core.scala 257:21]
  wire  _ex_alu_out_T_22 = ex_inst_type == 5'h9; // @[Core.scala 258:21]
  wire  _ex_alu_out_T_23 = ex_operand1_data < ex_operand2_data; // @[Core.scala 258:66]
  wire  _ex_alu_out_T_24 = ex_inst_type == 5'ha; // @[Core.scala 259:21]
  wire  _ex_alu_out_T_26 = ex_inst_type == 5'h11; // @[Core.scala 260:21]
  wire [31:0] _ex_alu_out_T_30 = _ex_alu_out_T_2 & 32'hfffffffe; // @[Core.scala 260:78]
  wire  _ex_alu_out_T_31 = ex_inst_type == 5'h12; // @[Core.scala 261:21]
  wire [31:0] _ex_alu_out_T_32 = _ex_alu_out_T_31 ? ex_operand1_data : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _ex_alu_out_T_33 = _ex_alu_out_T_26 ? _ex_alu_out_T_30 : _ex_alu_out_T_32; // @[Mux.scala 98:16]
  wire [31:0] _ex_alu_out_T_34 = _ex_alu_out_T_24 ? {{31'd0}, _ex_alu_out_T_23} : _ex_alu_out_T_33; // @[Mux.scala 98:16]
  wire [31:0] _ex_alu_out_T_35 = _ex_alu_out_T_22 ? {{31'd0}, _ex_alu_out_T_23} : _ex_alu_out_T_34; // @[Mux.scala 98:16]
  wire [31:0] _ex_alu_out_T_36 = _ex_alu_out_T_19 ? _ex_alu_out_T_18 : _ex_alu_out_T_35; // @[Mux.scala 98:16]
  wire [31:0] _ex_alu_out_T_37 = _ex_alu_out_T_16 ? _ex_alu_out_T_18 : _ex_alu_out_T_36; // @[Mux.scala 98:16]
  wire [31:0] _ex_alu_out_T_38 = _ex_alu_out_T_12 ? _ex_alu_out_T_14[31:0] : _ex_alu_out_T_37; // @[Mux.scala 98:16]
  wire [31:0] _ex_alu_out_T_39 = _ex_alu_out_T_10 ? _ex_alu_out_T_11 : _ex_alu_out_T_38; // @[Mux.scala 98:16]
  wire [31:0] _ex_alu_out_T_40 = _ex_alu_out_T_8 ? _ex_alu_out_T_9 : _ex_alu_out_T_39; // @[Mux.scala 98:16]
  wire [31:0] _ex_alu_out_T_41 = _ex_alu_out_T_6 ? _ex_alu_out_T_7 : _ex_alu_out_T_40; // @[Mux.scala 98:16]
  wire [31:0] _ex_alu_out_T_42 = _ex_alu_out_T_3 ? _ex_alu_out_T_5 : _ex_alu_out_T_41; // @[Mux.scala 98:16]
  wire [31:0] ex_alu_out = _ex_alu_out_T ? _ex_alu_out_T_2 : _ex_alu_out_T_42; // @[Mux.scala 98:16]
  wire  _ex_branch_flag_T = ex_inst_type == 5'hb; // @[Core.scala 270:21]
  wire  _ex_branch_flag_T_1 = ex_operand1_data == ex_operand2_data; // @[Core.scala 270:55]
  wire  _ex_branch_flag_T_2 = ex_inst_type == 5'hc; // @[Core.scala 271:21]
  wire  _ex_branch_flag_T_4 = ~_ex_branch_flag_T_1; // @[Core.scala 271:37]
  wire  _ex_branch_flag_T_5 = ex_inst_type == 5'hd; // @[Core.scala 272:21]
  wire  _ex_branch_flag_T_8 = $signed(ex_operand1_data) < $signed(ex_operand2_data); // @[Core.scala 272:64]
  wire  _ex_branch_flag_T_9 = ex_inst_type == 5'he; // @[Core.scala 273:21]
  wire  _ex_branch_flag_T_13 = ~_ex_branch_flag_T_8; // @[Core.scala 273:37]
  wire  _ex_branch_flag_T_14 = ex_inst_type == 5'hf; // @[Core.scala 274:21]
  wire  _ex_branch_flag_T_16 = ex_inst_type == 5'h10; // @[Core.scala 275:21]
  wire  _ex_branch_flag_T_18 = ~_ex_alu_out_T_23; // @[Core.scala 275:37]
  wire  _ex_branch_flag_T_20 = _ex_branch_flag_T_14 ? _ex_alu_out_T_23 : _ex_branch_flag_T_16 & _ex_branch_flag_T_18; // @[Mux.scala 98:16]
  wire  _ex_branch_flag_T_21 = _ex_branch_flag_T_9 ? _ex_branch_flag_T_13 : _ex_branch_flag_T_20; // @[Mux.scala 98:16]
  wire  _ex_branch_flag_T_22 = _ex_branch_flag_T_5 ? _ex_branch_flag_T_8 : _ex_branch_flag_T_21; // @[Mux.scala 98:16]
  wire  _ex_branch_flag_T_23 = _ex_branch_flag_T_2 ? _ex_branch_flag_T_4 : _ex_branch_flag_T_22; // @[Mux.scala 98:16]
  wire  ex_branch_flag = _ex_branch_flag_T ? _ex_branch_flag_T_1 : _ex_branch_flag_T_23; // @[Mux.scala 98:16]
  wire [31:0] ex_branch_target = ex_pc + ex_imm_b_sext; // @[Core.scala 279:29]
  wire  _id_original_inst_T = ex_branch_flag | ex_jump_flag; // @[Core.scala 95:23]
  wire [31:0] id_inst = _id_original_inst_T | stall_flag ? 32'h13 : id_original_inst; // @[Core.scala 102:20]
  wire [4:0] id_rs1_addr = id_inst[19:15]; // @[Core.scala 104:28]
  wire [4:0] id_rs2_addr = id_inst[24:20]; // @[Core.scala 105:28]
  wire [4:0] id_rd_addr = id_inst[11:7]; // @[Core.scala 108:27]
  wire  _id_rs1_data_T = id_rs1_addr == 5'h0; // @[Core.scala 112:20]
  wire  _id_rs1_data_T_2 = mem_writeback_enable == 2'h1; // @[Core.scala 114:63]
  wire  _id_rs1_data_T_3 = id_rs1_addr == mem_rd_addr & mem_writeback_enable == 2'h1; // @[Core.scala 114:38]
  wire  _id_rs1_data_T_5 = wb_writeback_enable == 2'h1; // @[Core.scala 116:61]
  wire  _id_rs1_data_T_6 = id_rs1_addr == wb_rd_addr & wb_writeback_enable == 2'h1; // @[Core.scala 116:37]
  wire [31:0] _id_rs1_data_T_7 = _id_rs1_data_T_6 ? wb_writeback_data : regfile_id_rs1_data_MPORT_data; // @[Mux.scala 98:16]
  wire  _mem_writeback_data_T = mem_writeback_src == 3'h1; // @[Core.scala 323:26]
  wire  _mem_writeback_data_T_1 = mem_writeback_src == 3'h2; // @[Core.scala 324:26]
  wire [31:0] _mem_writeback_data_T_3 = mem_pc + 32'h4; // @[Core.scala 324:49]
  wire  _mem_writeback_data_T_4 = mem_writeback_src == 3'h3; // @[Core.scala 325:26]
  wire [31:0] _mem_writeback_data_T_5 = _mem_writeback_data_T_4 ? csr_regfile_csr_rdata_data : mem_alu_out; // @[Mux.scala 98:16]
  wire [31:0] _mem_writeback_data_T_6 = _mem_writeback_data_T_1 ? _mem_writeback_data_T_3 : _mem_writeback_data_T_5; // @[Mux.scala 98:16]
  wire [31:0] mem_writeback_data = _mem_writeback_data_T ? io_core_data_io_read_data : _mem_writeback_data_T_6; // @[Mux.scala 98:16]
  wire [31:0] _id_rs1_data_T_8 = _id_rs1_data_T_3 ? mem_writeback_data : _id_rs1_data_T_7; // @[Mux.scala 98:16]
  wire [31:0] id_rs1_data = _id_rs1_data_T ? 32'h0 : _id_rs1_data_T_8; // @[Mux.scala 98:16]
  wire  _id_rs2_data_T = id_rs2_addr == 5'h0; // @[Core.scala 122:20]
  wire  _id_rs2_data_T_3 = id_rs2_addr == mem_rd_addr & _id_rs1_data_T_2; // @[Core.scala 124:38]
  wire  _id_rs2_data_T_6 = id_rs2_addr == wb_rd_addr & _id_rs1_data_T_5; // @[Core.scala 126:37]
  wire [31:0] _id_rs2_data_T_7 = _id_rs2_data_T_6 ? wb_writeback_data : regfile_id_rs2_data_MPORT_data; // @[Mux.scala 98:16]
  wire [31:0] _id_rs2_data_T_8 = _id_rs2_data_T_3 ? mem_writeback_data : _id_rs2_data_T_7; // @[Mux.scala 98:16]
  wire [31:0] id_rs2_data = _id_rs2_data_T ? 32'h0 : _id_rs2_data_T_8; // @[Mux.scala 98:16]
  wire [11:0] id_imm_i = id_inst[31:20]; // @[Core.scala 136:25]
  wire [19:0] id_imm_i_sext_hi = id_imm_i[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 72:12]
  wire [31:0] id_imm_i_sext = {id_imm_i_sext_hi,id_imm_i}; // @[Cat.scala 30:58]
  wire [6:0] id_imm_s_hi = id_inst[31:25]; // @[Core.scala 139:29]
  wire [11:0] id_imm_s = {id_imm_s_hi,id_rd_addr}; // @[Cat.scala 30:58]
  wire [19:0] id_imm_s_sext_hi = id_imm_s[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 72:12]
  wire [31:0] id_imm_s_sext = {id_imm_s_sext_hi,id_imm_s_hi,id_rd_addr}; // @[Cat.scala 30:58]
  wire  id_imm_b_hi_hi = id_inst[31]; // @[Core.scala 142:29]
  wire  id_imm_b_hi_lo = id_inst[7]; // @[Core.scala 142:42]
  wire [5:0] id_imm_b_lo_hi = id_inst[30:25]; // @[Core.scala 142:54]
  wire [3:0] id_imm_b_lo_lo = id_inst[11:8]; // @[Core.scala 142:71]
  wire [11:0] id_imm_b = {id_imm_b_hi_hi,id_imm_b_hi_lo,id_imm_b_lo_hi,id_imm_b_lo_lo}; // @[Cat.scala 30:58]
  wire [18:0] id_imm_b_sext_hi_hi = id_imm_b[11] ? 19'h7ffff : 19'h0; // @[Bitwise.scala 72:12]
  wire [31:0] id_imm_b_sext = {id_imm_b_sext_hi_hi,id_imm_b_hi_hi,id_imm_b_hi_lo,id_imm_b_lo_hi,id_imm_b_lo_lo,1'h0}; // @[Cat.scala 30:58]
  wire [7:0] id_imm_j_hi_lo = id_inst[19:12]; // @[Core.scala 145:42]
  wire  id_imm_j_lo_hi = id_inst[20]; // @[Core.scala 145:59]
  wire [9:0] id_imm_j_lo_lo = id_inst[30:21]; // @[Core.scala 145:72]
  wire [19:0] id_imm_j = {id_imm_b_hi_hi,id_imm_j_hi_lo,id_imm_j_lo_hi,id_imm_j_lo_lo}; // @[Cat.scala 30:58]
  wire [10:0] id_imm_j_sext_hi_hi = id_imm_j[19] ? 11'h7ff : 11'h0; // @[Bitwise.scala 72:12]
  wire [31:0] id_imm_j_sext = {id_imm_j_sext_hi_hi,id_imm_b_hi_hi,id_imm_j_hi_lo,id_imm_j_lo_hi,id_imm_j_lo_lo,1'h0}; // @[Cat.scala 30:58]
  wire [19:0] id_imm_u = id_inst[31:12]; // @[Core.scala 148:25]
  wire [31:0] id_imm_u_shifted = {id_imm_u,12'h0}; // @[Cat.scala 30:58]
  wire [31:0] _decoded_signals_T = id_inst & 32'h707f; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_1 = 32'h2003 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_3 = 32'h2023 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire [31:0] _decoded_signals_T_4 = id_inst & 32'hfe00707f; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_5 = 32'h33 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_7 = 32'h13 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_9 = 32'h40000033 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_11 = 32'h7033 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_13 = 32'h6033 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_15 = 32'h4033 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_17 = 32'h7013 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_19 = 32'h6013 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_21 = 32'h4013 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_23 = 32'h1033 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_25 = 32'h5033 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_27 = 32'h40005033 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_29 = 32'h1013 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_31 = 32'h5013 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_33 = 32'h40005013 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_35 = 32'h2033 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_37 = 32'h3033 == _decoded_signals_T_4; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_39 = 32'h2013 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_41 = 32'h3013 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_43 = 32'h63 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_45 = 32'h1063 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_47 = 32'h5063 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_49 = 32'h7063 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_51 = 32'h4063 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_53 = 32'h6063 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire [31:0] _decoded_signals_T_54 = id_inst & 32'h7f; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_55 = 32'h6f == _decoded_signals_T_54; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_57 = 32'h67 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_59 = 32'h37 == _decoded_signals_T_54; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_61 = 32'h17 == _decoded_signals_T_54; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_63 = 32'h1073 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_65 = 32'h5073 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_67 = 32'h2073 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_69 = 32'h6073 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_71 = 32'h3073 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_73 = 32'h7073 == _decoded_signals_T; // @[Lookup.scala 31:38]
  wire  _decoded_signals_T_75 = 32'h73 == id_inst; // @[Lookup.scala 31:38]
  wire [4:0] _decoded_signals_T_77 = _decoded_signals_T_73 ? 5'h12 : 5'h0; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_78 = _decoded_signals_T_71 ? 5'h12 : _decoded_signals_T_77; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_79 = _decoded_signals_T_69 ? 5'h12 : _decoded_signals_T_78; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_80 = _decoded_signals_T_67 ? 5'h12 : _decoded_signals_T_79; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_81 = _decoded_signals_T_65 ? 5'h12 : _decoded_signals_T_80; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_82 = _decoded_signals_T_63 ? 5'h12 : _decoded_signals_T_81; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_83 = _decoded_signals_T_61 ? 5'h1 : _decoded_signals_T_82; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_84 = _decoded_signals_T_59 ? 5'h1 : _decoded_signals_T_83; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_85 = _decoded_signals_T_57 ? 5'h11 : _decoded_signals_T_84; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_86 = _decoded_signals_T_55 ? 5'h1 : _decoded_signals_T_85; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_87 = _decoded_signals_T_53 ? 5'h10 : _decoded_signals_T_86; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_88 = _decoded_signals_T_51 ? 5'hf : _decoded_signals_T_87; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_89 = _decoded_signals_T_49 ? 5'he : _decoded_signals_T_88; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_90 = _decoded_signals_T_47 ? 5'hd : _decoded_signals_T_89; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_91 = _decoded_signals_T_45 ? 5'hc : _decoded_signals_T_90; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_92 = _decoded_signals_T_43 ? 5'hb : _decoded_signals_T_91; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_93 = _decoded_signals_T_41 ? 5'ha : _decoded_signals_T_92; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_94 = _decoded_signals_T_39 ? 5'h9 : _decoded_signals_T_93; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_95 = _decoded_signals_T_37 ? 5'ha : _decoded_signals_T_94; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_96 = _decoded_signals_T_35 ? 5'h9 : _decoded_signals_T_95; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_97 = _decoded_signals_T_33 ? 5'h8 : _decoded_signals_T_96; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_98 = _decoded_signals_T_31 ? 5'h7 : _decoded_signals_T_97; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_99 = _decoded_signals_T_29 ? 5'h6 : _decoded_signals_T_98; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_100 = _decoded_signals_T_27 ? 5'h8 : _decoded_signals_T_99; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_101 = _decoded_signals_T_25 ? 5'h7 : _decoded_signals_T_100; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_102 = _decoded_signals_T_23 ? 5'h6 : _decoded_signals_T_101; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_103 = _decoded_signals_T_21 ? 5'h5 : _decoded_signals_T_102; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_104 = _decoded_signals_T_19 ? 5'h4 : _decoded_signals_T_103; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_105 = _decoded_signals_T_17 ? 5'h3 : _decoded_signals_T_104; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_106 = _decoded_signals_T_15 ? 5'h5 : _decoded_signals_T_105; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_107 = _decoded_signals_T_13 ? 5'h4 : _decoded_signals_T_106; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_108 = _decoded_signals_T_11 ? 5'h3 : _decoded_signals_T_107; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_109 = _decoded_signals_T_9 ? 5'h2 : _decoded_signals_T_108; // @[Lookup.scala 33:37]
  wire [4:0] _decoded_signals_T_110 = _decoded_signals_T_7 ? 5'h1 : _decoded_signals_T_109; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_113 = _decoded_signals_T_75 ? 2'h2 : 2'h0; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_114 = _decoded_signals_T_73 ? 2'h3 : _decoded_signals_T_113; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_115 = _decoded_signals_T_71 ? 2'h0 : _decoded_signals_T_114; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_116 = _decoded_signals_T_69 ? 2'h3 : _decoded_signals_T_115; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_117 = _decoded_signals_T_67 ? 2'h0 : _decoded_signals_T_116; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_118 = _decoded_signals_T_65 ? 2'h3 : _decoded_signals_T_117; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_119 = _decoded_signals_T_63 ? 2'h0 : _decoded_signals_T_118; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_120 = _decoded_signals_T_61 ? 2'h1 : _decoded_signals_T_119; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_121 = _decoded_signals_T_59 ? 2'h2 : _decoded_signals_T_120; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_122 = _decoded_signals_T_57 ? 2'h0 : _decoded_signals_T_121; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_123 = _decoded_signals_T_55 ? 2'h1 : _decoded_signals_T_122; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_124 = _decoded_signals_T_53 ? 2'h0 : _decoded_signals_T_123; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_125 = _decoded_signals_T_51 ? 2'h0 : _decoded_signals_T_124; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_126 = _decoded_signals_T_49 ? 2'h0 : _decoded_signals_T_125; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_127 = _decoded_signals_T_47 ? 2'h0 : _decoded_signals_T_126; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_128 = _decoded_signals_T_45 ? 2'h0 : _decoded_signals_T_127; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_129 = _decoded_signals_T_43 ? 2'h0 : _decoded_signals_T_128; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_130 = _decoded_signals_T_41 ? 2'h0 : _decoded_signals_T_129; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_131 = _decoded_signals_T_39 ? 2'h0 : _decoded_signals_T_130; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_132 = _decoded_signals_T_37 ? 2'h0 : _decoded_signals_T_131; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_133 = _decoded_signals_T_35 ? 2'h0 : _decoded_signals_T_132; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_134 = _decoded_signals_T_33 ? 2'h0 : _decoded_signals_T_133; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_135 = _decoded_signals_T_31 ? 2'h0 : _decoded_signals_T_134; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_136 = _decoded_signals_T_29 ? 2'h0 : _decoded_signals_T_135; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_137 = _decoded_signals_T_27 ? 2'h0 : _decoded_signals_T_136; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_138 = _decoded_signals_T_25 ? 2'h0 : _decoded_signals_T_137; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_139 = _decoded_signals_T_23 ? 2'h0 : _decoded_signals_T_138; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_140 = _decoded_signals_T_21 ? 2'h0 : _decoded_signals_T_139; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_141 = _decoded_signals_T_19 ? 2'h0 : _decoded_signals_T_140; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_142 = _decoded_signals_T_17 ? 2'h0 : _decoded_signals_T_141; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_143 = _decoded_signals_T_15 ? 2'h0 : _decoded_signals_T_142; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_144 = _decoded_signals_T_13 ? 2'h0 : _decoded_signals_T_143; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_145 = _decoded_signals_T_11 ? 2'h0 : _decoded_signals_T_144; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_146 = _decoded_signals_T_9 ? 2'h0 : _decoded_signals_T_145; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_147 = _decoded_signals_T_7 ? 2'h0 : _decoded_signals_T_146; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_148 = _decoded_signals_T_5 ? 2'h0 : _decoded_signals_T_147; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_149 = _decoded_signals_T_3 ? 2'h0 : _decoded_signals_T_148; // @[Lookup.scala 33:37]
  wire [1:0] decoded_signals_1 = _decoded_signals_T_1 ? 2'h0 : _decoded_signals_T_149; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_150 = _decoded_signals_T_75 ? 3'h0 : 3'h1; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_151 = _decoded_signals_T_73 ? 3'h0 : _decoded_signals_T_150; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_152 = _decoded_signals_T_71 ? 3'h0 : _decoded_signals_T_151; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_153 = _decoded_signals_T_69 ? 3'h0 : _decoded_signals_T_152; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_154 = _decoded_signals_T_67 ? 3'h0 : _decoded_signals_T_153; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_155 = _decoded_signals_T_65 ? 3'h0 : _decoded_signals_T_154; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_156 = _decoded_signals_T_63 ? 3'h0 : _decoded_signals_T_155; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_157 = _decoded_signals_T_61 ? 3'h5 : _decoded_signals_T_156; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_158 = _decoded_signals_T_59 ? 3'h5 : _decoded_signals_T_157; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_159 = _decoded_signals_T_57 ? 3'h2 : _decoded_signals_T_158; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_160 = _decoded_signals_T_55 ? 3'h4 : _decoded_signals_T_159; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_161 = _decoded_signals_T_53 ? 3'h1 : _decoded_signals_T_160; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_162 = _decoded_signals_T_51 ? 3'h1 : _decoded_signals_T_161; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_163 = _decoded_signals_T_49 ? 3'h1 : _decoded_signals_T_162; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_164 = _decoded_signals_T_47 ? 3'h1 : _decoded_signals_T_163; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_165 = _decoded_signals_T_45 ? 3'h1 : _decoded_signals_T_164; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_166 = _decoded_signals_T_43 ? 3'h1 : _decoded_signals_T_165; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_167 = _decoded_signals_T_41 ? 3'h2 : _decoded_signals_T_166; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_168 = _decoded_signals_T_39 ? 3'h2 : _decoded_signals_T_167; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_169 = _decoded_signals_T_37 ? 3'h1 : _decoded_signals_T_168; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_170 = _decoded_signals_T_35 ? 3'h1 : _decoded_signals_T_169; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_171 = _decoded_signals_T_33 ? 3'h2 : _decoded_signals_T_170; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_172 = _decoded_signals_T_31 ? 3'h2 : _decoded_signals_T_171; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_173 = _decoded_signals_T_29 ? 3'h2 : _decoded_signals_T_172; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_174 = _decoded_signals_T_27 ? 3'h1 : _decoded_signals_T_173; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_175 = _decoded_signals_T_25 ? 3'h1 : _decoded_signals_T_174; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_176 = _decoded_signals_T_23 ? 3'h1 : _decoded_signals_T_175; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_177 = _decoded_signals_T_21 ? 3'h2 : _decoded_signals_T_176; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_178 = _decoded_signals_T_19 ? 3'h2 : _decoded_signals_T_177; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_179 = _decoded_signals_T_17 ? 3'h2 : _decoded_signals_T_178; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_180 = _decoded_signals_T_15 ? 3'h1 : _decoded_signals_T_179; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_181 = _decoded_signals_T_13 ? 3'h1 : _decoded_signals_T_180; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_182 = _decoded_signals_T_11 ? 3'h1 : _decoded_signals_T_181; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_183 = _decoded_signals_T_9 ? 3'h1 : _decoded_signals_T_182; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_184 = _decoded_signals_T_7 ? 3'h2 : _decoded_signals_T_183; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_185 = _decoded_signals_T_5 ? 3'h1 : _decoded_signals_T_184; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_186 = _decoded_signals_T_3 ? 3'h3 : _decoded_signals_T_185; // @[Lookup.scala 33:37]
  wire [2:0] decoded_signals_2 = _decoded_signals_T_1 ? 3'h2 : _decoded_signals_T_186; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_225 = _decoded_signals_T_73 ? 2'h1 : 2'h0; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_226 = _decoded_signals_T_71 ? 2'h1 : _decoded_signals_T_225; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_227 = _decoded_signals_T_69 ? 2'h1 : _decoded_signals_T_226; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_228 = _decoded_signals_T_67 ? 2'h1 : _decoded_signals_T_227; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_229 = _decoded_signals_T_65 ? 2'h1 : _decoded_signals_T_228; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_230 = _decoded_signals_T_63 ? 2'h1 : _decoded_signals_T_229; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_231 = _decoded_signals_T_61 ? 2'h1 : _decoded_signals_T_230; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_232 = _decoded_signals_T_59 ? 2'h1 : _decoded_signals_T_231; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_233 = _decoded_signals_T_57 ? 2'h1 : _decoded_signals_T_232; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_234 = _decoded_signals_T_55 ? 2'h1 : _decoded_signals_T_233; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_235 = _decoded_signals_T_53 ? 2'h0 : _decoded_signals_T_234; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_236 = _decoded_signals_T_51 ? 2'h0 : _decoded_signals_T_235; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_237 = _decoded_signals_T_49 ? 2'h0 : _decoded_signals_T_236; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_238 = _decoded_signals_T_47 ? 2'h0 : _decoded_signals_T_237; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_239 = _decoded_signals_T_45 ? 2'h0 : _decoded_signals_T_238; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_240 = _decoded_signals_T_43 ? 2'h0 : _decoded_signals_T_239; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_241 = _decoded_signals_T_41 ? 2'h1 : _decoded_signals_T_240; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_242 = _decoded_signals_T_39 ? 2'h1 : _decoded_signals_T_241; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_243 = _decoded_signals_T_37 ? 2'h1 : _decoded_signals_T_242; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_244 = _decoded_signals_T_35 ? 2'h1 : _decoded_signals_T_243; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_245 = _decoded_signals_T_33 ? 2'h1 : _decoded_signals_T_244; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_246 = _decoded_signals_T_31 ? 2'h1 : _decoded_signals_T_245; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_247 = _decoded_signals_T_29 ? 2'h1 : _decoded_signals_T_246; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_248 = _decoded_signals_T_27 ? 2'h1 : _decoded_signals_T_247; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_249 = _decoded_signals_T_25 ? 2'h1 : _decoded_signals_T_248; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_250 = _decoded_signals_T_23 ? 2'h1 : _decoded_signals_T_249; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_251 = _decoded_signals_T_21 ? 2'h1 : _decoded_signals_T_250; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_252 = _decoded_signals_T_19 ? 2'h1 : _decoded_signals_T_251; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_253 = _decoded_signals_T_17 ? 2'h1 : _decoded_signals_T_252; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_254 = _decoded_signals_T_15 ? 2'h1 : _decoded_signals_T_253; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_255 = _decoded_signals_T_13 ? 2'h1 : _decoded_signals_T_254; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_256 = _decoded_signals_T_11 ? 2'h1 : _decoded_signals_T_255; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_257 = _decoded_signals_T_9 ? 2'h1 : _decoded_signals_T_256; // @[Lookup.scala 33:37]
  wire [1:0] _decoded_signals_T_258 = _decoded_signals_T_7 ? 2'h1 : _decoded_signals_T_257; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_262 = _decoded_signals_T_73 ? 3'h3 : 3'h0; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_263 = _decoded_signals_T_71 ? 3'h3 : _decoded_signals_T_262; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_264 = _decoded_signals_T_69 ? 3'h3 : _decoded_signals_T_263; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_265 = _decoded_signals_T_67 ? 3'h3 : _decoded_signals_T_264; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_266 = _decoded_signals_T_65 ? 3'h3 : _decoded_signals_T_265; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_267 = _decoded_signals_T_63 ? 3'h3 : _decoded_signals_T_266; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_268 = _decoded_signals_T_61 ? 3'h0 : _decoded_signals_T_267; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_269 = _decoded_signals_T_59 ? 3'h0 : _decoded_signals_T_268; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_270 = _decoded_signals_T_57 ? 3'h2 : _decoded_signals_T_269; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_271 = _decoded_signals_T_55 ? 3'h2 : _decoded_signals_T_270; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_272 = _decoded_signals_T_53 ? 3'h0 : _decoded_signals_T_271; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_273 = _decoded_signals_T_51 ? 3'h0 : _decoded_signals_T_272; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_274 = _decoded_signals_T_49 ? 3'h0 : _decoded_signals_T_273; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_275 = _decoded_signals_T_47 ? 3'h0 : _decoded_signals_T_274; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_276 = _decoded_signals_T_45 ? 3'h0 : _decoded_signals_T_275; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_277 = _decoded_signals_T_43 ? 3'h0 : _decoded_signals_T_276; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_278 = _decoded_signals_T_41 ? 3'h0 : _decoded_signals_T_277; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_279 = _decoded_signals_T_39 ? 3'h0 : _decoded_signals_T_278; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_280 = _decoded_signals_T_37 ? 3'h0 : _decoded_signals_T_279; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_281 = _decoded_signals_T_35 ? 3'h0 : _decoded_signals_T_280; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_282 = _decoded_signals_T_33 ? 3'h0 : _decoded_signals_T_281; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_283 = _decoded_signals_T_31 ? 3'h0 : _decoded_signals_T_282; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_284 = _decoded_signals_T_29 ? 3'h0 : _decoded_signals_T_283; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_285 = _decoded_signals_T_27 ? 3'h0 : _decoded_signals_T_284; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_286 = _decoded_signals_T_25 ? 3'h0 : _decoded_signals_T_285; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_287 = _decoded_signals_T_23 ? 3'h0 : _decoded_signals_T_286; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_288 = _decoded_signals_T_21 ? 3'h0 : _decoded_signals_T_287; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_289 = _decoded_signals_T_19 ? 3'h0 : _decoded_signals_T_288; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_290 = _decoded_signals_T_17 ? 3'h0 : _decoded_signals_T_289; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_291 = _decoded_signals_T_15 ? 3'h0 : _decoded_signals_T_290; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_292 = _decoded_signals_T_13 ? 3'h0 : _decoded_signals_T_291; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_293 = _decoded_signals_T_11 ? 3'h0 : _decoded_signals_T_292; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_294 = _decoded_signals_T_9 ? 3'h0 : _decoded_signals_T_293; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_295 = _decoded_signals_T_7 ? 3'h0 : _decoded_signals_T_294; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_298 = _decoded_signals_T_75 ? 3'h4 : 3'h0; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_299 = _decoded_signals_T_73 ? 3'h3 : _decoded_signals_T_298; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_300 = _decoded_signals_T_71 ? 3'h3 : _decoded_signals_T_299; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_301 = _decoded_signals_T_69 ? 3'h2 : _decoded_signals_T_300; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_302 = _decoded_signals_T_67 ? 3'h2 : _decoded_signals_T_301; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_303 = _decoded_signals_T_65 ? 3'h1 : _decoded_signals_T_302; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_304 = _decoded_signals_T_63 ? 3'h1 : _decoded_signals_T_303; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_305 = _decoded_signals_T_61 ? 3'h0 : _decoded_signals_T_304; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_306 = _decoded_signals_T_59 ? 3'h0 : _decoded_signals_T_305; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_307 = _decoded_signals_T_57 ? 3'h0 : _decoded_signals_T_306; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_308 = _decoded_signals_T_55 ? 3'h0 : _decoded_signals_T_307; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_309 = _decoded_signals_T_53 ? 3'h0 : _decoded_signals_T_308; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_310 = _decoded_signals_T_51 ? 3'h0 : _decoded_signals_T_309; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_311 = _decoded_signals_T_49 ? 3'h0 : _decoded_signals_T_310; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_312 = _decoded_signals_T_47 ? 3'h0 : _decoded_signals_T_311; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_313 = _decoded_signals_T_45 ? 3'h0 : _decoded_signals_T_312; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_314 = _decoded_signals_T_43 ? 3'h0 : _decoded_signals_T_313; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_315 = _decoded_signals_T_41 ? 3'h0 : _decoded_signals_T_314; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_316 = _decoded_signals_T_39 ? 3'h0 : _decoded_signals_T_315; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_317 = _decoded_signals_T_37 ? 3'h0 : _decoded_signals_T_316; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_318 = _decoded_signals_T_35 ? 3'h0 : _decoded_signals_T_317; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_319 = _decoded_signals_T_33 ? 3'h0 : _decoded_signals_T_318; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_320 = _decoded_signals_T_31 ? 3'h0 : _decoded_signals_T_319; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_321 = _decoded_signals_T_29 ? 3'h0 : _decoded_signals_T_320; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_322 = _decoded_signals_T_27 ? 3'h0 : _decoded_signals_T_321; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_323 = _decoded_signals_T_25 ? 3'h0 : _decoded_signals_T_322; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_324 = _decoded_signals_T_23 ? 3'h0 : _decoded_signals_T_323; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_325 = _decoded_signals_T_21 ? 3'h0 : _decoded_signals_T_324; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_326 = _decoded_signals_T_19 ? 3'h0 : _decoded_signals_T_325; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_327 = _decoded_signals_T_17 ? 3'h0 : _decoded_signals_T_326; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_328 = _decoded_signals_T_15 ? 3'h0 : _decoded_signals_T_327; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_329 = _decoded_signals_T_13 ? 3'h0 : _decoded_signals_T_328; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_330 = _decoded_signals_T_11 ? 3'h0 : _decoded_signals_T_329; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_331 = _decoded_signals_T_9 ? 3'h0 : _decoded_signals_T_330; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_332 = _decoded_signals_T_7 ? 3'h0 : _decoded_signals_T_331; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_333 = _decoded_signals_T_5 ? 3'h0 : _decoded_signals_T_332; // @[Lookup.scala 33:37]
  wire [2:0] _decoded_signals_T_334 = _decoded_signals_T_3 ? 3'h0 : _decoded_signals_T_333; // @[Lookup.scala 33:37]
  wire [2:0] decoded_signals_6 = _decoded_signals_T_1 ? 3'h0 : _decoded_signals_T_334; // @[Lookup.scala 33:37]
  wire  _id_operand1_data_T = decoded_signals_1 == 2'h0; // @[Core.scala 207:24]
  wire  _id_operand1_data_T_1 = decoded_signals_1 == 2'h1; // @[Core.scala 208:24]
  wire  _id_operand2_data_T = decoded_signals_2 == 3'h1; // @[Core.scala 216:24]
  wire  _id_operand2_data_T_1 = decoded_signals_2 == 3'h2; // @[Core.scala 217:24]
  wire  _id_operand2_data_T_2 = decoded_signals_2 == 3'h3; // @[Core.scala 218:24]
  wire  _id_operand2_data_T_3 = decoded_signals_2 == 3'h4; // @[Core.scala 219:24]
  wire  _id_operand2_data_T_4 = decoded_signals_2 == 3'h5; // @[Core.scala 220:24]
  wire [31:0] _id_operand2_data_T_5 = _id_operand2_data_T_4 ? id_imm_u_shifted : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _id_operand2_data_T_6 = _id_operand2_data_T_3 ? id_imm_j_sext : _id_operand2_data_T_5; // @[Mux.scala 98:16]
  wire  _csr_wdata_T = mem_csr_cmd == 3'h1; // @[Core.scala 309:20]
  wire  _csr_wdata_T_1 = mem_csr_cmd == 3'h2; // @[Core.scala 310:20]
  wire [31:0] _csr_wdata_T_2 = csr_regfile_csr_rdata_data | mem_operand1; // @[Core.scala 310:45]
  wire  _csr_wdata_T_3 = mem_csr_cmd == 3'h3; // @[Core.scala 311:20]
  wire [31:0] _csr_wdata_T_4 = ~mem_operand1; // @[Core.scala 311:47]
  wire [31:0] _csr_wdata_T_5 = csr_regfile_csr_rdata_data & _csr_wdata_T_4; // @[Core.scala 311:45]
  wire  _csr_wdata_T_6 = mem_csr_cmd == 3'h4; // @[Core.scala 312:20]
  wire [31:0] _csr_wdata_T_7 = _csr_wdata_T_6 ? 32'hb : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _csr_wdata_T_8 = _csr_wdata_T_3 ? _csr_wdata_T_5 : _csr_wdata_T_7; // @[Mux.scala 98:16]
  wire [31:0] _csr_wdata_T_9 = _csr_wdata_T_1 ? _csr_wdata_T_2 : _csr_wdata_T_8; // @[Mux.scala 98:16]
  wire  _T_3 = ~reset; // @[Core.scala 346:9]
  assign regfile_id_rs1_data_MPORT_addr = id_inst[19:15];
  assign regfile_id_rs1_data_MPORT_data = regfile[regfile_id_rs1_data_MPORT_addr]; // @[Core.scala 17:20]
  assign regfile_id_rs2_data_MPORT_addr = id_inst[24:20];
  assign regfile_id_rs2_data_MPORT_data = regfile[regfile_id_rs2_data_MPORT_addr]; // @[Core.scala 17:20]
  assign regfile_io_gp_MPORT_addr = 5'h3;
  assign regfile_io_gp_MPORT_data = regfile[regfile_io_gp_MPORT_addr]; // @[Core.scala 17:20]
  assign regfile_MPORT_2_addr = 5'h3;
  assign regfile_MPORT_2_data = regfile[regfile_MPORT_2_addr]; // @[Core.scala 17:20]
  assign regfile_MPORT_1_data = wb_writeback_data;
  assign regfile_MPORT_1_addr = wb_rd_addr;
  assign regfile_MPORT_1_mask = 1'h1;
  assign regfile_MPORT_1_en = wb_writeback_enable == 2'h1;
  assign csr_regfile_if_pc_next_MPORT_addr = 12'h305;
  assign csr_regfile_if_pc_next_MPORT_data = csr_regfile[csr_regfile_if_pc_next_MPORT_addr]; // @[Core.scala 19:24]
  assign csr_regfile_csr_rdata_addr = mem_csr_addr;
  assign csr_regfile_csr_rdata_data = csr_regfile[csr_regfile_csr_rdata_addr]; // @[Core.scala 19:24]
  assign csr_regfile_MPORT_data = _csr_wdata_T ? mem_operand1 : _csr_wdata_T_9;
  assign csr_regfile_MPORT_addr = mem_csr_addr;
  assign csr_regfile_MPORT_mask = 1'h1;
  assign csr_regfile_MPORT_en = mem_csr_cmd > 3'h0;
  assign io_core_inst_io_addr = if_pc; // @[Core.scala 66:24]
  assign io_core_data_io_addr = mem_alu_out; // @[Core.scala 298:24]
  assign io_core_data_io_write_enable = mem_memory_write_enable[0]; // @[Core.scala 299:32]
  assign io_core_data_io_write_data = mem_rs2_data; // @[Core.scala 300:30]
  assign io_exit = mem_pc == 32'h44; // @[Core.scala 343:22]
  assign io_gp = regfile_io_gp_MPORT_data; // @[Core.scala 342:9]
  always @(posedge clock) begin
    if(regfile_MPORT_1_en & regfile_MPORT_1_mask) begin
      regfile[regfile_MPORT_1_addr] <= regfile_MPORT_1_data; // @[Core.scala 17:20]
    end
    if(csr_regfile_MPORT_en & csr_regfile_MPORT_mask) begin
      csr_regfile[csr_regfile_MPORT_addr] <= csr_regfile_MPORT_data; // @[Core.scala 19:24]
    end
    if (reset) begin // @[Core.scala 23:22]
      id_pc <= 32'h0; // @[Core.scala 23:22]
    end else if (!(stall_flag)) begin // @[Core.scala 90:15]
      id_pc <= if_pc;
    end
    if (reset) begin // @[Core.scala 24:33]
      id_original_inst <= 32'h0; // @[Core.scala 24:33]
    end else if (_id_original_inst_T) begin // @[Mux.scala 98:16]
      id_original_inst <= 32'h13;
    end else if (!(stall_flag)) begin // @[Mux.scala 98:16]
      id_original_inst <= io_core_inst_io_inst;
    end
    if (reset) begin // @[Core.scala 27:22]
      ex_pc <= 32'h0; // @[Core.scala 27:22]
    end else begin
      ex_pc <= id_pc; // @[Core.scala 228:9]
    end
    if (reset) begin // @[Core.scala 28:27]
      ex_rd_addr <= 5'h0; // @[Core.scala 28:27]
    end else begin
      ex_rd_addr <= id_rd_addr; // @[Core.scala 232:14]
    end
    if (reset) begin // @[Core.scala 29:33]
      ex_operand1_data <= 32'h0; // @[Core.scala 29:33]
    end else if (_id_operand1_data_T) begin // @[Mux.scala 98:16]
      if (_id_rs1_data_T) begin // @[Mux.scala 98:16]
        ex_operand1_data <= 32'h0;
      end else if (_id_rs1_data_T_3) begin // @[Mux.scala 98:16]
        ex_operand1_data <= mem_writeback_data;
      end else begin
        ex_operand1_data <= _id_rs1_data_T_7;
      end
    end else if (_id_operand1_data_T_1) begin // @[Mux.scala 98:16]
      ex_operand1_data <= id_pc;
    end else begin
      ex_operand1_data <= 32'h0;
    end
    if (reset) begin // @[Core.scala 30:33]
      ex_operand2_data <= 32'h0; // @[Core.scala 30:33]
    end else if (_id_operand2_data_T) begin // @[Mux.scala 98:16]
      if (_id_rs2_data_T) begin // @[Mux.scala 98:16]
        ex_operand2_data <= 32'h0;
      end else if (_id_rs2_data_T_3) begin // @[Mux.scala 98:16]
        ex_operand2_data <= mem_writeback_data;
      end else begin
        ex_operand2_data <= _id_rs2_data_T_7;
      end
    end else if (_id_operand2_data_T_1) begin // @[Mux.scala 98:16]
      ex_operand2_data <= id_imm_i_sext;
    end else if (_id_operand2_data_T_2) begin // @[Mux.scala 98:16]
      ex_operand2_data <= id_imm_s_sext;
    end else begin
      ex_operand2_data <= _id_operand2_data_T_6;
    end
    if (reset) begin // @[Core.scala 31:28]
      ex_rs2_data <= 32'h0; // @[Core.scala 31:28]
    end else if (_id_rs2_data_T) begin // @[Mux.scala 98:16]
      ex_rs2_data <= 32'h0;
    end else if (_id_rs2_data_T_3) begin // @[Mux.scala 98:16]
      if (_mem_writeback_data_T) begin // @[Mux.scala 98:16]
        ex_rs2_data <= io_core_data_io_read_data;
      end else begin
        ex_rs2_data <= _mem_writeback_data_T_6;
      end
    end else if (_id_rs2_data_T_6) begin // @[Mux.scala 98:16]
      ex_rs2_data <= wb_writeback_data;
    end else begin
      ex_rs2_data <= regfile_id_rs2_data_MPORT_data;
    end
    if (reset) begin // @[Core.scala 32:29]
      ex_inst_type <= 5'h0; // @[Core.scala 32:29]
    end else if (_decoded_signals_T_1) begin // @[Lookup.scala 33:37]
      ex_inst_type <= 5'h1;
    end else if (_decoded_signals_T_3) begin // @[Lookup.scala 33:37]
      ex_inst_type <= 5'h1;
    end else if (_decoded_signals_T_5) begin // @[Lookup.scala 33:37]
      ex_inst_type <= 5'h1;
    end else begin
      ex_inst_type <= _decoded_signals_T_110;
    end
    if (reset) begin // @[Core.scala 33:39]
      ex_memory_write_enable <= 2'h0; // @[Core.scala 33:39]
    end else if (_decoded_signals_T_1) begin // @[Lookup.scala 33:37]
      ex_memory_write_enable <= 2'h0;
    end else if (_decoded_signals_T_3) begin // @[Lookup.scala 33:37]
      ex_memory_write_enable <= 2'h1;
    end else begin
      ex_memory_write_enable <= 2'h0;
    end
    if (reset) begin // @[Core.scala 34:36]
      ex_writeback_enable <= 2'h0; // @[Core.scala 34:36]
    end else if (_decoded_signals_T_1) begin // @[Lookup.scala 33:37]
      ex_writeback_enable <= 2'h1;
    end else if (_decoded_signals_T_3) begin // @[Lookup.scala 33:37]
      ex_writeback_enable <= 2'h0;
    end else if (_decoded_signals_T_5) begin // @[Lookup.scala 33:37]
      ex_writeback_enable <= 2'h1;
    end else begin
      ex_writeback_enable <= _decoded_signals_T_258;
    end
    if (reset) begin // @[Core.scala 35:33]
      ex_writeback_src <= 3'h0; // @[Core.scala 35:33]
    end else if (_decoded_signals_T_1) begin // @[Lookup.scala 33:37]
      ex_writeback_src <= 3'h1;
    end else if (_decoded_signals_T_3) begin // @[Lookup.scala 33:37]
      ex_writeback_src <= 3'h0;
    end else if (_decoded_signals_T_5) begin // @[Lookup.scala 33:37]
      ex_writeback_src <= 3'h0;
    end else begin
      ex_writeback_src <= _decoded_signals_T_295;
    end
    if (reset) begin // @[Core.scala 36:28]
      ex_csr_addr <= 12'h0; // @[Core.scala 36:28]
    end else if (decoded_signals_6 == 3'h4) begin // @[Core.scala 224:24]
      ex_csr_addr <= 12'h342;
    end else begin
      ex_csr_addr <= id_imm_i;
    end
    if (reset) begin // @[Core.scala 37:27]
      ex_csr_cmd <= 3'h0; // @[Core.scala 37:27]
    end else if (_decoded_signals_T_1) begin // @[Lookup.scala 33:37]
      ex_csr_cmd <= 3'h0;
    end else if (_decoded_signals_T_3) begin // @[Lookup.scala 33:37]
      ex_csr_cmd <= 3'h0;
    end else if (_decoded_signals_T_5) begin // @[Lookup.scala 33:37]
      ex_csr_cmd <= 3'h0;
    end else begin
      ex_csr_cmd <= _decoded_signals_T_332;
    end
    if (reset) begin // @[Core.scala 40:30]
      ex_imm_b_sext <= 32'h0; // @[Core.scala 40:30]
    end else begin
      ex_imm_b_sext <= id_imm_b_sext; // @[Core.scala 238:17]
    end
    if (reset) begin // @[Core.scala 45:23]
      mem_pc <= 32'h0; // @[Core.scala 45:23]
    end else begin
      mem_pc <= ex_pc; // @[Core.scala 285:10]
    end
    if (reset) begin // @[Core.scala 46:28]
      mem_rd_addr <= 5'h0; // @[Core.scala 46:28]
    end else begin
      mem_rd_addr <= ex_rd_addr; // @[Core.scala 288:15]
    end
    if (reset) begin // @[Core.scala 47:29]
      mem_operand1 <= 32'h0; // @[Core.scala 47:29]
    end else begin
      mem_operand1 <= ex_operand1_data; // @[Core.scala 286:16]
    end
    if (reset) begin // @[Core.scala 48:29]
      mem_rs2_data <= 32'h0; // @[Core.scala 48:29]
    end else begin
      mem_rs2_data <= ex_rs2_data; // @[Core.scala 287:16]
    end
    if (reset) begin // @[Core.scala 49:40]
      mem_memory_write_enable <= 2'h0; // @[Core.scala 49:40]
    end else begin
      mem_memory_write_enable <= ex_memory_write_enable; // @[Core.scala 295:27]
    end
    if (reset) begin // @[Core.scala 50:37]
      mem_writeback_enable <= 2'h0; // @[Core.scala 50:37]
    end else begin
      mem_writeback_enable <= ex_writeback_enable; // @[Core.scala 290:24]
    end
    if (reset) begin // @[Core.scala 51:34]
      mem_writeback_src <= 3'h0; // @[Core.scala 51:34]
    end else begin
      mem_writeback_src <= ex_writeback_src; // @[Core.scala 291:21]
    end
    if (reset) begin // @[Core.scala 52:29]
      mem_csr_addr <= 12'h0; // @[Core.scala 52:29]
    end else begin
      mem_csr_addr <= ex_csr_addr; // @[Core.scala 292:16]
    end
    if (reset) begin // @[Core.scala 53:28]
      mem_csr_cmd <= 3'h0; // @[Core.scala 53:28]
    end else begin
      mem_csr_cmd <= ex_csr_cmd; // @[Core.scala 293:15]
    end
    if (reset) begin // @[Core.scala 55:28]
      mem_alu_out <= 32'h0; // @[Core.scala 55:28]
    end else if (_ex_alu_out_T) begin // @[Mux.scala 98:16]
      mem_alu_out <= _ex_alu_out_T_2;
    end else if (_ex_alu_out_T_3) begin // @[Mux.scala 98:16]
      mem_alu_out <= _ex_alu_out_T_5;
    end else if (_ex_alu_out_T_6) begin // @[Mux.scala 98:16]
      mem_alu_out <= _ex_alu_out_T_7;
    end else begin
      mem_alu_out <= _ex_alu_out_T_40;
    end
    if (reset) begin // @[Core.scala 59:27]
      wb_rd_addr <= 5'h0; // @[Core.scala 59:27]
    end else begin
      wb_rd_addr <= mem_rd_addr; // @[Core.scala 332:14]
    end
    if (reset) begin // @[Core.scala 60:36]
      wb_writeback_enable <= 2'h0; // @[Core.scala 60:36]
    end else begin
      wb_writeback_enable <= mem_writeback_enable; // @[Core.scala 333:23]
    end
    if (reset) begin // @[Core.scala 61:34]
      wb_writeback_data <= 32'h0; // @[Core.scala 61:34]
    end else if (_mem_writeback_data_T) begin // @[Mux.scala 98:16]
      wb_writeback_data <= io_core_data_io_read_data;
    end else if (_mem_writeback_data_T_1) begin // @[Mux.scala 98:16]
      wb_writeback_data <= _mem_writeback_data_T_3;
    end else if (_mem_writeback_data_T_4) begin // @[Mux.scala 98:16]
      wb_writeback_data <= csr_regfile_csr_rdata_data;
    end else begin
      wb_writeback_data <= mem_alu_out;
    end
    if (reset) begin // @[Core.scala 65:22]
      if_pc <= 32'h0; // @[Core.scala 65:22]
    end else if (ex_branch_flag) begin // @[Mux.scala 98:16]
      if_pc <= ex_branch_target;
    end else if (ex_jump_flag) begin // @[Mux.scala 98:16]
      if (_ex_alu_out_T) begin // @[Mux.scala 98:16]
        if_pc <= _ex_alu_out_T_2;
      end else begin
        if_pc <= _ex_alu_out_T_42;
      end
    end else if (_if_pc_next_T_3) begin // @[Mux.scala 98:16]
      if_pc <= csr_regfile_if_pc_next_MPORT_data;
    end else begin
      if_pc <= _if_pc_next_T_4;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~reset) begin
          $fwrite(32'h80000002,"if_pc                     : 0x%x\n",if_pc); // @[Core.scala 346:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"id_pc                     : 0x%x\n",id_pc); // @[Core.scala 347:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"id_original_inst          : 0x%x\n",id_original_inst); // @[Core.scala 348:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"id_rs1_data               : 0x%x\n",id_rs1_data); // @[Core.scala 349:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"id_rs2_data               : 0x%x\n",id_rs2_data); // @[Core.scala 350:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"ex_pc                     : 0x%x\n",ex_pc); // @[Core.scala 351:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"ex_operand1_data          : 0x%x\n",ex_operand1_data); // @[Core.scala 352:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"ex_operand2_data          : 0x%x\n",ex_operand2_data); // @[Core.scala 353:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"ex_alu_out                : 0x%x\n",ex_alu_out); // @[Core.scala 354:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"mem_pc                    : 0x%x\n",mem_pc); // @[Core.scala 355:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"mem_writeback_data        : 0x%x\n",mem_writeback_data); // @[Core.scala 356:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"wb_writeback_data         : 0x%x\n",wb_writeback_data); // @[Core.scala 357:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"stall_flg                 : %d\n",stall_flag); // @[Core.scala 358:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"gp                        : %d\n",regfile_MPORT_2_data); // @[Core.scala 359:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"core_data_io.addr         : %d\n",io_core_data_io_addr); // @[Core.scala 360:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"core_data_io.write_enable : %d\n",io_core_data_io_write_enable); // @[Core.scala 361:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"core_data_io.write_data   : 0x%x\n",io_core_data_io_write_data); // @[Core.scala 362:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3) begin
          $fwrite(32'h80000002,"----------------\n"); // @[Core.scala 363:9]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    regfile[initvar] = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 4096; initvar = initvar+1)
    csr_regfile[initvar] = _RAND_1[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  id_pc = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  id_original_inst = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  ex_pc = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  ex_rd_addr = _RAND_5[4:0];
  _RAND_6 = {1{`RANDOM}};
  ex_operand1_data = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  ex_operand2_data = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  ex_rs2_data = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  ex_inst_type = _RAND_9[4:0];
  _RAND_10 = {1{`RANDOM}};
  ex_memory_write_enable = _RAND_10[1:0];
  _RAND_11 = {1{`RANDOM}};
  ex_writeback_enable = _RAND_11[1:0];
  _RAND_12 = {1{`RANDOM}};
  ex_writeback_src = _RAND_12[2:0];
  _RAND_13 = {1{`RANDOM}};
  ex_csr_addr = _RAND_13[11:0];
  _RAND_14 = {1{`RANDOM}};
  ex_csr_cmd = _RAND_14[2:0];
  _RAND_15 = {1{`RANDOM}};
  ex_imm_b_sext = _RAND_15[31:0];
  _RAND_16 = {1{`RANDOM}};
  mem_pc = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  mem_rd_addr = _RAND_17[4:0];
  _RAND_18 = {1{`RANDOM}};
  mem_operand1 = _RAND_18[31:0];
  _RAND_19 = {1{`RANDOM}};
  mem_rs2_data = _RAND_19[31:0];
  _RAND_20 = {1{`RANDOM}};
  mem_memory_write_enable = _RAND_20[1:0];
  _RAND_21 = {1{`RANDOM}};
  mem_writeback_enable = _RAND_21[1:0];
  _RAND_22 = {1{`RANDOM}};
  mem_writeback_src = _RAND_22[2:0];
  _RAND_23 = {1{`RANDOM}};
  mem_csr_addr = _RAND_23[11:0];
  _RAND_24 = {1{`RANDOM}};
  mem_csr_cmd = _RAND_24[2:0];
  _RAND_25 = {1{`RANDOM}};
  mem_alu_out = _RAND_25[31:0];
  _RAND_26 = {1{`RANDOM}};
  wb_rd_addr = _RAND_26[4:0];
  _RAND_27 = {1{`RANDOM}};
  wb_writeback_enable = _RAND_27[1:0];
  _RAND_28 = {1{`RANDOM}};
  wb_writeback_data = _RAND_28[31:0];
  _RAND_29 = {1{`RANDOM}};
  if_pc = _RAND_29[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Memory(
  input         clock,
  input  [31:0] io_memory_inst_io_addr,
  output [31:0] io_memory_inst_io_inst,
  input  [31:0] io_memory_data_io_addr,
  output [31:0] io_memory_data_io_read_data,
  input         io_memory_data_io_write_enable,
  input  [31:0] io_memory_data_io_write_data
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
  reg [7:0] memory [0:16383]; // @[Memory.scala 27:19]
  wire [7:0] memory_io_memory_inst_io_inst_hi_hi_data; // @[Memory.scala 27:19]
  wire [13:0] memory_io_memory_inst_io_inst_hi_hi_addr; // @[Memory.scala 27:19]
  wire [7:0] memory_io_memory_inst_io_inst_hi_lo_data; // @[Memory.scala 27:19]
  wire [13:0] memory_io_memory_inst_io_inst_hi_lo_addr; // @[Memory.scala 27:19]
  wire [7:0] memory_io_memory_inst_io_inst_lo_hi_data; // @[Memory.scala 27:19]
  wire [13:0] memory_io_memory_inst_io_inst_lo_hi_addr; // @[Memory.scala 27:19]
  wire [7:0] memory_io_memory_inst_io_inst_lo_lo_data; // @[Memory.scala 27:19]
  wire [13:0] memory_io_memory_inst_io_inst_lo_lo_addr; // @[Memory.scala 27:19]
  wire [7:0] memory_io_memory_data_io_read_data_hi_hi_data; // @[Memory.scala 27:19]
  wire [13:0] memory_io_memory_data_io_read_data_hi_hi_addr; // @[Memory.scala 27:19]
  wire [7:0] memory_io_memory_data_io_read_data_hi_lo_data; // @[Memory.scala 27:19]
  wire [13:0] memory_io_memory_data_io_read_data_hi_lo_addr; // @[Memory.scala 27:19]
  wire [7:0] memory_io_memory_data_io_read_data_lo_hi_data; // @[Memory.scala 27:19]
  wire [13:0] memory_io_memory_data_io_read_data_lo_hi_addr; // @[Memory.scala 27:19]
  wire [7:0] memory_io_memory_data_io_read_data_lo_lo_data; // @[Memory.scala 27:19]
  wire [13:0] memory_io_memory_data_io_read_data_lo_lo_addr; // @[Memory.scala 27:19]
  wire [7:0] memory_MPORT_data; // @[Memory.scala 27:19]
  wire [13:0] memory_MPORT_addr; // @[Memory.scala 27:19]
  wire  memory_MPORT_mask; // @[Memory.scala 27:19]
  wire  memory_MPORT_en; // @[Memory.scala 27:19]
  wire [7:0] memory_MPORT_1_data; // @[Memory.scala 27:19]
  wire [13:0] memory_MPORT_1_addr; // @[Memory.scala 27:19]
  wire  memory_MPORT_1_mask; // @[Memory.scala 27:19]
  wire  memory_MPORT_1_en; // @[Memory.scala 27:19]
  wire [7:0] memory_MPORT_2_data; // @[Memory.scala 27:19]
  wire [13:0] memory_MPORT_2_addr; // @[Memory.scala 27:19]
  wire  memory_MPORT_2_mask; // @[Memory.scala 27:19]
  wire  memory_MPORT_2_en; // @[Memory.scala 27:19]
  wire [7:0] memory_MPORT_3_data; // @[Memory.scala 27:19]
  wire [13:0] memory_MPORT_3_addr; // @[Memory.scala 27:19]
  wire  memory_MPORT_3_mask; // @[Memory.scala 27:19]
  wire  memory_MPORT_3_en; // @[Memory.scala 27:19]
  wire [31:0] _io_memory_inst_io_inst_T_1 = io_memory_inst_io_addr + 32'h3; // @[Memory.scala 34:35]
  wire [31:0] _io_memory_inst_io_inst_T_4 = io_memory_inst_io_addr + 32'h2; // @[Memory.scala 35:35]
  wire [31:0] _io_memory_inst_io_inst_T_7 = io_memory_inst_io_addr + 32'h1; // @[Memory.scala 36:35]
  wire [15:0] io_memory_inst_io_inst_lo = {memory_io_memory_inst_io_inst_lo_hi_data,
    memory_io_memory_inst_io_inst_lo_lo_data}; // @[Cat.scala 30:58]
  wire [15:0] io_memory_inst_io_inst_hi = {memory_io_memory_inst_io_inst_hi_hi_data,
    memory_io_memory_inst_io_inst_hi_lo_data}; // @[Cat.scala 30:58]
  wire [31:0] _io_memory_data_io_read_data_T_1 = io_memory_data_io_addr + 32'h3; // @[Memory.scala 41:35]
  wire [31:0] _io_memory_data_io_read_data_T_4 = io_memory_data_io_addr + 32'h2; // @[Memory.scala 42:35]
  wire [31:0] _io_memory_data_io_read_data_T_7 = io_memory_data_io_addr + 32'h1; // @[Memory.scala 43:35]
  wire [15:0] io_memory_data_io_read_data_lo = {memory_io_memory_data_io_read_data_lo_hi_data,
    memory_io_memory_data_io_read_data_lo_lo_data}; // @[Cat.scala 30:58]
  wire [15:0] io_memory_data_io_read_data_hi = {memory_io_memory_data_io_read_data_hi_hi_data,
    memory_io_memory_data_io_read_data_hi_lo_data}; // @[Cat.scala 30:58]
  assign memory_io_memory_inst_io_inst_hi_hi_addr = _io_memory_inst_io_inst_T_1[13:0];
  assign memory_io_memory_inst_io_inst_hi_hi_data = memory[memory_io_memory_inst_io_inst_hi_hi_addr]; // @[Memory.scala 27:19]
  assign memory_io_memory_inst_io_inst_hi_lo_addr = _io_memory_inst_io_inst_T_4[13:0];
  assign memory_io_memory_inst_io_inst_hi_lo_data = memory[memory_io_memory_inst_io_inst_hi_lo_addr]; // @[Memory.scala 27:19]
  assign memory_io_memory_inst_io_inst_lo_hi_addr = _io_memory_inst_io_inst_T_7[13:0];
  assign memory_io_memory_inst_io_inst_lo_hi_data = memory[memory_io_memory_inst_io_inst_lo_hi_addr]; // @[Memory.scala 27:19]
  assign memory_io_memory_inst_io_inst_lo_lo_addr = io_memory_inst_io_addr[13:0];
  assign memory_io_memory_inst_io_inst_lo_lo_data = memory[memory_io_memory_inst_io_inst_lo_lo_addr]; // @[Memory.scala 27:19]
  assign memory_io_memory_data_io_read_data_hi_hi_addr = _io_memory_data_io_read_data_T_1[13:0];
  assign memory_io_memory_data_io_read_data_hi_hi_data = memory[memory_io_memory_data_io_read_data_hi_hi_addr]; // @[Memory.scala 27:19]
  assign memory_io_memory_data_io_read_data_hi_lo_addr = _io_memory_data_io_read_data_T_4[13:0];
  assign memory_io_memory_data_io_read_data_hi_lo_data = memory[memory_io_memory_data_io_read_data_hi_lo_addr]; // @[Memory.scala 27:19]
  assign memory_io_memory_data_io_read_data_lo_hi_addr = _io_memory_data_io_read_data_T_7[13:0];
  assign memory_io_memory_data_io_read_data_lo_hi_data = memory[memory_io_memory_data_io_read_data_lo_hi_addr]; // @[Memory.scala 27:19]
  assign memory_io_memory_data_io_read_data_lo_lo_addr = io_memory_data_io_addr[13:0];
  assign memory_io_memory_data_io_read_data_lo_lo_data = memory[memory_io_memory_data_io_read_data_lo_lo_addr]; // @[Memory.scala 27:19]
  assign memory_MPORT_data = io_memory_data_io_write_data[7:0];
  assign memory_MPORT_addr = io_memory_data_io_addr[13:0];
  assign memory_MPORT_mask = 1'h1;
  assign memory_MPORT_en = io_memory_data_io_write_enable;
  assign memory_MPORT_1_data = io_memory_data_io_write_data[15:8];
  assign memory_MPORT_1_addr = _io_memory_data_io_read_data_T_7[13:0];
  assign memory_MPORT_1_mask = 1'h1;
  assign memory_MPORT_1_en = io_memory_data_io_write_enable;
  assign memory_MPORT_2_data = io_memory_data_io_write_data[23:16];
  assign memory_MPORT_2_addr = _io_memory_data_io_read_data_T_4[13:0];
  assign memory_MPORT_2_mask = 1'h1;
  assign memory_MPORT_2_en = io_memory_data_io_write_enable;
  assign memory_MPORT_3_data = io_memory_data_io_write_data[31:24];
  assign memory_MPORT_3_addr = _io_memory_data_io_read_data_T_1[13:0];
  assign memory_MPORT_3_mask = 1'h1;
  assign memory_MPORT_3_en = io_memory_data_io_write_enable;
  assign io_memory_inst_io_inst = {io_memory_inst_io_inst_hi,io_memory_inst_io_inst_lo}; // @[Cat.scala 30:58]
  assign io_memory_data_io_read_data = {io_memory_data_io_read_data_hi,io_memory_data_io_read_data_lo}; // @[Cat.scala 30:58]
  always @(posedge clock) begin
    if(memory_MPORT_en & memory_MPORT_mask) begin
      memory[memory_MPORT_addr] <= memory_MPORT_data; // @[Memory.scala 27:19]
    end
    if(memory_MPORT_1_en & memory_MPORT_1_mask) begin
      memory[memory_MPORT_1_addr] <= memory_MPORT_1_data; // @[Memory.scala 27:19]
    end
    if(memory_MPORT_2_en & memory_MPORT_2_mask) begin
      memory[memory_MPORT_2_addr] <= memory_MPORT_2_data; // @[Memory.scala 27:19]
    end
    if(memory_MPORT_3_en & memory_MPORT_3_mask) begin
      memory[memory_MPORT_3_addr] <= memory_MPORT_3_data; // @[Memory.scala 27:19]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 16384; initvar = initvar+1)
    memory[initvar] = _RAND_0[7:0];
`endif // RANDOMIZE_MEM_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Top(
  input         clock,
  input         reset,
  output        io_exit,
  output [31:0] io_gp
);
  wire  core_clock; // @[Top.scala 13:20]
  wire  core_reset; // @[Top.scala 13:20]
  wire [31:0] core_io_core_inst_io_addr; // @[Top.scala 13:20]
  wire [31:0] core_io_core_inst_io_inst; // @[Top.scala 13:20]
  wire [31:0] core_io_core_data_io_addr; // @[Top.scala 13:20]
  wire [31:0] core_io_core_data_io_read_data; // @[Top.scala 13:20]
  wire  core_io_core_data_io_write_enable; // @[Top.scala 13:20]
  wire [31:0] core_io_core_data_io_write_data; // @[Top.scala 13:20]
  wire  core_io_exit; // @[Top.scala 13:20]
  wire [31:0] core_io_gp; // @[Top.scala 13:20]
  wire  memory_clock; // @[Top.scala 14:22]
  wire [31:0] memory_io_memory_inst_io_addr; // @[Top.scala 14:22]
  wire [31:0] memory_io_memory_inst_io_inst; // @[Top.scala 14:22]
  wire [31:0] memory_io_memory_data_io_addr; // @[Top.scala 14:22]
  wire [31:0] memory_io_memory_data_io_read_data; // @[Top.scala 14:22]
  wire  memory_io_memory_data_io_write_enable; // @[Top.scala 14:22]
  wire [31:0] memory_io_memory_data_io_write_data; // @[Top.scala 14:22]
  Core core ( // @[Top.scala 13:20]
    .clock(core_clock),
    .reset(core_reset),
    .io_core_inst_io_addr(core_io_core_inst_io_addr),
    .io_core_inst_io_inst(core_io_core_inst_io_inst),
    .io_core_data_io_addr(core_io_core_data_io_addr),
    .io_core_data_io_read_data(core_io_core_data_io_read_data),
    .io_core_data_io_write_enable(core_io_core_data_io_write_enable),
    .io_core_data_io_write_data(core_io_core_data_io_write_data),
    .io_exit(core_io_exit),
    .io_gp(core_io_gp)
  );
  Memory memory ( // @[Top.scala 14:22]
    .clock(memory_clock),
    .io_memory_inst_io_addr(memory_io_memory_inst_io_addr),
    .io_memory_inst_io_inst(memory_io_memory_inst_io_inst),
    .io_memory_data_io_addr(memory_io_memory_data_io_addr),
    .io_memory_data_io_read_data(memory_io_memory_data_io_read_data),
    .io_memory_data_io_write_enable(memory_io_memory_data_io_write_enable),
    .io_memory_data_io_write_data(memory_io_memory_data_io_write_data)
  );
  assign io_exit = core_io_exit; // @[Top.scala 21:11]
  assign io_gp = core_io_gp; // @[Top.scala 22:9]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_core_inst_io_inst = memory_io_memory_inst_io_inst; // @[Top.scala 18:24]
  assign core_io_core_data_io_read_data = memory_io_memory_data_io_read_data; // @[Top.scala 19:24]
  assign memory_clock = clock;
  assign memory_io_memory_inst_io_addr = core_io_core_inst_io_addr; // @[Top.scala 18:24]
  assign memory_io_memory_data_io_addr = core_io_core_data_io_addr; // @[Top.scala 19:24]
  assign memory_io_memory_data_io_write_enable = core_io_core_data_io_write_enable; // @[Top.scala 19:24]
  assign memory_io_memory_data_io_write_data = core_io_core_data_io_write_data; // @[Top.scala 19:24]
endmodule
