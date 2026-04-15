// Top Module Testbench
    // It generates top_tb.vcd for waveform viewing,
    // and top_tb.log with cycle-by-cycle results.

    // It can executed with:
        // /clear/apps/elec8/bin/vsim -c top_tb -do "run -all; quit" > top_tb.log

module top_tb;
    // Inputs
    reg clka, clkb;
    reg rst;
    reg [15:0] ins_in;
    reg ins_done;
    reg [15:0] in_port;

    // Outputs
    wire [15:0] out_port;
    wire error;

    // Helper variables 
    integer cycle_count;
    integer pc, pc_new;
    integer i;
    reg [15:0] ins_mem [0:31];
    
    // Top Module Instantiation
    top U1 (
        .clka(clka),
        .clkb(clkb),
        .rst(rst),
        .ins_in(ins_in),
        .ins_done(ins_done),
        .in_port(in_port),

        .out_port(out_port),
        .error(error)
    );

    wire [15:0] probe_pc = U1.datapath_inst.pc_out ;
    wire [15:0] probe_reg1 = U1.datapath_inst.regfile_inst.register[1] ;
    wire [15:0] probe_reg2 = U1.datapath_inst.regfile_inst.register[2] ;
    wire [15:0] probe_reg3 = U1.datapath_inst.regfile_inst.register[3] ;
    wire [15:0] probe_reg4 = U1.datapath_inst.regfile_inst.register[4] ;
    wire [15:0] probe_reg5 = U1.datapath_inst.regfile_inst.register[5] ;
    wire [15:0] probe_reg6 = U1.datapath_inst.regfile_inst.register[6] ;
    wire [15:0] probe_reg7 = U1.datapath_inst.regfile_inst.register[7] ;
    wire [15:0] probe_ram0 = U1.datapath_inst.data_mem_inst.ram[0] ;
    wire [15:0] probe_ram1 = U1.datapath_inst.data_mem_inst.ram[1] ;
    wire [15:0] probe_ram2 = U1.datapath_inst.data_mem_inst.ram[2] ;

    // Two-phase clock
    task one_cycle;
        begin
            clka = 0; clkb = 0; #5;
            clka = 1; clkb = 0; #5;
            clka = 0; clkb = 0; #5;
            clka = 0; clkb = 1; #5;
        end
    endtask

    // Helper function to print logs
    task print_log;
        begin
            cycle_count = cycle_count + 1;

            $display("|  %3d  | 0x%04h |  0x%02h  | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h |  0x%04h  |              |", 
            cycle_count, probe_pc, U1.opcode, probe_reg1, probe_reg2, probe_reg3,
            probe_reg4, probe_reg5, probe_reg6, probe_reg7, 
            probe_ram0, probe_ram1, probe_ram2, out_port
            );
        end
    endtask
 
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars;

        $readmemb("../program.bin", ins_mem);
        $display("Assembler Check: instr[0]=%b, instr[1]=%b, instr[2]=%b", 
            ins_mem[0], ins_mem[1], ins_mem[2]
        );

        cycle_count = 1;
        $display("                                                               TABLE OF RESULTS                                                                ");
        $display(" --------------------------------------------------------------------------------------------------------------------------------------------- ");
        $display("| Cycle |   PC   | Opcode |   R1   |   R2   |   R3   |   R4   |   R5   |   R6   |   R7   | RAM[0] | RAM[1] | RAM[2] | out_port |    Comment   |");
        $display(" --------------------------------------------------------------------------------------------------------------------------------------------- ");
        $display("|  %3d  | 0x%04h |  0x%02h  | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h |  0x%04h  |   reset = 1  |",
            cycle_count, probe_pc, U1.opcode, probe_reg1, probe_reg2, probe_reg3,
            probe_reg4, probe_reg5, probe_reg6, probe_reg7, 
            probe_ram0, probe_ram1, probe_ram2, out_port
        );


        // Initialization
        rst = 1; ins_done = 0; in_port = 16'h0009;
        one_cycle; cycle_count = cycle_count + 1;

        $display("|  %3d  | 0x%04h |  0x%02h  | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h |  0x%04h  |   reset = 1  |",
            cycle_count, probe_pc, U1.opcode, probe_reg1, probe_reg2, probe_reg3,
            probe_reg4, probe_reg5, probe_reg6, probe_reg7, 
            probe_ram0, probe_ram1, probe_ram2, out_port
        );
        one_cycle; cycle_count = cycle_count + 1;

        $display("|  %3d  | 0x%04h |  0x%02h  | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h |  0x%04h  |   reset = 0  |",
            cycle_count, probe_pc, U1.opcode, probe_reg1, probe_reg2, probe_reg3,
            probe_reg4, probe_reg5, probe_reg6, probe_reg7, 
            probe_ram0, probe_ram1, probe_ram2, out_port
        );
        rst = 0;

        for (i = 0; ins_in !== 16'hf000; i = i + 1) // load till HALT
        begin
            ins_in = ins_mem[i];
            one_cycle;
            if (ins_in !== 16'hf000) print_log;
        end
        
        $display("|  %3d  | 0x%04h |  0x%02h  | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h | 0x%04h |  0x%04h  | ins_done = 1 |",
            cycle_count, probe_pc, U1.opcode, probe_reg1, probe_reg2, probe_reg3,
            probe_reg4, probe_reg5, probe_reg6, probe_reg7, 
            probe_ram0, probe_ram1, probe_ram2, out_port
        );
        ins_done = 1;

        pc = probe_pc;
        while (U1.opcode[3:0] !== 4'b1111 && cycle_count < 300) // wait for HALT
        begin
            print_log;
            
            one_cycle;
            pc_new = probe_pc;
            if (pc_new != pc) 
            begin
                pc = pc_new;
                $display(" --------------------------------------------------------------------------------------------------------------------------------------------- ");
            end        
        end




        // // ARITHMETIC TEST (ADDI, LUI, ADD, SUB)
        
        // // Cycle 1-7: ADDI R1, R0, 5
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE
        // one_cycle; // WRITEBACK
        // $display("R1 = 0x%h (Expected: 0x0005)", probe_reg1);

        // // Cycle 8-11: LUI R2, 3
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE
        // one_cycle; // WRITEBACK
        // $display("R2 = 0x%h (Expected: 0x0C00)", U1.datapath_inst.regfile_inst.register[2]);

        // // Cycle 12-15: ADD R3, R1, R2
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE
        // one_cycle; // WRITEBACK
        // $display("R3 = 0x%h (Expected: 0x0C05)", U1.datapath_inst.regfile_inst.register[3]);
       
        // // Cycle 16-19: ADDI R4, R1, -9
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE
        // one_cycle; // WRITEBACK
        // $display("R4 = 0x%h (Expected: 0xFFFC)", U1.datapath_inst.regfile_inst.register[4]);

        // // Cycle 20-23: SUB R5, R4, R4
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE
        // one_cycle; // WRITEBACK
        // $display("R5 = 0x%h (Expected: 0x0000)", U1.datapath_inst.regfile_inst.register[5]);


        // // LOGIC TEST (AND, OR, XOR)

        // // Cycle 24-27: AND R6, R3, R4
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE
        // one_cycle; // WRITEBACK
        // $display("R6 = 0x%h (Expected: 0x0C04)", U1.datapath_inst.regfile_inst.register[6]);

        // // Cycle 28-31: OR R7, R1, R4
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE
        // one_cycle; // WRITEBACK
        // $display("R7 = 0x%h (Expected: 0xFFFD)", U1.datapath_inst.regfile_inst.register[7]);

        // // Cycle 32-35: XOR R3, R2, R7
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE
        // one_cycle; // WRITEBACK
        // $display("R3 = 0x%h (Expected: 0xF3FD)", U1.datapath_inst.regfile_inst.register[3]);      


        // // RAM TEST (SW, LW)

        // // Cycle 36-39: SW R1, 2(R2)
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE (addr calc)
        // one_cycle; // MEMORY
        // $display("ram[0x%h] = 0x%h (Expected: ram[0x02] = 0x0005)", U1.datapath_inst.alu_result[7:0], 
        //     U1.datapath_inst.data_mem_inst.ram[U1.datapath_inst.alu_result[7:0]]
        // );

        // // Cycle 40-44: LW R2, 2(R2)
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE (addr calc)
        // one_cycle; // MEMORY
        // one_cycle; // WRITEBACK
        // $display("R2 = 0x%h (Expected: 0x0005)", U1.datapath_inst.regfile_inst.register[2]);


        // // BRANCH TEST (BEQ, BNE)

        // // Cycle 45-48: ADDI R1, R0, 3
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE
        // one_cycle; // WRITEBACK
        // $display("R1 = 0x%h (Expected: 0x0003)", probe_reg1);

        // // Cycle 49-52: ADDI R2, R0, 2
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE
        // one_cycle; // WRITEBACK
        // $display("R2 = 0x%h (Expected: 0x0002)", U1.datapath_inst.regfile_inst.register[2]);

        // // Cycle 53-108
        // while (U1.datapath_inst.regfile_inst.register[5] != probe_reg1) 
        // begin
        //     // ADD R3, R0, R5
        //     one_cycle; // FETCH
        //     one_cycle; // DECODE
        //     one_cycle; // EXECUTE
        //     one_cycle; // WRITEBACK
        //     $display("[LOOP]: R3 = 0x%h", U1.datapath_inst.regfile_inst.register[3]);

        //     // Cycle 55-58: ADDI R5, R5, 1
        //     one_cycle; // FETCH
        //     one_cycle; // DECODE
        //     one_cycle; // EXECUTE
        //     one_cycle; // WRITEBACK
        //     $display("[LOOP]: R5 = 0x%h", U1.datapath_inst.regfile_inst.register[5]);

        //     // BEQ R3, R2, 1
        //     one_cycle; // FETCH
        //     one_cycle; // DECODE
        //     one_cycle; // EXECUTE (SUB for flag)
        //     one_cycle; // BRANCH
        //     $display("[LOOP]: PC = 0x%h", U1.datapath_inst.pc_out);

        //     if (U1.datapath_inst.regfile_inst.register[3] != U1.datapath_inst.regfile_inst.register[2]) 
        //     begin
        //         // SW R7, 0(R3)
        //         one_cycle; // FETCH
        //         one_cycle; // DECODE
        //         one_cycle; // EXECUTE (addr calc)
        //         one_cycle; // MEMORY
        //         $display("[LOOP]: ram[0x%h] = 0x%h (Expected: 0xFFFD)", U1.datapath_inst.alu_result[7:0], 
        //             U1.datapath_inst.data_mem_inst.ram[U1.datapath_inst.alu_result[7:0]]
        //         );
        //     end

        //     // BNE R5, R1, FOR_LOOP
        //     one_cycle; // FETCH
        //     one_cycle; // DECODE
        //     one_cycle; // EXECUTE (SUB for flag)
        //     one_cycle; // BRANCH
        //     $display("[LOOP]: PC = 0x%h", U1.datapath_inst.pc_out);
        // end


        // // MMIO TEST

        // // Cycle 109-112: LUI R2, 63 (prep FC00)
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE
        // one_cycle; // WRITEBACK
        // $display("R2 = 0x%h (Expected: 0xFC00)", U1.datapath_inst.regfile_inst.register[2]);

        // // Cycle 113-116: SW R4, 0(R2)
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE (addr calc)
        // one_cycle; // MEMORY
        // $display("out_port = 0x%h (Expected: 0xFFFC)", out_port);

        // // Cycles 117-121: LW R3, 2(R2)
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // EXECUTE (addr calc)
        // one_cycle; // MEMORY
        // one_cycle; // WRITEBACK
        // $display("R3 = 0x%h (Expected: 0x%h)", probe_reg3, in_port);


        // // SHIFTER TEST

        // // Cycle 122-125: LSL R3, R1, R1
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // SHIFT_LOOP
        // one_cycle; // WRITEBACK
        // $display("R3 = 0x%h (Expected: 0x0018)", U1.datapath_inst.regfile_inst.register[3]);

        // // Cycle 126-129: LSR R7, R1, R1
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // SHIFT_LOOP
        // one_cycle; // WRITEBACK
        // $display("R7 = 0x%h (Expected: 0x0000)", U1.datapath_inst.regfile_inst.register[7]);

        // // Cycle 130-138: CLZ R4, R6 (multi-cycle)
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // while(!U1.fsm_inst.reg_write) one_cycle; // SHIFT LOOP (wait for counter_done)
        // one_cycle; // WRITEBACK
        // $display("R4 = 0x%h (Expected: 0x0004)", U1.datapath_inst.regfile_inst.register[4]);

        // // Cycle 139-159: MAC R6, R5, R5 (multi-cycle)
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // while(!U1.fsm_inst.reg_write) one_cycle; // SHIFT LOOP (wait for counter_done)
        // one_cycle; // WRITEBACK
        // $display("R6 = 0x%h (Expected: 0x0C0D)", U1.datapath_inst.regfile_inst.register[6]);


        // // HALT TEST

        // // Cycle 160-164: HALT
        // one_cycle; // FETCH
        // one_cycle; // DECODE
        // one_cycle; // HALT */

    
        // one_cycle; one_cycle;

        $stop;
    end

endmodule