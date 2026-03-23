module control_fsm (
    input wire clka,
    input wire clkb,
    input wire rst,

    input wire [3:0] opcode,
    input wire zero_flag,
    input wire counter_done,
    input wire mmio_addr,

    output reg pc_write,
    output reg pc_src,  // 0 = PC++, 1 = branch target
    output reg ir_load,
    output reg reg_write,
    output reg [3:0] alu_op,
    output reg alu_src,
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg,
    output reg shifter_en,
    output reg counter_en,
    output reg [1:0] shifter_op,
    output reg out_port_en
);

    // ===== OPCODES =====
    parameter OP_ADD  = 4'b0000;
    parameter OP_SUB  = 4'b0001;
    parameter OP_AND  = 4'b0010;
    parameter OP_OR   = 4'b0011;
    parameter OP_XOR  = 4'b0100;
    parameter OP_LSL  = 4'b0101;
    parameter OP_LSR  = 4'b0110;
    parameter OP_MAC  = 4'b0111;
    parameter OP_CLZ  = 4'b1000;
    parameter OP_BEQ  = 4'b1001;  // Branch if Equal
    parameter OP_BNE  = 4'b1010;  // Branch if Not Equal
    parameter OP_LUI  = 4'b1011;
    parameter OP_ADDI = 4'b1100;
    parameter OP_LW   = 4'b1101;
    parameter OP_SW   = 4'b1110;
    parameter OP_HALT = 4'b1111;

    // ===== SHIFT OPS =====
    parameter SHIFT_LSL = 2'b00;
    parameter SHIFT_LSR = 2'b01;
    parameter SHIFT_MAC = 2'b10;
    parameter SHIFT_CLZ = 2'b11;

    // ===== STATES =====
    parameter RESET      = 3'b000;
    parameter FETCH      = 3'b001;
    parameter DECODE     = 3'b010;
    parameter EXECUTE    = 3'b011;
    parameter MEMORY     = 3'b100;
    parameter SHIFT_LOOP = 3'b101;
    parameter WRITEBACK  = 3'b110;
    parameter HALT       = 3'b111;

    reg [2:0] state;
    reg [2:0] next_state;

    reg branch_taken;

    // =========================
    // NEXT STATE LOGIC
    // =========================
    always @(*) begin
        if (rst)
            next_state = RESET;
        else begin
            case (state)
                RESET: next_state = FETCH;

                FETCH: next_state = DECODE;

                DECODE: begin
                    case (opcode)
                        OP_HALT:
                            next_state = HALT;
                        OP_LSL, OP_LSR, OP_MAC, OP_CLZ:
                            next_state = SHIFT_LOOP;
                        default:
                            next_state = EXECUTE;
                    endcase
                end

                EXECUTE: begin
                    case (opcode)
                        OP_BEQ, OP_BNE:
                            next_state = FETCH;
                        OP_LW, OP_SW:
                            next_state = MEMORY;
                        default:
                            next_state = WRITEBACK;
                    endcase
                end

                MEMORY:
                    next_state = (opcode == OP_SW) ? FETCH : WRITEBACK;

                SHIFT_LOOP:
                    next_state = counter_done ? WRITEBACK : SHIFT_LOOP;

                WRITEBACK:
                    next_state = FETCH;

                HALT:
                    next_state = HALT;

                default:
                    next_state = RESET;
            endcase
        end
    end

    // =========================
    // STATE REGISTER (clka)
    // =========================
    always @(negedge clka) begin
        if (rst)
            state <= RESET;
        else
            state <= next_state;
    end

    // =========================
    // OUTPUT LOGIC (clkb)
    // =========================
    always @(negedge clkb) begin
        // default signals
        pc_write   <= 0;
        pc_src     <= 0;
        ir_load    <= 0;
        reg_write  <= 0;
        alu_op     <= 4'b0000;
        alu_src    <= 0;
        mem_read   <= 0;
        mem_write  <= 0;
        mem_to_reg <= 0;
        shifter_en <= 0;
        counter_en <= 0;
        shifter_op <= 2'b00;
        out_port_en <= 0;

        case (state)
        
            RESET, HALT, DECODE: begin
                // Nothing happens
            end

            // =================
            FETCH: begin
                pc_write <= 1;
                pc_src   <= branch_taken;
                ir_load  <= 1;
            end

            // =================
            EXECUTE: begin
                case (opcode)
                    OP_ADD, OP_SUB, OP_AND, OP_OR, OP_XOR: begin
                        alu_op  <= opcode;
                        alu_src <= 0;
                    end

                    OP_ADDI: begin
                        alu_op  <= OP_ADDI;
                        alu_src <= 1;
                    end

                    OP_LUI: begin
                        alu_op  <= OP_LUI;
                        alu_src <= 1;
                    end

                    OP_LW, OP_SW: begin
                        alu_op  <= OP_ADD;
                        alu_src <= 1;
                    end

                    OP_BEQ, OP_BNE: begin
                        alu_op  <= OP_SUB;
                        alu_src <= 0;
                    end
                endcase
            end

            // =================
            MEMORY: begin
                if (opcode == OP_LW)
                    mem_read <= 1;
                else begin
                    mem_write <= 1;
                    out_port_en <= mmio_addr;
                end
            end

            // =================
            SHIFT_LOOP: begin
                shifter_en <= 1;
                counter_en <= 1;

                case (opcode)
                    OP_LSL: shifter_op <= SHIFT_LSL;
                    OP_LSR: shifter_op <= SHIFT_LSR;
                    OP_MAC: shifter_op <= SHIFT_MAC;
                    OP_CLZ: shifter_op <= SHIFT_CLZ;
                endcase
            end

            // =================
            WRITEBACK: begin
                reg_write  <= 1;
                mem_to_reg <= (opcode == OP_LW);
            end

            HALT: begin
                // hold
            end
        endcase
    end

    // =========================
    // BRANCH LOGIC
    // =========================
    always @(negedge clkb) begin
        if (rst)
            pc_src <= 0;
        else if (state == EXECUTE) begin
            case (opcode)
                OP_BEQ: pc_src <= zero_flag;
                OP_BNE: pc_src <= ~zero_flag;
                default: pc_src <= 0;
            endcase
        end else begin
            pc_src <= 0;
        end
    end

endmodule
