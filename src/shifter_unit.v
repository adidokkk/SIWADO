// Shifter Unit
    // It handles MAC, CLZ, LSL, and LSR operations.

module shifter_unit (
    // External inputs
    input wire clka,
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
    reg [1:0] cur_op;
    reg [4:0] cycle_count;

    // MAC state
    reg [31:0] mac_accum;
    reg [31:0] mac_mcand; // sign-extended mul1 (shifted left)
    reg [15:0] mac_mult; // mul2 (shifted right)

    // CLZ state
    reg [15:0] clz_val;
    reg [4:0] clz_count;

    always @(posedge clka)
    begin
        if (rst) begin
            active <= 0;
            counter_done <= 0;
            result <= 16'b0;
            cur_op <= 2'b0;
            cycle_count <= 5'b0;
            mac_accum <= 32'b0;
            mac_mcand <= 32'b0;
            mac_mult <= 16'b0;
            clz_val <= 16'b0;
            clz_count <= 5'b0;
        end else begin
            counter_done <= 0;

            if (shifter_en && !active) begin // if not active, start multi-cycle operation
                cur_op <= shifter_op;
                cycle_count <= 5'b0;

                case (shifter_op)
                    OP_LSL : begin
                        result <= mul1 << mul2[3:0];
                        counter_done <= 1;
                    end

                    OP_LSR : begin
                        result <= mul1 >> mul2[3:0];
                        counter_done <= 1;
                    end

                    OP_MAC : begin
                        mac_accum <= 32'b0;
                        mac_mcand <= {{16{mul1[15]}}, mul1}; // sign-extended
                        mac_mult <= mul2;
                        active <= 1;
                    end

                    OP_CLZ : begin
                        clz_val <= mul1;
                        clz_count <= 5'b0;
                        active <= 1;
                    end
                endcase
            end else if (active) begin // if active, continue multi-cycle operation
                case (cur_op)
                    OP_MAC : begin
                        if (cycle_count < 5'b10000) begin // continue MAC till cycle_count = 16
                            if (mac_mult[0])
                                mac_accum <= mac_accum + mac_mcand;
                            mac_mcand <= mac_mcand << 1; // advance position
                            mac_mult <= mac_mult >> 1; // get next bit
                            cycle_count <= cycle_count + 1;
                        end else begin
                            result <= accum + mac_accum[15:0];
                            counter_done <= 1;
                            active <= 0;
                        end
                    end

                    OP_CLZ : begin
                        if (clz_val[15] || clz_count == 5'b10000) begin // first '1' found or went through all bits
                            result <= {11'b0, clz_count};
                            counter_done <= 1;
                            active <= 0;
                        end else begin
                            clz_val <= clz_val << 1;
                            clz_count <= clz_count + 1;
                        end
                    end

                    default : active <= 0;
                endcase
            end
        end
    end

endmodule