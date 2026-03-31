module top_tb;
    // Inputs
    reg clka, clkb;
    reg rst;
    reg [15:0] in_port;

    // Outputs
    wire [15:0] out_port;
    wire error;

    // Top Module Instantiation
    top U1 (
        .clka(clka),
        .clkb(clkb),
        .rst(rst),
        .in_port(in_port),

        .out_port(out_port),
        .error(error)
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
        $dumpfile("top_tb.vcd");
        $dumpvars;

        // Initialization
        rst = 1; in_port = 16'h0009; one_cycle;
        rst = 0; one_cycle;


        // ARITHMETIC TEST (ADDI, LUI, ADD)
        
        // Cycle 1-5: ADDI R1, R0, 5
        one_cycle; // FETCH
        one_cycle; // DECODE
        one_cycle; // EXECUTE
        one_cycle; // WRITEBACK
        $display("R1 = 0x%h (Expected: 0x0005)", U1.datapath_inst.regfile_inst.register[1]);

        // Cycle 6-9: LUI R2, 3
        one_cycle; // FETCH
        one_cycle; // DECODE
        one_cycle; // EXECUTE
        one_cycle; // WRITEBACK
        $display("R2 = 0x%h (Expected: 0x0C00)", U1.datapath_inst.regfile_inst.register[2]);

        // Cycle 10-13: ADD R3, R1, R2
        one_cycle; // FETCH
        one_cycle; // DECODE
        one_cycle; // EXECUTE
        one_cycle; // WRITEBACK
        $display("R3 = 0x%h (Expected: 0x0C05)", U1.datapath_inst.regfile_inst.register[3]);


        // BRANCH TEST (BNE Taken)

        // Cycle 14-17: BNE R1, R2, 2
        one_cycle; // FETCH
        one_cycle; // DECODE
        one_cycle; // EXECUTE (SUB for flag)
        one_cycle; // BRANCH
        $display("PC = 0x%h (Expected: 0x0006)", U1.datapath_inst.pc_out);


        // RAM TEST (SW + LW)

        // Cycle 18-21: SW R1, 0(R2)
        one_cycle; // FETCH
        one_cycle; // DECODE
        one_cycle; // EXECUTE (addr calc)
        one_cycle; // MEMORY
        $display("ram[0x%h] = 0x%h (Expected: ram[0x00] = 0x0005)", U1.datapath_inst.alu_result[7:0], U1.datapath_inst.data_mem_inst.ram[U1.datapath_inst.alu_result[7:0]]);

        // Cycle 22-26: LW R3, 0(R2)
        one_cycle; // FETCH
        one_cycle; // DECODE
        one_cycle; // EXECUTE (addr calc)
        one_cycle; // MEMORY
        one_cycle; // WRITEBACK
        $display("R3 = 0x%h (Expected: 0x0005)", U1.datapath_inst.regfile_inst.register[3]);


        // MMIO TEST

        // Cycle 27-30: LUI R2, 63 (prep FC00)
        one_cycle; // FETCH
        one_cycle; // DECODE
        one_cycle; // EXECUTE
        one_cycle; // WRITEBACK
        $display("R2 = 0x%h (Expected: 0xFC00)", U1.datapath_inst.regfile_inst.register[2]);

        // Cycle 31-34: SW R1, 0(R2)
        one_cycle; // FETCH
        one_cycle; // DECODE
        one_cycle; // EXECUTE (addr calc)
        one_cycle; // MEMORY
        $display("out_port = 0x%h (Expected: 0x0005)", out_port);

        // Cycles 35-39: LW R3, 2(R2)
        one_cycle; // FETCH
        one_cycle; // DECODE
        one_cycle; // EXECUTE (addr calc)
        one_cycle; // MEMORY
        one_cycle; // WRITEBACK
        $display("R3 = 0x%h (Expected: 0x%h)", U1.datapath_inst.regfile_inst.register[3], in_port);


        // SHIFTER TEST

        // Cycle 40-43: LSL R3, R1, R1
        one_cycle; // FETCH
        one_cycle; // DECODE
        one_cycle; // SHIFT_LOOP
        one_cycle; // WRITEBACK
        $display("R3 = 0x%h (Expected: 0x00A0)", U1.datapath_inst.regfile_inst.register[3]);

        // Cycle 44-47: LSR R3, R1, R1
        one_cycle; // FETCH
        one_cycle; // DECODE
        one_cycle; // SHIFT_LOOP
        one_cycle; // WRITEBACK
        $display("R3 = 0x%h (Expected: 0x0000)", U1.datapath_inst.regfile_inst.register[3]);

        // Cycle 48-65: CLZ R3, R1 (multi-cycle)
        one_cycle; // FETCH
        one_cycle; // DECODE
        while(!U1.datapath_inst.counter_done) one_cycle; // SHIFT LOOP (wait for counter_done)
        one_cycle; // WRITEBACK
        $display("R3 = 0x%h (Expected: 0x000D)", U1.datapath_inst.regfile_inst.register[3]);

        // Cycle 66-86: MAC R3, R1, R1 (multi-cycle)
        one_cycle; // FETCH
        one_cycle; // DECODE
        while(!U1.datapath_inst.counter_done) one_cycle; // SHIFT LOOP (wait for counter_done)
        one_cycle; // WRITEBACK
        $display("R3 = 0x%h (Expected: 0x0026)", U1.datapath_inst.regfile_inst.register[3]);


        // HALT TEST

        // Cycle 87-90: HALT
        one_cycle; // FETCH
        one_cycle; // DECODE
        one_cycle; // HALT

    
        one_cycle;

        $stop;
    end

endmodule