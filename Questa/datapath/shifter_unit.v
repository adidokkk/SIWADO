module shifter_unit(
    input  wire        clkb,
    input  wire        rst,

    
    input  wire        shifter_en,    // pulse to start operation
    input  wire [1:0]  shifter_op,    // 00=LSL, 01=LSR, 10=MAC, 11=CLZ
    input  wire [15:0] operand1_i,   // Rs1
    input  wire [15:0] operand2_i,   // Rs2 (shift amount or multiplier)
    input  wire [15:0] rd_i,         // Rd (accumulator input for MAC)

    // outputs
    output reg  [15:0] result_o,     // result to writeback
    output reg         done_o        // pulses high for 1 cycle when complete
);

localparam OP_LSL = 2'b00;
localparam OP_LSR = 2'b01;
localparam OP_MAC = 2'b10;
localparam OP_CLZ = 2'b11;

reg        active;
reg [1:0]  cur_op;
reg [4:0]  cycle_cnt;

// MAC state: 32-bit accumulator, shifting multiplicand and multiplier
reg [31:0] mac_accum;
reg [31:0] mac_mcand;   // sign-extended Rs1, shifted left each cycle
reg [15:0] mac_mult;    // Rs2, shifted right each cycle

// CLZ state
reg [15:0] clz_val;
reg [4:0]  clz_count;

always @(posedge clkb or posedge rst) begin
    if (rst) begin
        active    <= 1'b0;
        done_o    <= 1'b0;
        result_o  <= 16'b0;
        cur_op    <= 2'b0;
        cycle_cnt <= 5'b0;
        mac_accum <= 32'b0;
        mac_mcand <= 32'b0;
        mac_mult  <= 16'b0;
        clz_val   <= 16'b0;
        clz_count <= 5'b0;
    end else begin
        done_o <= 1'b0; // default: not done

        if (shifter_en && !active) begin
            // ---- Launch new operation ----
            cur_op    <= shifter_op;
            cycle_cnt <= 5'd0;

            case (shifter_op)
                OP_LSL: begin
                    // Single-cycle logical shift left
                    result_o <= operand1_i << operand2_i[3:0];
                    done_o   <= 1'b1;
                end

                OP_LSR: begin
                    // Single-cycle logical shift right
                    result_o <= operand1_i >> operand2_i[3:0];
                    done_o   <= 1'b1;
                end

                OP_MAC: begin
                    //16-cycle sequential multiply-accumulate
                    //shift-and-add (Rs1 sign-extended × Rs2)
                    mac_accum <= 32'd0;
                    mac_mcand <= {{16{operand1_i[15]}}, operand1_i}; // sign extend
                    mac_mult  <= operand2_i;
                    active    <= 1'b1;
                end

                OP_CLZ: begin
                    // Kick off iterative count-leading-zeros
                    clz_val   <= operand1_i;
                    clz_count <= 5'd0;
                    active    <= 1'b1;
                end
            endcase

        end else if (active) begin
            // ---- Continue multi-cycle operation ----
            case (cur_op)
                OP_MAC: begin
                    if (cycle_cnt < 5'd16) begin
                        // Each cycle: if current multiplier LSB is set,
                        // add the (already position-shifted) multiplicand
                        if (mac_mult[0])
                            mac_accum <= mac_accum + mac_mcand;
                        mac_mcand <= mac_mcand << 1;  // advance position
                        mac_mult  <= mac_mult  >> 1;  // consume next bit
                        cycle_cnt <= cycle_cnt + 1'b1;
                    end else begin
                        // Done: Rd = Rd + product[15:0]
                        result_o <= rd_i + mac_accum[15:0];
                        done_o   <= 1'b1;
                        active   <= 1'b0;
                    end
                end

                OP_CLZ: begin
                    if (clz_val[15] || clz_count == 5'd16) begin
                        // Found first '1' or exhausted all 16 bits (value=0)
                        result_o <= {11'b0, clz_count};
                        done_o   <= 1'b1;
                        active   <= 1'b0;
                    end else begin
                        clz_val   <= clz_val << 1;
                        clz_count <= clz_count + 1'b1;
                    end
                end

                default: active <= 1'b0;
            endcase
        end
    end
end

endmodule
