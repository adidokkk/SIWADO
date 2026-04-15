// Instruction Memory
    // It stores and fetches instructions by address.

module ins_mem (
    // Internal input from datapath
    input wire clk,

    // Internal input from datapath (PC)
    input wire [15:0] addr, // pc_out
    input wire load_en,
    input wire load_done,
    input wire [4:0] load_addr,
    input wire [15:0] load_data,

    // Internal output to datapath (IR)
    output reg [15:0] instr
);

    localparam [15:0] HALT = 16'b1111_000_000_000000;
    localparam integer DEPTH = 6;
    integer i;

    // COMMENT BELOW FOR POST-LAYOUT TESTING SYNTHESIS
    // ===================================================================
    // Default every slot to HALT. The testbench or padframe-style loading
    // path overwrites only the small program section under test.
    reg [15:0] mem [0:DEPTH-1];
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = HALT;
    end
    // ===================================================================

    // During the reset-held loading phase, external logic can overwrite
    // selected instruction slots before the CPU starts fetching.
    always @(negedge clk)
    begin
        if (load_en && !load_done && (load_addr < DEPTH))
            mem[load_addr] <= load_data;
    end

    always @(*) 
    begin
        // COMMENT BELOW FOR POST-LAYOUT TESTING SYNTHESIS
        // ===================================================================
        if (addr >= DEPTH)
            instr = HALT;
        else if (mem[addr] === 16'bx)
            instr = HALT;
        else
            instr = mem[addr];
        // ===================================================================

        // UNCOMMENT BELOW FOR POST-LAYOUT TESTING SYNTHESIS
        // ===================================================================
        // case (addr)
        //     // Arithmetic 
        //     16'd0  : instr = 16'b1100_0010_000_00101;    // ADDI R1, R0, 5
        //     16'd1  : instr = 16'b1011_010_000_000011;    // LUI  R2, 3
        //     16'd2  : instr = 16'b0000_011_001_010_000;   // ADD  R3, R1, R2
        //     16'd3  : instr = 16'b1100_100_001_110111;    // ADDI R4, R1, -9
        //     16'd4  : instr = 16'b0001_101_100_100_000;   // SUB  R5, R4, R4
        //     // Logic
        //     16'd5  : instr = 16'b0010_110_011_100_000;   // AND  R6, R3, R4
        //     16'd6  : instr = 16'b0011_111_001_100_000;   // OR   R7, R1, R4
        //     16'd7  : instr = 16'b0100_011_010_111_000;   // XOR  R3, R2, R7
        //     // RAM
        //     16'd8  : instr = 16'b1110_001_010_000010;    // SW  R1, 2(R2)
        //     16'd9  : instr = 16'b1101_010_010_000010;    // LW  R2, 2(R2)
        //     // Branch
        //     16'd10 : instr = 16'b1100_001_000_000011;    // ADDI R1, R0, 3
        //     16'd11 : instr = 16'b1100_010_000_000010;    // ADDI R2, R0, 2
        //         // FOR_LOOP:
        //         16'd12 : instr = 16'b0000_011_000_101_000;   // ADD R3, R0, R5
        //         16'd13 : instr = 16'b1100_101_101_000001;    // ADDI R5, R5, 1
        //         16'd14 : instr = 16'b1001_011_010_000001;    // BEQ R3, R2, 1
        //         16'd15 : instr = 16'b1110_111_011_000000;    // SW R7, 0(R3)
        //         16'd16 : instr = 16'b1010_101_001_111011;    // BNE R5, R1, FOR_LOOP
        //     // MMIO
        //     16'd17 : instr = 16'b1011_010_000_111111;    // LUI R2, 63
        //     16'd18 : instr = 16'b1110_100_010_000000;    // SW  R4, 0(R2)
        //     16'd19 : instr = 16'b1101_011_010_000010;    // LW  R3, 2(R2)
        //     // Shifter
        //     16'd20 : instr = 16'b0101_011_001_001_000;   // LSL R3, R1, R1
        //     16'd21 : instr = 16'b0110_111_001_001_000;   // LSR R7, R1, R1
        //     16'd22 : instr = 16'b1000_100_110_000000;    // CLZ R4, R6
        //     16'd23 : instr = 16'b0111_110_101_101_000;   // MAC R6, R5, R5
        //     // HALT
        //     16'd24 : instr = 16'b1111_000_000_000000;    // HALT

        //     default : instr = 16'b1111_000_000_000000;  // HALT
        // endcase
        // ===================================================================

    end

endmodule
