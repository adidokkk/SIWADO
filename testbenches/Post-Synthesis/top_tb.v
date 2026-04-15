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

    wire [15:0] probe_pc = {
        11'b0,
        U1.\datapath_inst/pc_out [4] ,
        U1.\datapath_inst/pc_out [3] ,
        U1.\datapath_inst/pc_out [2] ,
        U1.\datapath_inst/pc_out [1] ,
        U1.\datapath_inst/pc_out [0]
    };
    wire [15:0] probe_reg1 = {
        U1.\datapath_inst/regfile_inst/register[1][15] ,
        U1.\datapath_inst/regfile_inst/register[1][14] ,
        U1.\datapath_inst/regfile_inst/register[1][13] ,
        U1.\datapath_inst/regfile_inst/register[1][12] ,
        U1.\datapath_inst/regfile_inst/register[1][11] ,
        U1.\datapath_inst/regfile_inst/register[1][10] ,
        U1.\datapath_inst/regfile_inst/register[1][9] ,
        U1.\datapath_inst/regfile_inst/register[1][8] ,
        U1.\datapath_inst/regfile_inst/register[1][7] ,
        U1.\datapath_inst/regfile_inst/register[1][6] ,
        U1.\datapath_inst/regfile_inst/register[1][5] ,
        U1.\datapath_inst/regfile_inst/register[1][4] ,
        U1.\datapath_inst/regfile_inst/register[1][3] ,
        U1.\datapath_inst/regfile_inst/register[1][2] ,
        U1.\datapath_inst/regfile_inst/register[1][1] ,
        U1.\datapath_inst/regfile_inst/register[1][0] 
    };
    wire [15:0] probe_reg2 = {
        U1.\datapath_inst/regfile_inst/register[2][15] ,
        U1.\datapath_inst/regfile_inst/register[2][14] ,
        U1.\datapath_inst/regfile_inst/register[2][13] ,
        U1.\datapath_inst/regfile_inst/register[2][12] ,
        U1.\datapath_inst/regfile_inst/register[2][11] ,
        U1.\datapath_inst/regfile_inst/register[2][10] ,
        U1.\datapath_inst/regfile_inst/register[2][9] ,
        U1.\datapath_inst/regfile_inst/register[2][8] ,
        U1.\datapath_inst/regfile_inst/register[2][7] ,
        U1.\datapath_inst/regfile_inst/register[2][6] ,
        U1.\datapath_inst/regfile_inst/register[2][5] ,
        U1.\datapath_inst/regfile_inst/register[2][4] ,
        U1.\datapath_inst/regfile_inst/register[2][3] ,
        U1.\datapath_inst/regfile_inst/register[2][2] ,
        U1.\datapath_inst/regfile_inst/register[2][1] ,
        U1.\datapath_inst/regfile_inst/register[2][0] 
    };
    wire [15:0] probe_reg3 = {
        U1.\datapath_inst/regfile_inst/register[3][15] ,
        U1.\datapath_inst/regfile_inst/register[3][14] ,
        U1.\datapath_inst/regfile_inst/register[3][13] ,
        U1.\datapath_inst/regfile_inst/register[3][12] ,
        U1.\datapath_inst/regfile_inst/register[3][11] ,
        U1.\datapath_inst/regfile_inst/register[3][10] ,
        U1.\datapath_inst/regfile_inst/register[3][9] ,
        U1.\datapath_inst/regfile_inst/register[3][8] ,
        U1.\datapath_inst/regfile_inst/register[3][7] ,
        U1.\datapath_inst/regfile_inst/register[3][6] ,
        U1.\datapath_inst/regfile_inst/register[3][5] ,
        U1.\datapath_inst/regfile_inst/register[3][4] ,
        U1.\datapath_inst/regfile_inst/register[3][3] ,
        U1.\datapath_inst/regfile_inst/register[3][2] ,
        U1.\datapath_inst/regfile_inst/register[3][1] ,
        U1.\datapath_inst/regfile_inst/register[3][0] 
    };
    wire [15:0] probe_reg4 = {
        U1.\datapath_inst/regfile_inst/register[4][15] ,
        U1.\datapath_inst/regfile_inst/register[4][14] ,
        U1.\datapath_inst/regfile_inst/register[4][13] ,
        U1.\datapath_inst/regfile_inst/register[4][12] ,
        U1.\datapath_inst/regfile_inst/register[4][11] ,
        U1.\datapath_inst/regfile_inst/register[4][10] ,
        U1.\datapath_inst/regfile_inst/register[4][9] ,
        U1.\datapath_inst/regfile_inst/register[4][8] ,
        U1.\datapath_inst/regfile_inst/register[4][7] ,
        U1.\datapath_inst/regfile_inst/register[4][6] ,
        U1.\datapath_inst/regfile_inst/register[4][5] ,
        U1.\datapath_inst/regfile_inst/register[4][4] ,
        U1.\datapath_inst/regfile_inst/register[4][3] ,
        U1.\datapath_inst/regfile_inst/register[4][2] ,
        U1.\datapath_inst/regfile_inst/register[4][1] ,
        U1.\datapath_inst/regfile_inst/register[4][0] 
    };
    wire [15:0] probe_reg5 = {
        U1.\datapath_inst/regfile_inst/register[5][15] ,
        U1.\datapath_inst/regfile_inst/register[5][14] ,
        U1.\datapath_inst/regfile_inst/register[5][13] ,
        U1.\datapath_inst/regfile_inst/register[5][12] ,
        U1.\datapath_inst/regfile_inst/register[5][11] ,
        U1.\datapath_inst/regfile_inst/register[5][10] ,
        U1.\datapath_inst/regfile_inst/register[5][9] ,
        U1.\datapath_inst/regfile_inst/register[5][8] ,
        U1.\datapath_inst/regfile_inst/register[5][7] ,
        U1.\datapath_inst/regfile_inst/register[5][6] ,
        U1.\datapath_inst/regfile_inst/register[5][5] ,
        U1.\datapath_inst/regfile_inst/register[5][4] ,
        U1.\datapath_inst/regfile_inst/register[5][3] ,
        U1.\datapath_inst/regfile_inst/register[5][2] ,
        U1.\datapath_inst/regfile_inst/register[5][1] ,
        U1.\datapath_inst/regfile_inst/register[5][0] 
    };
    wire [15:0] probe_reg6 = {
        U1.\datapath_inst/regfile_inst/register[6][15] ,
        U1.\datapath_inst/regfile_inst/register[6][14] ,
        U1.\datapath_inst/regfile_inst/register[6][13] ,
        U1.\datapath_inst/regfile_inst/register[6][12] ,
        U1.\datapath_inst/regfile_inst/register[6][11] ,
        U1.\datapath_inst/regfile_inst/register[6][10] ,
        U1.\datapath_inst/regfile_inst/register[6][9] ,
        U1.\datapath_inst/regfile_inst/register[6][8] ,
        U1.\datapath_inst/regfile_inst/register[6][7] ,
        U1.\datapath_inst/regfile_inst/register[6][6] ,
        U1.\datapath_inst/regfile_inst/register[6][5] ,
        U1.\datapath_inst/regfile_inst/register[6][4] ,
        U1.\datapath_inst/regfile_inst/register[6][3] ,
        U1.\datapath_inst/regfile_inst/register[6][2] ,
        U1.\datapath_inst/regfile_inst/register[6][1] ,
        U1.\datapath_inst/regfile_inst/register[6][0] 
    };
    wire [15:0] probe_reg7 = {
        U1.\datapath_inst/regfile_inst/register[7][15] ,
        U1.\datapath_inst/regfile_inst/register[7][14] ,
        U1.\datapath_inst/regfile_inst/register[7][13] ,
        U1.\datapath_inst/regfile_inst/register[7][12] ,
        U1.\datapath_inst/regfile_inst/register[7][11] ,
        U1.\datapath_inst/regfile_inst/register[7][10] ,
        U1.\datapath_inst/regfile_inst/register[7][9] ,
        U1.\datapath_inst/regfile_inst/register[7][8] ,
        U1.\datapath_inst/regfile_inst/register[7][7] ,
        U1.\datapath_inst/regfile_inst/register[7][6] ,
        U1.\datapath_inst/regfile_inst/register[7][5] ,
        U1.\datapath_inst/regfile_inst/register[7][4] ,
        U1.\datapath_inst/regfile_inst/register[7][3] ,
        U1.\datapath_inst/regfile_inst/register[7][2] ,
        U1.\datapath_inst/regfile_inst/register[7][1] ,
        U1.\datapath_inst/regfile_inst/register[7][0] 
    };
    wire [15:0] probe_ram0 = {
        U1.\datapath_inst/data_mem_inst/ram[0][15] ,
        U1.\datapath_inst/data_mem_inst/ram[0][14] ,
        U1.\datapath_inst/data_mem_inst/ram[0][13] ,
        U1.\datapath_inst/data_mem_inst/ram[0][12] ,
        U1.\datapath_inst/data_mem_inst/ram[0][11] ,
        U1.\datapath_inst/data_mem_inst/ram[0][10] ,
        U1.\datapath_inst/data_mem_inst/ram[0][9] ,
        U1.\datapath_inst/data_mem_inst/ram[0][8] ,
        U1.\datapath_inst/data_mem_inst/ram[0][7] ,
        U1.\datapath_inst/data_mem_inst/ram[0][6] ,
        U1.\datapath_inst/data_mem_inst/ram[0][5] ,
        U1.\datapath_inst/data_mem_inst/ram[0][4] ,
        U1.\datapath_inst/data_mem_inst/ram[0][3] ,
        U1.\datapath_inst/data_mem_inst/ram[0][2] ,
        U1.\datapath_inst/data_mem_inst/ram[0][1] ,
        U1.\datapath_inst/data_mem_inst/ram[0][0] 
    };
    wire [15:0] probe_ram1 = {
        U1.\datapath_inst/data_mem_inst/ram[1][15] ,
        U1.\datapath_inst/data_mem_inst/ram[1][14] ,
        U1.\datapath_inst/data_mem_inst/ram[1][13] ,
        U1.\datapath_inst/data_mem_inst/ram[1][12] ,
        U1.\datapath_inst/data_mem_inst/ram[1][11] ,
        U1.\datapath_inst/data_mem_inst/ram[1][10] ,
        U1.\datapath_inst/data_mem_inst/ram[1][9] ,
        U1.\datapath_inst/data_mem_inst/ram[1][8] ,
        U1.\datapath_inst/data_mem_inst/ram[1][7] ,
        U1.\datapath_inst/data_mem_inst/ram[1][6] ,
        U1.\datapath_inst/data_mem_inst/ram[1][5] ,
        U1.\datapath_inst/data_mem_inst/ram[1][4] ,
        U1.\datapath_inst/data_mem_inst/ram[1][3] ,
        U1.\datapath_inst/data_mem_inst/ram[1][2] ,
        U1.\datapath_inst/data_mem_inst/ram[1][1] ,
        U1.\datapath_inst/data_mem_inst/ram[1][0] 
    };
    wire [15:0] probe_ram2 = {
        U1.\datapath_inst/data_mem_inst/ram[2][15] ,
        U1.\datapath_inst/data_mem_inst/ram[2][14] ,
        U1.\datapath_inst/data_mem_inst/ram[2][13] ,
        U1.\datapath_inst/data_mem_inst/ram[2][12] ,
        U1.\datapath_inst/data_mem_inst/ram[2][11] ,
        U1.\datapath_inst/data_mem_inst/ram[2][10] ,
        U1.\datapath_inst/data_mem_inst/ram[2][9] ,
        U1.\datapath_inst/data_mem_inst/ram[2][8] ,
        U1.\datapath_inst/data_mem_inst/ram[2][7] ,
        U1.\datapath_inst/data_mem_inst/ram[2][6] ,
        U1.\datapath_inst/data_mem_inst/ram[2][5] ,
        U1.\datapath_inst/data_mem_inst/ram[2][4] ,
        U1.\datapath_inst/data_mem_inst/ram[2][3] ,
        U1.\datapath_inst/data_mem_inst/ram[2][2] ,
        U1.\datapath_inst/data_mem_inst/ram[2][1] ,
        U1.\datapath_inst/data_mem_inst/ram[2][0] 
    };

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

        $stop;
    end

endmodule