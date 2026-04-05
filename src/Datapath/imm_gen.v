// Immediate Generator
    // It generates the immediate from imm_raw depending on opcode.

module imm_gen (
    // Internal inputs from datapath (IR)
    input wire [3:0] opcode,
    input wire [5:0] imm_raw,

    // Internal output
    output reg [15:0] imm
);

    parameter OP_BEQ = 4'b1001;
    parameter OP_BNE = 4'b1010;
    parameter OP_LUI = 4'b1011;
    parameter OP_ADDI = 4'b1100;
    parameter OP_LW = 4'b1101;
    parameter OP_SW = 4'b1110;

    always @(*) 
    begin
        case (opcode)
            // ADDI, LW, SW, BEQ, BNE: extend imm_raw to 16 bits
            OP_BEQ, OP_BNE, OP_ADDI, OP_LW, OP_SW : imm = {{10{imm_raw[5]}}, imm_raw};

            // LUI: prepare upper immediate
            OP_LUI : imm = {imm_raw, 10'b0};

            default: imm = 16'b0;
        endcase
    end

endmodule