module ins_mem(
    input  wire [15:0] addr,
    output reg  [15:0] instr
);

reg [15:0] rom [0:15];

always @(*) begin
    case (addr[3:0])
        4'd0: instr = 16'hC205; // ADDI R1, R0, 5   R1 = 5
        4'd1: instr = 16'hB403; // LUI R2, 3        R2 = 3072/0c00
        4'd2: instr = 16'h0650; // ADD R3, R1, R2   R3 = 3077
        4'd3: instr = 16'hA042; // BNE  R1, R2, 2
        4'd4: instr = 16'hC601; // ADDI R3, R0, 1  
        4'd5: instr = 16'hC602; // ADDI R3, R0, 2 
        // RAM
        4'd6: instr = 16'hE280; // SW R1, 0(R2)      RAM[0] = 5
        4'd7: instr = 16'hD680; // LW R3, 0(R2)      R3 = 5
        // MMIO
        4'd8: instr = 16'hB43F; // LUI R2, 63        R2 = 0xFC00
        4'd9: instr = 16'hE280; // SW R1, 0(R2)      out_port = 5
        4'd10: instr = 16'hD680; // LW R3, 0(R2)     R3 = 5
        // shifter logic
        //
        default: instr = 16'hF000;
    endcase
end

endmodule