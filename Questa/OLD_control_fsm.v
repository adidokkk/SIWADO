module control_fsm(
    input  wire        clka,
    input  wire        clkb,
    input  wire        rst,
    input  wire        start,
    input  wire [3:0]  opcode,
    input  wire        zero_flag,
    input  wire        counter_done,

    output reg         pc_write,
    output reg         pc_src,
    output reg         reg_write,
    output reg  [2:0]  alu_op,
    output reg         alu_src,
    output reg         shifter_en,
    output reg  [1:0]  shifter_mode,
    output reg         counter_en,
    output reg         ir_load
);

// States
parameter IDLE       = 3'b000;
parameter FETCH      = 3'b001;
parameter DECODE     = 3'b010;
parameter EXEC       = 3'b011;
parameter SHIFT_LOOP = 3'b100;
parameter WRITEBACK  = 3'b101;


// Shifter Mode
parameter SHIFT_NONE = 2'b00;
parameter SHIFT_LS   = 2'b01;
parameter SHIFT_MAC  = 2'b10;
parameter SHIFT_CLZ  = 2'b11;


// Opcode Definitions
parameter OP_ADD  = 4'b0000;
parameter OP_SUB  = 4'b0001;
parameter OP_AND  = 4'b0010;
parameter OP_OR   = 4'b0011;
parameter OP_XOR  = 4'b0100;
parameter OP_ADDI = 4'b0101;
parameter OP_LUI  = 4'b0110;
parameter OP_BEQ  = 4'b0111;
parameter OP_BNE  = 4'b1000;
parameter OP_LSL  = 4'b1001;
parameter OP_LSR  = 4'b1010;
parameter OP_MAC  = 4'b1011;
parameter OP_CLZ  = 4'b1100;
parameter OP_HALT = 4'b1111;

// ALU operation constant
parameter ALU_ADD = 3'b000;
parameter ALU_SUB = 3'b001;
parameter ALU_AND = 3'b010;
parameter ALU_OR  = 3'b011;
parameter ALU_XOR = 3'b100;
parameter ALU_LUI = 3'b101;

//--------------------------------------------------
reg [2:0] state;
reg [2:0] next_state;
reg [2:0] temp_state;

// Next-State Logic
always @(*) begin
    case(state)

        IDLE:
            temp_state = (start) ? FETCH : IDLE;

        FETCH:
            temp_state = DECODE;

        DECODE: begin
            if (opcode == OP_HALT)
                temp_state = IDLE;

            else if (opcode == OP_LSL ||
                     opcode == OP_LSR ||
                     opcode == OP_MAC ||
                     opcode == OP_CLZ)
                temp_state = SHIFT_LOOP;

            else
                temp_state = EXEC;
        end

        EXEC: begin
            if (opcode == OP_BEQ || opcode == OP_BNE)
                temp_state = FETCH;
            else
                temp_state = WRITEBACK;
        end

        SHIFT_LOOP:
            temp_state = (counter_done) ? WRITEBACK : SHIFT_LOOP;

        WRITEBACK:
            temp_state = FETCH;

        default:
            temp_state = IDLE;
    endcase
end


always @(negedge clka) begin
    if (rst)
        next_state <= IDLE;
    else
        next_state <= temp_state;
end


always @(negedge clkb) begin
    if (rst) begin
        state        <= IDLE;
        pc_write     <= 0;
        pc_src       <= 0;
        reg_write    <= 0;
        alu_op       <= 0;
        shifter_en   <= 0;
        shifter_mode <= SHIFT_NONE;
        counter_en   <= 0;
        ir_load      <= 0;
        alu_src      <= 0;
    end
    else begin

        state <= next_state;

        pc_write     <= 0;
        pc_src       <= 0;
        reg_write    <= 0;
        shifter_en   <= 0;
        shifter_mode <= SHIFT_NONE;
        counter_en   <= 0;
        ir_load      <= 0;
        alu_src      <= 0;

        case(next_state)

            FETCH: begin
                pc_write <= 1;
                ir_load  <= 1;
            end

            EXEC: begin
                case(opcode)
            
                    // R-type
                    OP_ADD : begin
                        alu_op  <= ALU_ADD;
                        alu_src <= 0;
                    end
                    OP_SUB : begin
                        alu_op  <= ALU_SUB;
                        alu_src <= 0;
                    end
                    OP_AND : begin
                        alu_op  <= ALU_AND;
                        alu_src <= 0;
                    end
                    OP_OR : begin
                        alu_op  <= ALU_OR;
                        alu_src <= 0;
                    end
                    OP_XOR : begin
                        alu_op  <= ALU_XOR;
                        alu_src <= 0;
                    end
            
                    // I-type
                    OP_ADDI : begin
                        alu_op  <= ALU_ADD;
                        alu_src <= 1;
                    end
                    OP_LUI : begin
                        alu_op  <= ALU_LUI;
                        alu_src <= 1;
                    end
            
                    // Branch
                    OP_BEQ,
                    OP_BNE : begin
                        alu_op  <= ALU_SUB;
                        alu_src <= 0;
                    end
            
                endcase
            
            
                // Branch control
                if (opcode == OP_BEQ && zero_flag) begin
                    pc_src   <= 1;   
                    pc_write <= 1; 
                end
                else if (opcode == OP_BNE && !zero_flag) begin
                    pc_src   <= 1;
                    pc_write <= 1;
                end
            
            end

            SHIFT_LOOP: begin
                shifter_en <= 1;
                counter_en <= 1;

                if (opcode == OP_LSL || opcode == OP_LSR)
                    shifter_mode <= SHIFT_LS;

                else if (opcode == OP_MAC)
                    shifter_mode <= SHIFT_MAC;

                else if (opcode == OP_CLZ)
                    shifter_mode <= SHIFT_CLZ;
            end

            WRITEBACK: begin
                reg_write <= 1;
            end

        endcase
    end
end

endmodule
