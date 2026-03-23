module pc(
    input wire clkb,
    input wire rst,
    input wire pc_write,
    input wire pc_src,
    input wire [15:0] branch_target,
    output reg [15:0] pc_o
);

always @(negedge clkb) begin
    if (rst)
        pc_o <= 16'd0;
    else if (pc_write) begin
        if (!pc_src)
            pc_o <= pc_o + 16'd1;
        else
            pc_o <= branch_target;
    end
end

endmodule