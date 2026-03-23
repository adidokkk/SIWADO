module datapath_top(
    input wire clka,
    input wire clkb,
    input wire rst,

    // control signals from FSM
    input wire pc_write,
    input wire pc_src,
    input wire ir_load,
    input wire reg_write,
    input wire [3:0] alu_op,
    input wire alu_src,
    input wire mem_read,
    input wire mem_write,
    input wire mem_to_reg,
    //input wire shifter_en,
    //input wire counter_en,
    //input wire [1:0] shifter_op,
    input wire [15:0] in_port_i,

    // signals back to FSM
    output wire [3:0] opcode,
    output wire zero_flag,
    output wire mmio_addr,
    //output wire counter_done,
    output wire [15:0] out_port_o
);

// ===== OPCODES =====
localparam OP_LSL = 4'b0101;
localparam OP_LSR = 4'b0110;
localparam OP_MAC = 4'b0111;
localparam OP_CLZ = 4'b1000;

// internal signals
wire [15:0] pc;
wire [15:0] instr;
wire [2:0]  rd_addr, rs_addr, rt_addr;
wire [15:0] write_data;
wire [15:0] operand1, operand2;
wire [15:0] rd_data;
wire [15:0] alu_result;
wire [15:0] alu_in2;
wire [5:0]  imm_raw;
wire [15:0] imm_out;
wire [15:0] branch_target;
wire [15:0] mem_rdata;

//wire [15:0] shifter_result;
//wire is_shift_instr;
//wire shifter_done;
//assign is_shift_instr = (opcode == OP_LSL) || (opcode == OP_LSR) || (opcode == OP_MAC) || (opcode == OP_CLZ);

assign zero_flag = (alu_result == 0);

assign branch_target = pc + imm_out;

assign mmio_addr = (alu_result[15:8] == 8'hFC);

pc pc_inst(
    .clkb(clkb),
    .rst(rst),
    .pc_write(pc_write),
    .pc_src(pc_src),   
    .branch_target(branch_target), 
    .pc_o(pc)
);

// instruction memory
ins_mem ins_mem_inst(
    .addr(pc),
    .instr(instr)
);

// instruction register
ir ir_inst(
    .clkb(clkb),
    .rst(rst),
    .ir_load(ir_load),
    .instr_in(instr),
    .opcode(opcode),
    .rd_addr(rd_addr),
    .rs_addr(rs_addr),
    .rt_addr(rt_addr),
    .imm_raw(imm_raw)
);

// immediate generator
imm_gen imm_gen_inst(
    .opcode(opcode),
    .imm_raw(imm_raw),
    .imm_out(imm_out)
);

// register file
regfile regfile_inst(
    .clkb(clkb),
    .rst(rst),
    .rs_addr(rs_addr),
    .rt_addr(rt_addr),
    .rd_addr(rd_addr),
    .reg_write(reg_write),
    .write_data_i(write_data),
    .operand1_o(operand1),
    .operand2_o(operand2),
    .rd_data_o(rd_data)
);

assign alu_in2 = (alu_src) ? imm_out : operand2;

alu alu_inst(
    .operand1_i(operand1),
    .operand2_i(alu_in2),
    .alu_op(alu_op),
    .result_o(alu_result)
);

/*
shifter_unit shifter_inst(
);

assign counter_done = shifter_done;
*/

data_mem data_mem_inst(
    .clkb(clkb),
    .rst(rst),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .addr(alu_result),
    .write_data(operand2),
    .in_port_i(in_port_i),
    .read_data(mem_rdata),
    .out_port_o(out_port_o)
);

// Writeback
assign write_data = mem_to_reg ? mem_rdata : alu_result;

endmodule
