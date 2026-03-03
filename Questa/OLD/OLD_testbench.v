
module control_fsm_tb();

reg         in_clka, in_clkb;
reg         in_rst;
reg         in_start;
reg  [3:0]  in_opcode;
reg         in_zero_flag;
reg         in_counter_done;

wire        out_pc_write;
wire        out_pc_src;
wire        out_reg_write;
wire [2:0]  out_alu_op;
wire        out_alu_src;
wire        out_shifter_en;
wire [1:0]  out_shifter_mode;
wire        out_counter_en;
wire        out_ir_load;

control_fsm dut (
    .clka(in_clka),
    .clkb(in_clkb),
    .rst(in_rst),
    .start(in_start),
    .opcode(in_opcode),
    .zero_flag(in_zero_flag),
    .counter_done(in_counter_done),

    .pc_write(out_pc_write),
    .pc_src(out_pc_src),
    .reg_write(out_reg_write),
    .alu_op(out_alu_op),
    .alu_src(out_alu_src),
    .shifter_en(out_shifter_en),
    .shifter_mode(out_shifter_mode),
    .counter_en(out_counter_en),
    .ir_load(out_ir_load)
);

// one two-phase cycle 
task cycle;
begin
    in_clka = 0; in_clkb = 0; #10;
    in_clka = 1; in_clkb = 0; #10;
    in_clka = 0; in_clkb = 0; #10;
    in_clka = 0; in_clkb = 1; #10;
end
endtask

task run_instr(input [3:0] op);
begin
    in_opcode = op;
    cycle;  // FETCH
    cycle;  // DECODE
    cycle;  // EXEC or SHIFT_LOOP
    cycle;  // WRITEBACK or next FETCH
end
endtask

task run_branch(input [3:0] op, input z);
begin
    in_opcode    = op;
    in_zero_flag = z;
    cycle; // FETCH
    cycle; // DECODE
    cycle; // EXEC (branch decision here)
    cycle; // back to FETCH
end
endtask

task run_shift_loop(input [3:0] op, input integer loops);
integer i;
begin
    in_opcode = op;
    in_counter_done = 0;

    cycle; // FETCH
    cycle; // DECODE

    for (i = 0; i < loops; i = i + 1) begin
        cycle; // SHIFT_LOOP hold
    end

    in_counter_done = 1;
    cycle; // exit SHIFT_LOOP -> WRITEBACK
    in_counter_done = 0;

    cycle; // FETCH
end
endtask

initial begin

    in_clka = 0;
    in_clkb = 0;
    in_rst  = 1;
    in_start = 0;
    in_opcode = 4'h0;
    in_zero_flag = 0;
    in_counter_done = 0;

    // reset asserted for 2 cycles
    cycle;
    cycle;

    in_rst = 0;

    // start pulse
    in_start = 1;
    cycle;
    in_start = 0;

    // R-type ALU
    run_instr(4'b0000); // ADD
    run_instr(4'b0001); // SUB
    run_instr(4'b0010); // AND
    run_instr(4'b0011); // OR
    run_instr(4'b0100); // XOR

    // I-type
    run_instr(4'b0101); // ADDI
    run_instr(4'b0110); // LUI

    // Branch: taken / not taken
    run_branch(4'b0111, 1'b1); // BEQ taken
    run_branch(4'b0111, 1'b0); // BEQ not taken
    run_branch(4'b1000, 1'b0); // BNE taken
    run_branch(4'b1000, 1'b1); // BNE not taken

    // Shifter multi-cycle
    run_shift_loop(4'b1001, 3); // LSL loops
    run_shift_loop(4'b1010, 2); // LSR loops
    run_shift_loop(4'b1011, 5); // MAC loops
    run_shift_loop(4'b1100, 4); // CLZ loops

    // HALT (goes back to IDLE per DECODE logic)
    in_opcode = 4'b1111;
    cycle; // FETCH
    cycle; // DECODE -> IDLE
    cycle; // stay IDLE unless start again

    $dumpfile("control_fsm_tb.vcd");
    $dumpvars(0, control_fsm_tb);

    $stop;
end


endmodule
