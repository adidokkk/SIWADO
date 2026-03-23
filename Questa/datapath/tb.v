module tb;

reg clka, clkb;
reg rst;

// control_signal
reg pc_write;
reg pc_src;
reg ir_load;
reg reg_write;
reg [3:0] alu_op;
reg alu_src;
wire [3:0] opcode;
wire zero_flag;

reg mem_read;
reg mem_write;
reg mem_to_reg;
reg [15:0] in_port_i;
wire [15:0] out_port_o;
wire mmio_addr;

datapath_top dut (
    .clka(clka),
    .clkb(clkb),
    .rst(rst),
    .pc_write(pc_write),
    .pc_src(pc_src),
    .ir_load(ir_load),
    .reg_write(reg_write),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .opcode(opcode),
    .zero_flag(zero_flag),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .in_port_i(in_port_i),
    .out_port_o(out_port_o),
    .mmio_addr(mmio_addr)
);

// two-phase clock
task one_cycle;
    begin
        clka = 0; clkb = 0; #5;
        clka = 1; clkb = 0; #5;
        clka = 0; clkb = 0; #5;
        clka = 0; clkb = 1; #5;
    end
endtask

initial begin

    // Initialization
    rst = 1;
    pc_write = 0;
    pc_src = 0;
    ir_load = 0;
    reg_write = 0;
    alu_src = 0;
    alu_op = 4'b0000;
    mem_read = 0;
    mem_write = 0;
    mem_to_reg = 0;
    in_port_i = 16'd9; 

    one_cycle;
    rst = 0;
    
    // ==========================
    // ADDI TEST
    // ==========================
    
    // Cycle1: FETCH
    pc_write = 1;
    ir_load  = 1;
    one_cycle;
    
    // Cycle2: DECODE
    pc_write = 0;
    ir_load  = 0;
    one_cycle;
    
    // Cycle3: EXECUTE
    alu_op  = 4'b1100; // ADDI
    alu_src = 1;
    one_cycle;
    
    // Cycle4: WRITEBACK
    reg_write = 1;
    one_cycle;
    reg_write = 0;
    
    // ==========================
    // LUI TEST
    // ==========================
    
    // Cycle5: FETCH
    pc_write = 1;
    ir_load  = 1;
    one_cycle;
    
    // Cycle6: DECODE
    pc_write = 0;
    ir_load  = 0;
    one_cycle;
    
    // Cycle7: EXECUTE
    alu_op  = 4'b1011; // LUI
    alu_src = 1;
    one_cycle;
    
    // Cycle8: WRITEBACK
    reg_write = 1;
    one_cycle;
    reg_write = 0;
    
    // ==========================
    // ADD TEST
    // ==========================
    // Cycle9: FETCH
    pc_write = 1;
    ir_load  = 1;
    one_cycle;
    
    // Cycle10: DECODE
    pc_write = 0;
    ir_load  = 0;
    one_cycle;
    
    // Cycle11: EXECUTE
    alu_op  = 4'b0000; // ADD
    alu_src = 0;
    one_cycle;
    
    // Cycle12: WRITEBACK
    reg_write = 1;
    one_cycle;
    reg_write = 0;

    // ==========================
    // BNE TEST
    // ==========================
    // Cycle13: FETCH
    pc_write = 0; 
    ir_load  = 1;
    one_cycle;
    
    // Cycle14: DECODE
    pc_write = 0;
    ir_load  = 0;
    one_cycle;
    
    // Cycle15: EXECUTE
    alu_op  = 4'b0001; // SUB
    alu_src = 0;
    one_cycle;
    
    // Cycle16: BRANCH
    pc_src = ~zero_flag;  // BNE
    pc_write = 1;
    one_cycle;
    
    pc_src   = 0;
    pc_write = 0;
    
    // ==========================
    // ADDI (after branch)
    // ==========================
    
    // FETCH
    pc_write = 1;
    ir_load  = 1;
    one_cycle;
    
    // DECODE
    pc_write = 0;
    ir_load  = 0;
    one_cycle;
    
    // EXECUTE
    alu_op  = 4'b1100; // ADDI
    alu_src = 1;
    one_cycle;
    
    // WRITEBACK
    reg_write = 1;
    one_cycle;
    reg_write = 0;
    
    /*
    // ==========================
    // RAM TEST (SW + LW)
    // ==========================
    // SW R1, 0(R2)
    pc_write = 1; ir_load = 1; 
    one_cycle;
    
    pc_write = 0; ir_load = 0; 
    one_cycle;
    
    alu_op  = 4'b0000; // address calc
    alu_src = 1;
    one_cycle;
    
    mem_write = 1;
    one_cycle;
    mem_write = 0;
    
    // LW R3, 0(R2)
    pc_write = 1; ir_load = 1; 
    one_cycle;
    pc_write = 0; ir_load = 0; 
    one_cycle;
    
    alu_op  = 4'b0000;
    alu_src = 1;
    one_cycle;
    
    mem_read = 1;
    mem_to_reg = 1;
    one_cycle;
    
    reg_write = 1;
    one_cycle;
    
    reg_write = 0;
    mem_read = 0;
    mem_to_reg = 0;

    

    // ==========================
    // MMIO TEST (SW + LW)
    // ==========================
    // LUI R2, 63  FC00
    pc_write = 1; ir_load = 1; 
    one_cycle;
    pc_write = 0; ir_load = 0; 
    one_cycle;
    
    alu_op  = 4'b1011;
    alu_src = 1;
    one_cycle;
    
    reg_write = 1;
    one_cycle;
    reg_write = 0;
    
    // SW out_port
    pc_write = 1; ir_load = 1; 
    one_cycle;
    pc_write = 0; ir_load = 0; 
    one_cycle;
    
    alu_op  = 4'b0000;
    alu_src = 1;
    one_cycle;
    
    mem_write = 1;
    one_cycle;
    mem_write = 0;
    
    // LW from out_port
    pc_write = 1; ir_load = 1; 
    one_cycle;
    pc_write = 0; ir_load = 0; 
    one_cycle;
    
    alu_op  = 4'b0000;
    alu_src = 1;
    one_cycle;
    
    mem_read = 1;
    mem_to_reg = 1;
    one_cycle;
    
    reg_write = 1;
    one_cycle;
    
    reg_write = 0;
    mem_read = 0;
    mem_to_reg = 0;
    */



    repeat(2) one_cycle;

    $display("R1 = %d", dut.regfile_inst.register[1]);
    $display("R2 = %d", dut.regfile_inst.register[2]);
    $display("R3 = %d", dut.regfile_inst.register[3]);
    $display("pc = %d", dut.pc_inst.pc_o);
    $display("branch_target = %d", dut.branch_target);
    $display("RAM[0] = %d", dut.data_mem_inst.ram[0]);
    $display("out_port = %d", dut.out_port_o);

    $stop;
end
endmodule