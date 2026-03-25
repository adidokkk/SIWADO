// Register File
    // It has eight general purpose registers (R0​–R7​),
    // with R0 hardwired to logic zero.

module regfile (
    // External inputs
    input wire clkb,
    input wire rst,

    // Internal inputs from datapath (IR)
    input wire [2:0] rd,
    input wire [2:0] rs1,
    input wire [2:0] rs2,

    // Internal input from datapath
    input wire [15:0] write_data,

    // Internal input from FSM
    input wire reg_write,

    // Internal output to datapath (ALU)
    output reg [15:0] add1,
    output reg [15:0] add2,
    output reg [15:0] rd_data
);

    integer i;
    reg [15:0] register [0:7];

    // Write in registers
    always @(negedge clkb) 
    begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1)
                register[i] <= 16'b0;
        end else if (reg_write &&  rd != 3'b000)
            register[rd] <= write_data;
    end

    // Hardwire R0 to logic zero
    always @(*) 
    begin
        add1 = (rs1 == 3'b000) ? 16'b0 : register[rs1];
        add2 = (rs2 == 3'b000) ? 16'b0 : register[rs2];
        rd_data = (rd == 3'b000) ? 16'b0 : register[rd];
    end

endmodule