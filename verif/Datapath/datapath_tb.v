module datapath_tb;
    // Inputs
    reg clka, clkb;
    reg rst;
    reg [15:0] in_port;
    wire [15:0] out_port;

    reg pc_write;
    reg pc_src;
    reg ir_load;
    reg reg_write;
    reg [3:0] alu_op;
    reg alu_src;
    reg mem_read;
    reg mem_write;
    reg mem_to_reg;
    reg shifter_en;
    reg [1:0] shifter_op;
    reg out_port_en;

    // Outputs
    wire [3:0] opcode;
    wire zero_flag;
    wire counter_done;
    wire mmio_addr;
    wire error_flag_dp;

    // Datapath Instantiation
    datapath U1 (
        .clka(clka),
        .clkb(clkb),
        .rst(rst),
        .in_port(in_port),
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
        .error_flag_dp(error_flag_dp)
    );

    // Two-phase clock
    task one_cycle;
        begin
            clka = 0; clkb = 0; #5;
            clka = 1; clkb = 0; #5;
            clka = 0; clkb = 0; #5;
            clka = 0; clkb = 1; #5;
        end
    endtask

    initial begin
        $dumpfile("datapath_tb.vcd");
        $dumpvars;

        // Initialization
        rst = 1;
        pc_write = 0; pc_src = 0; ir_load = 0; reg_write = 0;
        alu_op = 4'b0000; alu_src = 0;
        mem_read = 0; mem_write = 0; mem_to_reg = 0;
        shifter_en = 0; shifter_op = 2'b00;
        out_port_en = 0;
        in_port = 16'h0009; 

        one_cycle;
        rst = 0;

        
        // ARITHMETIC TEST (ADDI, LUI, ADD)
        
        // Cycle 1-5: ADDI R1, R0, 5
        pc_write = 1; ir_load = 1; one_cycle; // FETCH
        pc_write = 0; ir_load = 0; one_cycle; // DECODE
        alu_op = 4'b0000; alu_src = 1; one_cycle; // EXECUTE
        reg_write = 1; one_cycle; // WRITEBACK
        reg_write = 0;
        $display("R1 = 0x%h (Expected: 0x0005)", U1.regfile_inst.register[1]);

        // Cycle 6-9: LUI R2, 3
        pc_write = 1; ir_load = 1; one_cycle; // FETCH
        pc_write = 0; ir_load = 0; one_cycle; // DECODE
        alu_op = 4'b1011; alu_src = 1; one_cycle; // EXECUTE
        reg_write = 1; one_cycle; // WRITEBACK
        reg_write = 0;
        $display("R2 = 0x%h (Expected: 0x0C00)", U1.regfile_inst.register[2]);

        // Cycle 10-13: ADD R3, R1, R2
        pc_write = 1; ir_load = 1; one_cycle; // FETCH
        pc_write = 0; ir_load = 0; one_cycle; // DECODE
        alu_op = 4'b0000; alu_src = 0; one_cycle; // EXECUTE
        reg_write = 1; one_cycle; // WRITEBACK
        reg_write = 0;
        $display("R3 = 0x%h (Expected: 0x0C05)", U1.regfile_inst.register[3]);


        // BRANCH TEST (BNE Taken)

        // Cycle 14-17: BNE R1, R2, 2
        pc_write = 1; ir_load = 1; one_cycle; // FETCH
        pc_write = 0; ir_load = 0; one_cycle; // DECODE
        alu_op = 4'b0001; alu_src = 0; one_cycle; // EXECUTE (SUB for flag)
        pc_write = 1; pc_src = ~zero_flag; one_cycle; // BRANCH
        pc_write = 0; pc_src = 0;
        $display("PC = 0x%h (Expected: 0x0006)", U1.pc_out);


        // RAM TEST (SW + LW)

        // Cycle 18-21: SW R1, 0(R2)
        pc_write = 1; ir_load = 1; one_cycle; // FETCH
        pc_write = 0; ir_load = 0; one_cycle; // DECODE
        alu_op = 4'b0000; alu_src = 1; one_cycle; // EXECUTE (addr calc)
        mem_write = 1; one_cycle; // MEMORY
        mem_write = 0;
        $display("ram[0x%h] = 0x%h (Expected: ram[0x00] = 0x0005)", U1.alu_result[7:0], U1.data_mem_inst.ram[U1.alu_result[7:0]]);

        // Cycle 22-26: LW R3, 0(R2)
        pc_write = 1; ir_load = 1; one_cycle; // FETCH
        pc_write = 0; ir_load = 0; one_cycle; // DECODE
        alu_op = 4'b0000; alu_src = 1; one_cycle; // EXECUTE (addr calc)
        mem_read = 1; one_cycle; // MEMORY
        mem_to_reg = 1; reg_write = 1; one_cycle; // WRITEBACK
        mem_read = 0; mem_to_reg = 0; reg_write = 0;
        $display("R3 = 0x%h (Expected: 0x0005)", U1.regfile_inst.register[3]);


        // MMIO TEST

        // Cycle 27-30: LUI R2, 63 (prep FC00)
        pc_write = 1; ir_load = 1; one_cycle;
        pc_write = 0; ir_load = 0; one_cycle;
        alu_op = 4'b1011; alu_src = 1; one_cycle;
        reg_write = 1; one_cycle;
        reg_write = 0;
        $display("R2 = 0x%h (Expected: 0xFC00)", U1.regfile_inst.register[2]);

        // Cycle 31-34: SW R1, 0(R2)
        pc_write = 1; ir_load = 1; one_cycle;
        pc_write = 0; ir_load = 0; one_cycle;
        alu_op = 4'b0000; alu_src = 1; one_cycle;
        mem_write = 1; out_port_en = 1; one_cycle; // MEMORY
        mem_write = 0; out_port_en = 0;
        $display("out_port = 0x%h (Expected: 0x0005)", out_port);

        // Cycles 35-39: LW R3, 2(R2)
        pc_write = 1; ir_load = 1; one_cycle; // FETCH
        pc_write = 0; ir_load = 0; one_cycle; // DECODE
        alu_op = 4'b0000; alu_src = 1; one_cycle; // EXECUTE (addr calc)
        mem_read = 1; one_cycle; // MEMORY
        mem_to_reg = 1; reg_write = 1; one_cycle; // WRITEBACK
        mem_read = 0; mem_to_reg = 0; reg_write = 0;
        $display("R3 = 0x%h (Expected: 0x%h)", U1.regfile_inst.register[3], in_port);


        // SHIFTER TEST

        // Cycle 40-43: LSL R3, R1, R1
        pc_write = 1; ir_load = 1; one_cycle; // FETCH
        pc_write = 0; ir_load = 0; one_cycle; // DECODE
        shifter_en = 1; shifter_op = 2'b00; one_cycle; // SHIFT_LOOP
        shifter_en = 0; reg_write = 1; one_cycle; // WRITEBACK
        reg_write = 0;
        $display("R3 = 0x%h (Expected: 0x00A0)", U1.regfile_inst.register[3]);

        // Cycle 44-47: LSR R3, R1, R1
        pc_write = 1; ir_load = 1; one_cycle; // FETCH
        pc_write = 0; ir_load = 0; one_cycle; // DECODE
        shifter_en = 1; shifter_op = 2'b01; one_cycle; // SHIFT_LOOP
        shifter_en = 0; reg_write = 1; one_cycle; // WRITEBACK
        reg_write = 0;
        $display("R3 = 0x%h (Expected: 0x0000)", U1.regfile_inst.register[3]);

        // Cycle 48-65: CLZ R3, R1 (multi-cycle)
        pc_write = 1; ir_load = 1; one_cycle; // FETCH
        pc_write = 0; ir_load = 0; one_cycle; // DECODE
        shifter_en = 1; shifter_op = 2'b11; // SHIFT_LOOP
        while(!counter_done) one_cycle; // Wait for counter_done
        shifter_en = 0; reg_write = 1; one_cycle; // WRITEBACK
        reg_write = 0;
        $display("R3 = 0x%h (Expected: 0x000D)", U1.regfile_inst.register[3]);

        // Cycle 66-86: MAC R3, R1, R1 (multi-cycle)
        pc_write = 1; ir_load = 1; one_cycle; // FETCH
        pc_write = 0; ir_load = 0; one_cycle; // DECODE
        shifter_en = 1; shifter_op = 2'b10; // SHIFT_LOOP
        while(!counter_done) one_cycle; // Wait for counter_done
        shifter_en = 0; reg_write = 1; one_cycle; // WRITEBACK
        reg_write = 0;
        $display("R3 = 0x%h (Expected: 0x0026)", U1.regfile_inst.register[3]);


        // HALT TEST

        // Cycle 87-90: HALT
        pc_write = 1; ir_load = 1; one_cycle; // FETCH
        pc_write = 0; ir_load = 0; one_cycle; // DECODE
        one_cycle; // HALT

    
        one_cycle;

        $stop;
    end

endmodule