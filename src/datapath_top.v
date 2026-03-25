module datapath_top (
    // External inputs
        input wire clka,
        input wire clkb,
        input wire rst,
        input wire [15:0] in_port, // input from MMIO

    // Internal inputs from FSM
        input wire pc_write, // 1 = update PC, 0 = hold
        input wire pc_src, // 0 = PC++, 1 = branch target
        input wire ir_load, // 1 = load instruction, 0 = hold
        input wire reg_write, // 1 = write register file, 0 = hold
        input wire [3:0] alu_op,
        input wire alu_src, // 0 = register, 1 = immediate
        input wire mem_read,
        input wire mem_write,
        input wire mem_to_reg, // 0 = ALU/shifter result, 1 = memory data
        input wire shifter_en,
        input wire counter_en,
        input wire [1:0] shifter_op,
        input wire out_port_en, // latch enable for 16 output pads

    // Internal outputs to FSM
        output wire [3:0] opcode,
        output wire zero_flag, // Rs1 - Rs2 == 0
        output wire counter_done, // 1 = 16 cycles completed
        output wire mmio_addr, // 1 = 0xFC00 (SW)

    // External outputs
        output wire [15:0] out_port // output to MMIO (16 output pads)
    );

    // Shifter opcodes
    parameter OP_LSL = 4'b0101;
    parameter OP_LSR = 4'b0110;
    parameter OP_MAC = 4'b0111;
    parameter OP_CLZ = 4'b1000;
    parameter OP_LW = 4'b1101;

    // Internal signals
    wire [15:0] pc_out;
    wire [15:0] instr;
    wire [2:0] rd, rs1, rs2;
    wire [15:0] write_data;
    wire [15:0] add1, add2;
    wire [15:0] rd_data;
    wire [15:0] alu_result;
    wire [15:0] alu_in2;
    wire [5:0] imm_raw;
    wire [15:0] imm;
    wire [15:0] branch_target;
    wire [15:0] mem_rdata;
    wire [15:0] shifter_result;
    wire shifter_done;
    wire is_shift;
    
    assign zero_flag = (alu_result == 16'b0);
    assign branch_target = pc_out + imm;
    assign mmio_addr = (alu_result == 16'hFC00);
    assign counter_done = shifter_done;
    assign alu_in2 = alu_src ? imm : add2;
    assign is_shift = (opcode == OP_LSL) || (opcode == OP_LSR) ||
                      (opcode == OP_MAC) || (opcode == OP_CLZ);
    assign write_data = mem_to_reg ? mem_rdata : is_shift ? 
                        shifter_result : alu_result;

    // Program Counter (PC)
    pc pc_inst (
            .clkb(clkb),
            .rst(rst),
            .pc_write(pc_write),
            .pc_src(pc_src),
            .branch_target(branch_target),
            .pc_out(pc_out)
        );

    // Instruction Memory
    ins_mem ins_mem_inst (
            .addr(pc_out[3:0]),
            .instr(instr)
        );

    // Instruction Register (IR)
    ir ir_inst (
            .clkb(clkb),
            .rst(rst),
            .ir_load(ir_load),
            .instr_in(instr),
            .opcode(opcode),
            .rd(rd),
            .rs1(rs1),
            .rs2(rs2),
            .imm_raw(imm_raw)
        );

    // Immediate Generator
    imm_gen imm_gen_inst (
            .opcode(opcode),
            .imm_raw(imm_raw),
            .imm(imm)
        );

    // Register File
    regfile regfile_inst (
            .clkb(clkb),
            .rst(rst),
            .rs1(rs1),
            .rs2(rs2),
            .rd(rd),
            .reg_write(reg_write),
            .write_data(write_data),
            .add1(add1),
            .add2(add2),
            .rd_data(rd_data)
        );

    // ALU
    alu alu_inst (
            .add1(add1),
            .add2(alu_in2),
            .alu_op(alu_op),
            .result(alu_result)
        );

    // Shifter Unit
    shifter_unit shifter_inst (
            .clkb(clkb),
            .rst(rst),
            .shifter_en(shifter_en),
            .shifter_op(shifter_op),
            .mul1(add1),
            .mul2(add2),
            .accum(rd_data),
            .result(shifter_result),
            .counter_done(shifter_done)
        );

    // Data Memory
    data_mem data_mem_inst (
            .clkb(clkb),
            .rst(rst),
            .mem_read(mem_read),
            .mem_write(mem_write),
            .addr(alu_result),
            .write_data(add2),
            .in_port(in_port),
            .out_port_en(out_port_en),
            .read_data(mem_rdata),
            .out_port(out_port)
    );

endmodule