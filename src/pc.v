// Program Counter (PC)
    // It keeps track of current instruction to execute.

module pc (
    // External inputs
    input wire clkb,
    input wire rst,

    // Internal input from datapath
    input wire [15:0] branch_target,

    // Internal inputs from FSM
    input wire pc_write, // 1 = update PC, 0 = hold
    input wire pc_src, // 0 = PC++, 1 = branch target

    // Internal output to datapath (Instruction Memory)
    output reg [15:0] pc_out
);

    always @(negedge clkb) 
    begin
        if (rst)
            pc_out <= 16'b0;
        else if (pc_write) begin
            if (!pc_src)
                pc_out <= pc_out + 1;
            else
                pc_out <= branch_target;
        end
    end

endmodule