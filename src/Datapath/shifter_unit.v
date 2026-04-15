// Shifter Unit
    // It handles signed MAC, CLZ, LSL, and LSR operations
    // with dual-clock interleaved structure to maximize
    // throughput.

    // POTENTIAL OPTIMIZATIONS: 
        //  1) CLZ combinational (priority encoder)
        //  2) use comb. CLZ to skip lead. zeros in MAC
    // However, making CLZ comb. would be too easy so 
    // for ed. purposes we won't change it.

module shifter_unit (
    // External inputs
    input wire clk,
    input wire rst,

    // Internal inputs from FSM
    input wire shifter_en,
    input wire [1:0] shifter_op,

    // Internal inputs from datapath
    input wire [15:0] mul1,
    input wire [15:0] mul2,
    input wire [15:0] accum,

    // Internal outputs to datapath
    output reg [15:0] result,

    // Internal output to FSM
    output reg counter_done
);

    parameter OP_LSL = 2'b00;
    parameter OP_LSR = 2'b01;
    parameter OP_MAC = 2'b10;
    parameter OP_CLZ = 2'b11;

    reg active;
    reg [3:0] cycle_count;

    // MAC state
    reg [31:0] mac_accum;
    reg [31:0] mac_mcand;

    reg [15:0] shift_reg;

    reg [15:0] result_a, result_b;
    reg counter_done_a, counter_done_b;
    reg active_a, active_b;
    reg [3:0] cycle_count_a, cycle_count_b;
    reg [15:0] shift_reg_a, shift_reg_b;
    reg [31:0] mac_accum_a, mac_accum_b;
    reg [31:0] mac_mcand_a, mac_mcand_b;
    reg negneg_clk, pospos_clk;

    wire negpos_clk = ~(negneg_clk ^ pospos_clk); // XNOR (registered ~clk)

    always @(*)
    begin
        active = active_a || active_b;
        counter_done = counter_done_a || counter_done_b;
        result = result_a;
        cycle_count = cycle_count_a;
        shift_reg = shift_reg_a;
        mac_accum = mac_accum_a;
        mac_mcand = mac_mcand_a;

        if (rst) begin
            result = 16'b0; 
            cycle_count = 4'b0;
            shift_reg = 16'b0;
            mac_accum = 32'b0;
            mac_mcand = 32'b0;
        end else if (active && !counter_done) begin
            if (negpos_clk) begin
                cycle_count = cycle_count_a;
                shift_reg = shift_reg_a;
                mac_accum = mac_accum_a;
                mac_mcand = mac_mcand_a;
            end else begin
                cycle_count = cycle_count_b;
                shift_reg = shift_reg_b;
                mac_accum = mac_accum_b;
                mac_mcand = mac_mcand_b;
            end
        end
    end

    always @(negedge clk)
    begin
        if (rst) begin
            result_a <= 16'b0;
            counter_done_a <= 0;
            active_a <= 0;
            cycle_count_a <= 4'b0;
            shift_reg_a <= 16'b0;
            mac_accum_a <= 32'b0;
            mac_mcand_a <= 32'b0;
            negneg_clk <= 0;
        end else begin
            counter_done_a <= 0;
            negneg_clk <= ~negneg_clk;

            if (shifter_en && !active) begin // if not active, start multi-cycle operation
                cycle_count_a <= 4'b0001;
                active_a <= ~counter_done; // ensure `shifter_en` goes low before lowering `active`

                case (shifter_op)
                    OP_LSL, OP_LSR : begin
                        if (mul2[3:0] == 0) begin
                            result_a <= mul1;
                            counter_done_a <= 1;
                            active_a <= 0;
                        end else begin
                            shift_reg_a <= shifter_op == OP_LSL ? mul1 << 1 : mul1 >> 1;
                        end
                    end

                    OP_MAC : begin
                        if (!mul1 || !mul2) begin
                            result_a <= accum;
                            counter_done_a <= 1;
                            active_a <= 0;
                        end else begin
                            mac_accum_a <= mul2[0] ? {{16{mul1[15]}}, mul1} : 32'b0;
                            mac_mcand_a <= {{16{mul1[15]}}, mul1} << 1;
                            shift_reg_a <= mul2 >> 1;
                        end
                    end

                    OP_CLZ : begin
                        if (mul1[15]) begin
                            result_a <= 16'b0;
                            counter_done_a <= 1;
                            active_a <= 0;
                        end else if (mul1 == 16'b0) begin
                            result_a <= 16'h10;
                            counter_done_a <= 1;
                            active_a <= 0;
                        end else begin
                            shift_reg_a <= mul1 << 1;
                        end
                    end
                endcase
            end else if (active) begin
                active_a <= active_b;

                case (shifter_op)
                    OP_LSL, OP_LSR : begin                    
                        if (cycle_count == mul2[3:0]) begin
                            result_a <= shift_reg;
                            counter_done_a <= 1;
                            active_a <= 0;
                        end else begin
                            cycle_count_a <= cycle_count + 1;
                            shift_reg_a <= shifter_op == OP_LSL ? shift_reg << 1 : shift_reg >> 1;
                        end
                    end

                    OP_MAC : begin
                        if (cycle_count < 4'b1111) begin // continue MAC till cycle_count = 15
                            if (shift_reg[0])
                                mac_accum_a <= mac_accum + mac_mcand;
                            else
                                mac_accum_a <= mac_accum;
                            mac_mcand_a <= mac_mcand << 1; // advance position
                            shift_reg_a <= shift_reg >> 1; // get next bit
                            cycle_count_a <= cycle_count + 1;
                        end else begin
                            result_a <= accum + mac_accum[15:0] - (shift_reg[0] ? mac_mcand[15:0] : 16'b0); // handles signed 2's comp 
                            counter_done_a <= 1;
                            active_a <= 0;
                        end
                    end

                    OP_CLZ : begin
                        if (shift_reg[15] || cycle_count == 4'b1111) begin // first '1' found or went through all bits
                            result_a <= {12'b0, cycle_count};
                            counter_done_a <= 1;
                            active_a <= 0;
                        end else begin
                            shift_reg_a <= shift_reg << 1;
                            cycle_count_a <= cycle_count + 1;
                        end
                    end

                    default : active_a <= 0;
                endcase
            end
        end
    end
    
    always @(posedge clk)
    begin
        if (rst) begin
            result_b <= 16'b0;
            counter_done_b <= 0;
            active_b <= 0;
            cycle_count_b <= 4'b0;
            shift_reg_b <= 16'b0;
            mac_accum_b <= 32'b0;
            mac_mcand_b <= 32'b0;
            pospos_clk <= 0;
        end else begin
            counter_done_b <= 0;
            pospos_clk <= ~pospos_clk;

            if (active) begin // if active, continue multi-cycle operation
                active_b <= active_a;

                case (shifter_op)
                    OP_LSL, OP_LSR : begin                    
                        if (cycle_count == mul2[3:0]) begin
                            result_b <= shift_reg;
                            counter_done_b <= 1;
                            active_b <= 0;
                        end else begin
                            cycle_count_b <= cycle_count + 1;
                            shift_reg_b <= shifter_op == OP_LSL ? shift_reg << 1 : shift_reg >> 1;
                        end
                    end

                    OP_MAC : begin
                        if (cycle_count < 4'b1111) begin // continue MAC till cycle_count = 15
                            if (shift_reg[0])
                                mac_accum_b <= mac_accum + mac_mcand;
                            else
                                mac_accum_b <= mac_accum;
                            mac_mcand_b <= mac_mcand << 1; // advance position
                            shift_reg_b <= shift_reg >> 1; // get next bit
                            cycle_count_b <= cycle_count + 1;
                        end else begin
                            result_b <= accum + mac_accum[15:0] - (shift_reg[0] ? mac_mcand[15:0] : 16'b0); // handles signed 2's comp 
                            counter_done_b <= 1;
                            active_b <= 0;
                        end
                    end

                    OP_CLZ : begin
                        if (shift_reg[15] || cycle_count == 4'b1111) begin // first '1' found or went through all bits
                            result_b <= {12'b0, cycle_count};
                            counter_done_b <= 1;
                            active_b <= 0;
                        end else begin
                            shift_reg_b <= shift_reg << 1;
                            cycle_count_b <= cycle_count + 1;
                        end
                    end

                    default : active_b <= 0;
                endcase
            end
        end
    end

endmodule