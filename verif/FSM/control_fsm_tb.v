module control_fsm_tb();
    // Inputs
    reg clka, clkb, rst;
    reg [3:0] opcode;
    reg zero_flag, counter_done, mmio_addr;

    // Outputs
    wire pc_write, pc_src, ir_load, reg_write;
    wire [3:0] alu_op;
    wire alu_src, mem_read, mem_write, mem_to_reg;
    wire shifter_en, counter_en, out_port_en;
    wire [1:0] shifter_op;

    control_fsm U1 (
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
        .counter_en(counter_en), 
        .shifter_op(shifter_op), 
        .out_port_en(out_port_en)
    );

    task run_cycle;
    begin
        clka = 0; clkb = 0; #10;
        clka = 1; clkb = 0; #10;
        clka = 0; clkb = 0; #10;
        clka = 0; clkb = 1; #10;
    end
    endtask

    initial begin
        $dumpfile("control_fsm_tb.vcd");
        $dumpvars;

        // System Initialization
        rst = 1; 
        opcode = 4'b0000; 
        zero_flag = 0; 
        counter_done = 0; 
        mmio_addr = 0;
        clka = 0; 
        clkb = 0;
        run_cycle; 
        
        rst = 0;
        run_cycle; // FETCH

        // TEST 1: Standard ALU Instruction (ADD)
        // Flow: FETCH -> DECODE -> EXECUTE -> WRITEBACK -> FETCH
        $display("Testing ADD Instruction.");
        opcode = 4'b0000; // OP_ADD
        run_cycle; // DECODE
        run_cycle; // EXECUTE
        run_cycle; // WRITEBACK
        
        // TEST 2: Multi-Cycle Instruction (MAC)
        // Flow: FETCH -> DECODE -> SHIFT_LOOP (...) -> WRITEBACK
        $display("Testing MAC Instruction.");
        run_cycle; // FETCH
        opcode = 4'b0111; // OP_MAC
        run_cycle; // DECODE
        run_cycle; // SHIFT_LOOP
        
        // Simulate 16-cycle delay with few cycles
        run_cycle; 
        run_cycle; 
        
        // Break the loop
        counter_done = 1; 
        run_cycle; // WRITEBACK
        counter_done = 0;

        // TEST 3: Branch Instruction (BEQ)
        // Flow: FETCH -> DECODE -> EXECUTE -> FETCH
        $display("Testing BEQ Instruction Taken.");
        run_cycle; // FETCH
        opcode = 4'b1001; // OP_BEQ
        zero_flag = 1; // ALU indicates Rs1 == Rs2
        
        run_cycle; // DECODE
        run_cycle; // EXECUTE
        
        zero_flag = 0;
        
        // TEST 4: Store Word MMIO (SW to 0xFF00)
        // Flow: FETCH -> DECODE -> EXECUTE -> MEMORY -> FETCH
        $display("Testing SW Instruction to MMIO.");
        run_cycle; // FETCH
        opcode = 4'b1110; // OP_SW
        mmio_addr = 1; // Target is 0xFF00
        
        run_cycle; // DECODE
        run_cycle; // EXECUTE
        run_cycle; // MEMORY 
        
        mmio_addr = 0;

        
        run_cycle; // FETCH
        run_cycle;

        $display("Simulation Complete.");
        $stop;
    end
endmodule