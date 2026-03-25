// Data Memory with RAM + MMIO (Memory-Mapped I/O)
// MMIO base address: 0xFC00 (must use 0xFCxx address range)
module data_mem(
    input  wire        clkb,
    input  wire        rst,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [15:0] addr,
    input  wire [15:0] write_data,
    input  wire [15:0] in_port_i,    // external input (MMIO)
    output reg  [15:0] read_data,
    output reg  [15:0] out_port_o    // external output (MMIO)
);

reg [15:0] ram [0:255];
integer i;

always @(negedge clkb) begin
    if (rst) begin
        out_port_o <= 16'b0;
        for (i = 0; i < 256; i = i + 1)
            ram[i] <= 16'b0;

    end else if (mem_write) begin  //SW
        if (addr[15:8] == 8'hFC) begin
            case (addr[7:0])
                8'h00: out_port_o <= write_data; // FC00
                default: ; // do nothing
            endcase
        end else begin
            ram[addr[7:0]] <= write_data;
        end

    end
end

always @(*) begin  //LW
    if (!mem_read)
        read_data = 16'b0;

    else if (addr[15:8] == 8'hFC) begin
        case (addr[7:0])
            8'h00: read_data = out_port_o; // FC00
            8'h02: read_data = in_port_i;  // FC02
            default: read_data = 16'b0;
        endcase

    end else begin
        read_data = ram[addr[7:0]]; 
    end
end

endmodule