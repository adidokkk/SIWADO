// instruction register       
module ir(
    input wire clkb,
    input wire rst,
    input wire ir_load,
    input wire [15:0] instr_in,

    output wire [3:0] opcode,
    output wire [2:0] rd_addr,
    output wire [2:0] rs_addr,
    output wire [2:0] rt_addr,
    output wire [5:0]  imm_raw
);
    
reg [15:0] instr;

always @(negedge clkb) begin
    if (rst)
        instr <= 16'b0;
    else if (ir_load)
        instr <= instr_in;
end

// decode
assign opcode  = instr[15:12];
assign rd_addr = instr[11:9];
assign rs_addr = instr[8:6];
assign rt_addr = instr[5:3];
assign imm_raw = instr[5:0];

endmodule