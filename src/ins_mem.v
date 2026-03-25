// Instruction Memory
    // It stores and fetches instructions by address.

module ins_mem (
    // Internal input from datapath (PC)
    input wire [3:0] addr, // pc_out

    // Internal output to datapath (IR)
    output reg [15:0] instr
);

    always @(*) 
    begin
        case (addr)
            // Arithmetic
            4'd0 : instr = 16'b1100_001_000_000101; // ADDI R1, R0, 5 => R1 = 5
            4'd1 : instr = 16'b1011_010_000_000011; // LUI R2, 3 => R2 = 3072
            4'd2 : instr = 16'b0000_011_001_010_000; // ADD R3, R1, R2 => R3 = 3077
            4'd3 : instr = 16'b1010_001_010_000010; // BNE R1, R2, 2 => Taken
                // Should be skipped
                4'd4 : instr = 16'b1100_011_000_000001; // ADDI R3, R0, 1 => R3 = 1
                4'd5 : instr = 16'b1100_011_000_000010; // ADDI R3, R0, 2 => R3 = 2

            // RAM
            4'd6 : instr = 16'b1110_001_010_000000; // SW R1, 0(R2)
            4'd7 : instr = 16'b1101_011_010_000000; // LW R3, 0(R2)

            // MMIO
            4'd8 : instr = 16'b1011_010_000_111111; // LUI R2, 63 => R2 = 64512
            4'd9 : instr = 16'b1110_001_010_000000; // SW R1, 0(R2)
            4'd10 : instr = 16'b1101_011_010_000010; // LW R3, 2(R2)

            // Shifter
            4'd11 : instr = 16'b0101_011_001_001_000; // LSL R3, R1, R1 => R3 = 160
            4'd12 : instr = 16'b0110_011_001_001_000; // LSR R3, R1, R1 => R3 = 0
            4'd13 : instr = 16'b1000_011_001_000_000; // CLZ R3, R1 => R3 = 13
            4'd14 : instr = 16'b0111_011_001_001_000; // MAC R3, R1, R1 => R3 = accum + 25

            default : instr = 16'b1111_000_000_000000; // HALT
        endcase
    end

endmodule