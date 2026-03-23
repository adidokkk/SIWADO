module imm_gen(
    input  wire [3:0] opcode,
    input  wire [5:0] imm_raw,
    output reg  [15:0] imm_out
);

always @(*) begin
    case(opcode)
        // ADDI / LW / SW / BEQ / BNE use sign-extended 6-bit immediate
        4'b1100,
        4'b1101,
        4'b1110,
        4'b1001,
        4'b1010: imm_out = {{10{imm_raw[5]}}, imm_raw};

        // LUI
        4'b1011: imm_out = {imm_raw, 10'b0};

        default: imm_out = 16'b0;
    endcase
end

endmodule
