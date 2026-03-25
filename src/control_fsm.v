// Finite State Machine (FSM)
    // It regulates the CPU stages and their outputs, given the inputs.

module control_fsm (
    // External inputs
    input wire clka,
    input wire clkb,
    input wire rst,

    // Internal inputs from datapath
    input wire [3:0] opcode,
    input wire zero_flag, // Rs1 - Rs2 == 0
    input wire counter_done, // 1 = 16 cycles completed
    input wire mmio_addr, // 1 = 0xFC00 (SW), 0 = 0xFC02 (LW)

    // Internal outputs to datapath
    output reg pc_write, // 1 = update PC, 0 = hold
    output reg pc_src, // 0 = PC++, 1 = branch target
    output reg ir_load, // 1 = load instruction, 0 = hold
    output reg reg_write, // 1 = write register file, 0 = hold
    output reg [3:0] alu_op,
    output reg alu_src, // 0 = register, 1 = immediate
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg, // 0 = ALU result, 1 = memory data
    output reg shifter_en,
    output reg counter_en,
    output reg [1:0] shifter_op,

    // External outputs
    output reg out_port_en, // latch enable for 16 output pads
    output reg error_flag // 1 = invalid state or opcode
);

    // Opcodes (16 total)
    parameter OP_ADD = 4'b0000;
    parameter OP_SUB = 4'b0001;
    parameter OP_AND = 4'b0010;
    parameter OP_OR = 4'b0011;
    parameter OP_XOR = 4'b0100;
    parameter OP_LSL = 4'b0101;
    parameter OP_LSR = 4'b0110;
    parameter OP_MAC = 4'b0111;
    parameter OP_CLZ = 4'b1000;
    parameter OP_BEQ = 4'b1001;
    parameter OP_BNE = 4'b1010;
    parameter OP_LUI = 4'b1011;
    parameter OP_ADDI = 4'b1100;
    parameter OP_LW = 4'b1101;
    parameter OP_SW = 4'b1110;
    parameter OP_HALT = 4'b1111;

    // Shifter operations (4 total)
    parameter SHIFT_LSL = 2'b00;
    parameter SHIFT_LSR = 2'b01;
    parameter SHIFT_MAC = 2'b10;
    parameter SHIFT_CLZ = 2'b11;

    // States (9 total)
    parameter RESET = 4'b0000; // 0
    parameter FETCH = 4'b0001; // 1
    parameter DECODE = 4'b0010; // 2
    parameter EXECUTE = 4'b0011; // 3
    parameter BRANCH = 4'b0100; // 4
    parameter MEMORY = 4'b0101; // 5
    parameter SHIFT_LOOP = 4'b0110; // 6
    parameter WRITEBACK = 4'b0111; // 7
    parameter HALT = 4'b1000; // 8

    reg [3:0] state;
    reg [3:0] next_state;

    always @(*)
    begin : TRANSITION
        if (rst)
            next_state = RESET;
        else begin
            case (state)
                RESET : next_state = FETCH;

                FETCH : next_state = DECODE;

                DECODE : begin
                    case (opcode)
                        OP_HALT : next_state = HALT;
                        OP_LSL, OP_LSR, OP_MAC, OP_CLZ : next_state = SHIFT_LOOP;

                        default : next_state = EXECUTE;
                    endcase
                end

                EXECUTE : begin
                    case (opcode)
                        OP_BEQ, OP_BNE : next_state = BRANCH;
                        OP_LW, OP_SW : next_state = MEMORY;
                        default : next_state = WRITEBACK;
                    endcase
                end

                BRANCH : next_state = FETCH;

                MEMORY : next_state = (opcode == OP_SW) ? FETCH : WRITEBACK;

                SHIFT_LOOP : next_state = counter_done ? WRITEBACK : SHIFT_LOOP;

                WRITEBACK : next_state = FETCH;

                HALT : next_state = HALT;

                default : next_state = RESET;
            endcase
        end
    end

    always @(negedge clka) 
    begin : SYNC
        if (rst)
            state <= RESET;
        else
            state <= next_state;
    end

    always @(negedge clkb) 
    begin : OUTPUT
        pc_write <= 0;
        pc_src <= 0;
        ir_load <= 0;
        reg_write <= 0;
        alu_op <= 4'b0000; // default to ADD
        alu_src <= 0;
        mem_read <= 0;
        mem_write <= 0;
        mem_to_reg <= 0;
        shifter_en <= 0;
        counter_en <= 0;
        shifter_op <= 2'b00; // default to LSL
        out_port_en <= 0;
        error_flag <= 0;
        
        case (state)
            RESET, HALT, DECODE : begin
                // Nothing happens
            end

            FETCH : begin
                pc_write <= 1;
                pc_src <= 0; // PC++
                ir_load <= 1;
            end

            EXECUTE : begin
                case (opcode)
                    OP_ADD, OP_SUB, OP_AND, OP_OR, OP_XOR : begin 
                        alu_op <= opcode;  
                        alu_src <= 0; 
                    end

                    OP_ADDI : begin 
                        alu_op <= OP_ADD;  
                        alu_src <= 1; 
                    end

                    OP_LUI : begin 
                        alu_op <= OP_LUI;  
                        alu_src <= 1; 
                    end

                    OP_LW, OP_SW : begin 
                        alu_op <= OP_ADD;  
                        alu_src <= 1; 
                    end

                    OP_BEQ, OP_BNE : begin
                        alu_op <= OP_SUB;
                        alu_src <= 0;
                    end

                    default : error_flag <= 1; // should never happen
                endcase
            end

            BRANCH : begin
                pc_write <= 1;
                case (opcode)
                    OP_BEQ: pc_src <= zero_flag;
                    OP_BNE: pc_src <= ~zero_flag;

                    default: error_flag <= 1; // should never happen
                endcase
            end

            MEMORY : begin
                if (opcode == OP_LW)
                    mem_read <= 1;
                else begin
                    mem_write <= 1;
                    out_port_en <= mmio_addr;
                end
            end

            SHIFT_LOOP : begin
                shifter_en <= 1;
                counter_en <= 1;
                case (opcode)
                    OP_LSL : shifter_op <= SHIFT_LSL;
                    OP_LSR : shifter_op <= SHIFT_LSR;
                    OP_MAC : shifter_op <= SHIFT_MAC;
                    OP_CLZ : shifter_op <= SHIFT_CLZ;

                    default : error_flag <= 1; // should never happen
                endcase
            end

            WRITEBACK: begin
                reg_write  <= 1;
                mem_to_reg <= (opcode == OP_LW);
            end

            default : error_flag <= 1; // should never happen
        endcase
    end
endmodule