// Data Memory
    // It represents RAM and MMIO.
    // The memory is word-indexed.

module data_mem (
    // External inputs
    input wire clkb,
    input wire rst,
    input wire [15:0] in_port, // input from MMIO

    // Internal inputs from datapath
    input wire [15:0] addr,
    input wire [15:0] write_data,

    // Internal inputs from FSM
    input wire mem_read,
    input wire mem_write,
    input wire out_port_en,

    // Internal output to datapath
    output reg [15:0] read_data,

    // External output to MMIO
    output reg [15:0] out_port
);

    integer i;
    reg [15:0] ram [0:255];

    always @(negedge clkb) 
    begin : SW
        if (rst) begin
            out_port <= 16'b0;
            for (i = 0; i < 256; i = i + 1)
                ram[i] <= 16'b0;
        end else if (mem_write) begin
            if (addr[15:8] == 8'hFC) begin
                if (out_port_en) 
                    out_port <= write_data;
            end else
                ram[addr[7:0]] <= write_data;
        end
    end

    always @(*) 
    begin : LW
        if (!mem_read)
            read_data = 16'b0;
        else if (addr[15:8] == 8'hFC) begin
            case (addr[7:0])
                8'h00 : read_data = out_port; // FC00
                8'h02 : read_data = in_port;  // FC02

                default : read_data = 16'b0;
            endcase
        end else
            read_data = ram[addr[7:0]]; 
    end

endmodule