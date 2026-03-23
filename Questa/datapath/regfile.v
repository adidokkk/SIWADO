module regfile(
    input wire clkb,
    input wire rst,

    input wire [2:0] rd_addr,
    input wire [2:0] rs_addr,
    input wire [2:0] rt_addr,

    input wire reg_write,
    input wire [15:0] write_data_i,

    output reg [15:0] operand1_o,
    output reg [15:0] operand2_o,
    output reg [15:0] rd_data_o
);

reg [15:0] register [0:7];
integer i;

always @(negedge clkb) begin
    if (rst) begin
        for (i = 0; i < 8; i = i + 1)
            register[i] <= 16'b0;
    end else if (reg_write && rd_addr != 3'b000) begin
        register[rd_addr] <= write_data_i;
    end
end

always @(*) begin
    operand1_o = (rs_addr == 3'b000) ? 16'b0 : register[rs_addr];
    operand2_o = (rt_addr == 3'b000) ? 16'b0 : register[rt_addr];
    rd_data_o  = (rd_addr == 3'b000) ? 16'b0 : register[rd_addr];
end

endmodule
