module shifter_unit(
    input  wire        clkb,
    input  wire        rst,
    input  wire        en,
    input  wire [15:0] src_data,
    input  wire [15:0] aux_data,
    input  wire [15:0] accum_data,
    input  wire [1:0]  shifter_op,
    output reg  [15:0] result_o,
    output reg         done_o
);

localparam SHIFT_LSL = 2'b00;
localparam SHIFT_LSR = 2'b01;
localparam SHIFT_MAC = 2'b10;
localparam SHIFT_CLZ = 2'b11;

reg        busy;
reg [4:0]  iter;
reg [4:0]  target;

reg [15:0] shift_reg;
reg [4:0]  clz_count;
reg        clz_found;

reg [15:0] mac_a_abs;
reg [15:0] mac_b_abs;
reg        mac_neg;
reg [31:0] mac_multiplicand;
reg [15:0] mac_multiplier;
reg [31:0] mac_product;
reg [31:0] mac_next_product;
wire [31:0] mac_signed_product = mac_neg ? (~mac_next_product + 32'd1) : mac_next_product;

always @(negedge clkb) begin
    if (rst) begin
        busy            <= 1'b0;
        iter            <= 5'd0;
        target          <= 5'd0;
        result_o        <= 16'd0;
        done_o          <= 1'b0;
        shift_reg       <= 16'd0;
        clz_count       <= 5'd0;
        clz_found       <= 1'b0;
        mac_a_abs       <= 16'd0;
        mac_b_abs       <= 16'd0;
        mac_neg         <= 1'b0;
        mac_multiplicand<= 32'd0;
        mac_multiplier  <= 16'd0;
        mac_product     <= 32'd0;
        mac_next_product<= 32'd0;
    end else begin
        done_o <= 1'b0;
        mac_next_product <= mac_product;

        if (!en) begin
            busy <= 1'b0;
            iter <= 5'd0;
        end else if (!busy) begin
            busy   <= 1'b1;
            iter   <= 5'd0;

            case (shifter_op)
                SHIFT_LSL: begin
                    target    <= {1'b0, aux_data[3:0]};
                    shift_reg <= src_data;
                    if (aux_data[3:0] == 4'd0) begin
                        result_o <= src_data;
                        done_o   <= 1'b1;
                        busy     <= 1'b0;
                    end
                end

                SHIFT_LSR: begin
                    target    <= {1'b0, aux_data[3:0]};
                    shift_reg <= src_data;
                    if (aux_data[3:0] == 4'd0) begin
                        result_o <= src_data;
                        done_o   <= 1'b1;
                        busy     <= 1'b0;
                    end
                end

                SHIFT_MAC: begin
                    target           <= 5'd16;
                    mac_a_abs        <= src_data[15] ? (~src_data + 16'd1) : src_data;
                    mac_b_abs        <= aux_data[15] ? (~aux_data + 16'd1) : aux_data;
                    mac_neg          <= src_data[15] ^ aux_data[15];
                    mac_multiplicand <= {16'd0, (src_data[15] ? (~src_data + 16'd1) : src_data)};
                    mac_multiplier   <= aux_data[15] ? (~aux_data + 16'd1) : aux_data;
                    mac_product      <= 32'd0;
                end

                SHIFT_CLZ: begin
                    target    <= 5'd16;
                    shift_reg <= src_data;
                    clz_count <= 5'd0;
                    clz_found <= 1'b0;
                end
            endcase
        end else begin
            case (shifter_op)
                SHIFT_LSL: begin
                    shift_reg <= shift_reg << 1;
                    iter <= iter + 5'd1;
                    if (iter + 5'd1 >= target) begin
                        result_o <= shift_reg << 1;
                        done_o   <= 1'b1;
                        busy     <= 1'b0;
                    end
                end

                SHIFT_LSR: begin
                    shift_reg <= shift_reg >> 1;
                    iter <= iter + 5'd1;
                    if (iter + 5'd1 >= target) begin
                        result_o <= shift_reg >> 1;
                        done_o   <= 1'b1;
                        busy     <= 1'b0;
                    end
                end

                SHIFT_MAC: begin
                    mac_next_product = mac_multiplier[0] ? (mac_product + mac_multiplicand) : mac_product;
                    mac_product <= mac_next_product;

                    mac_multiplicand <= mac_multiplicand << 1;
                    mac_multiplier   <= mac_multiplier >> 1;
                    iter <= iter + 5'd1;

                    if (iter + 5'd1 >= target) begin
                        result_o <= accum_data + mac_signed_product[15:0];
                        done_o   <= 1'b1;
                        busy     <= 1'b0;
                    end
                end

                SHIFT_CLZ: begin
                    if (!clz_found) begin
                        if (shift_reg[15]) begin
                            clz_found <= 1'b1;
                            result_o  <= {11'd0, clz_count};
                            done_o    <= 1'b1;
                            busy      <= 1'b0;
                        end else begin
                            shift_reg <= shift_reg << 1;
                            clz_count <= clz_count + 5'd1;
                            iter      <= iter + 5'd1;

                            if (iter + 5'd1 >= 5'd16) begin
                                result_o <= 16'd16;
                                done_o   <= 1'b1;
                                busy     <= 1'b0;
                            end
                        end
                    end
                end
            endcase
        end
    end
end

endmodule
