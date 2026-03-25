// Arithmetic Logic Unit (ALU)
    // It performs arithmetic operations.

module alu (
    // Internal inputs from Register File
    input wire signed [15:0] add1,
    input wire signed [15:0] add2, // passed based on alu_src (0 = register, 1 = immediate)
    
    // Internal input from FSM
    input wire [3:0] alu_op,
    
    // Output signals to writeback
    output reg [15:0] result
);

    parameter OP_ADD = 4'b0000;
    parameter OP_SUB = 4'b0001;
    parameter OP_AND = 4'b0010;
    parameter OP_OR = 4'b0011;
    parameter OP_XOR = 4'b0100;
    parameter OP_LUI = 4'b1011;
    parameter OP_SW = 4'b1110;
    parameter OP_HALT = 4'b1111;

    always @(*)
    begin
        case (alu_op)
            OP_ADD : result = add1 + add2;
            OP_SUB : result = add1 - add2;
            OP_AND : result = add1 & add2;
            OP_OR : result = add1 | add2;
            OP_XOR : result = add1 ^ add2;

            OP_LUI : result = add2;

            default : result = 16'b0;
        endcase
    end

endmodule