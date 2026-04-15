// Top Module
    // It contains all the other sub-modules.

module top (
    // Inputs
    input wire clka,
    input wire clkb,
    input wire rst,
    input wire [15:0] in_port, // input from MMIO
    input wire instr_load_en,
    input wire load_done,
    input wire [4:0] instr_load_addr,
    input wire [15:0] instr_load_data,

    // Outputs
    output wire [15:0] out_port, // output to MMIO
    output wire error // 1 = invalid state or opcode
);

    // Internal signals
    wire pc_write;
    wire pc_src;
    wire ir_load;
    wire reg_write;
    wire [3:0] alu_op;
    wire alu_src;
    wire mem_read;
    wire mem_write;
    wire mem_to_reg;
    wire shifter_en;
    wire [1:0] shifter_op;
    wire out_port_en;
    wire [3:0] opcode;
    wire zero_flag;
    wire counter_done;
    wire mmio_addr;
    wire e_dp, e_fsm;

    assign error = e_dp || e_fsm;

    datapath datapath_inst (
        .clka(clka),
        .clkb(clkb),
        .rst(rst),
        .in_port(in_port),
        .instr_load_en(instr_load_en),
        .load_done(load_done),
        .instr_load_addr(instr_load_addr),
        .instr_load_data(instr_load_data),

        .pc_write(pc_write),
        .pc_src(pc_src),
        .ir_load(ir_load),
        .reg_write(reg_write),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .shifter_en(shifter_en),
        .shifter_op(shifter_op),
        .out_port_en(out_port_en),
        .opcode(opcode),
        .zero_flag(zero_flag),
        .counter_done(counter_done),
        .mmio_addr(mmio_addr),
        .out_port(out_port),
        .error_flag_dp(e_dp)
    );

    control_fsm fsm_inst (
        .clka(clka),
        .clkb(clkb),
        .rst(rst),

        .opcode(opcode),
        .zero_flag(zero_flag),
        .counter_done(counter_done),
        .mmio_addr(mmio_addr),
        .pc_write(pc_write),
        .pc_src(pc_src),
        .ir_load(ir_load),
        .reg_write(reg_write),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .shifter_en(shifter_en),
        .shifter_op(shifter_op),
        .out_port_en(out_port_en),
        .error_flag_fsm(e_fsm)
    );

endmodule
