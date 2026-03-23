module alu(
    // operands from regfile
    input  wire signed [15:0] operand1_i,
    input  wire signed [15:0] operand2_i,
    
    // control siganls from fsm
    input  wire [3:0]  alu_op,
    
    // output signals to writeback
    output reg [15:0] result_o
);

always @(*) begin
    case(alu_op)
        
        // 1.	Register-ALU instructions
        4'b0000: result_o = operand1_i + operand2_i; // ADD
        4'b0001: result_o = operand1_i - operand2_i; // SUB
        4'b0010: result_o = operand1_i & operand2_i; // AND
        4'b0011: result_o = operand1_i | operand2_i; // OR
        4'b0100: result_o = operand1_i ^ operand2_i; // XOR
        // 2. Immediate instructions
        4'b1011: result_o = operand2_i;              // LUI
        4'b1100: result_o = operand1_i + operand2_i; // ADDI

        default: result_o = 16'b0;

    endcase
end

endmodule