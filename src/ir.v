// Instruction Register (IR)
    // It holds instr_in and isolates it from Instruction Memory, 
    // thus preventing the instructions to change after PC updates.

module ir (
    // External inputs
    input wire clkb,
    input wire rst,

    // Internal input from datapath (Instruction Memory)
    input wire [15:0] instr_in,

    // Internal input from FSM
    input wire ir_load,
    
    // Internal outputs to datapath
        // opcode, imm_raw to Immediate Generator
        // rd, rs1, rs2 to Register File
    output wire [3:0] opcode,
    output wire [2:0] rd, // destination register
    output wire [2:0] rs1, // source register 1
    output wire [2:0] rs2, // source register 2
    output wire [5:0] imm_raw // raw immediate
);
    
    reg [15:0] instr;

    assign opcode = instr[15:12];
    assign rd = instr[11:9];
    assign rs1 = instr[8:6];
    assign rs2 = instr[5:3];
    assign imm_raw = instr[5:0];

    always @(negedge clkb) 
    begin
        if (rst)
            instr <= 16'b0;
        else if (ir_load)
            instr <= instr_in;
    end

endmodule