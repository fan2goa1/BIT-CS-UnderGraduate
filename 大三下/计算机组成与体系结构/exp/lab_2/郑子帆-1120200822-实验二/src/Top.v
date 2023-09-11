`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/30 04:49:08
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input clk,
    input rst
    );

    integer const_4 = 32'd4;        // ¼Ó4

    // PC
    wire [31:0] current_instr_addr, next_instr_addr;
    wire [31:0] instr;
    
    // RegFile 
    wire [4:0] rs1_addr, rs2_addr, rd_addr;
    wire [31:0] rs1_data, rs2_data, rd_data;
    
    // CU
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire c1, c2, dmem_we, reg_we;
    wire [3:0] alu_op;
    wire [1:0] c3;
    
    // BRU
    wire [31:0] act_offset, offset;
    wire jump;
    wire [19:0] jal_offset;
    wire [11:0] br_offset;
    wire [2:0] branch;
    
    // MUX1
    wire [11:0] imm_I, imm_S;
    wire [11:0] imm;
    
    // ALU
    wire [31:0] alu_opnd1, alu_opnd2, alu_res;
    wire SF, CF, ZF, OF, PF;
    
    // ImmGen
    wire [31:0] imm_expand;
    
    // jal
    wire [31:0] reg_jal;
    
    // Dmem
    wire [31:0] read_dmem_data;

    PC Pc(
        .clk(clk),
        .nxt_inst(next_instr_addr),
        .now_inst(current_instr_addr)
    );

    InstructionMemory Imem(
        .in_addr(current_instr_addr),
        .instruction(instr)
    );

    assign jal_offset = instr[31:12];
    assign br_offset = {instr[31:25], instr[11:7]};
    BrUnit BrU(
        .br_offset(br_offset),
        .jal_offset(jal_offset),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .branch(branch),
        .jump(jump),
        .offset(offset)
    );
    MUX2 MUX_BR(
        .src1(const_4),
        .src2(offset),
        .control(jump),
        .out(act_offset)
    );

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];
    ControlUnit CU(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .alu_op(alu_op),
        .branch(branch),
        .dmem_we(dmem_we),
        .reg_we(reg_we)
    );

    assign imm_I = instr[31:20];
    assign imm_S = {instr[31:25], instr[11:7]};
    MUX1 MUX_1(
        .src1(imm_I),
        .src2(imm_S),
        .control(c1),

        .out(imm)
    );

    ImmGen IG(
        .in(imm),
        .out(imm_expand)
    );

    assign alu_opnd1 = rs1_data;
    ALU Alu(
        .OP(alu_op),
        .A(alu_opnd1),
        .B(alu_opnd2),
        .F(alu_res),
        .ZF(ZF),
        .CF(CF),
        .OF(OF),
        .SF(SF),
        .PF(PF)
    );

    assign rs2_addr = instr[24:20];
    assign rs1_addr = instr[19:15];
    assign rd_addr = instr[11:7];
    RegFile RF(
        .clk(clk),
        .rst(rst),
        .reg_we(reg_we),
        .rs_addr(rs1_addr),
        .rt_addr(rs2_addr),
        .wb_addr(rd_addr),
        .wb_data(rd_data),

        .rs_data(rs1_data),
        .rt_data(rs2_data)
    );

    MUX2 MUX_2(
        .src1(rs2_data),
        .src2(imm_expand),
        .control(c2),
        .out(alu_opnd2)
    );
    
    Adder Add_J(
        .opnd1(current_instr_addr),
        .opnd2(act_offset),
        .res(next_instr_addr)
    );

    Adder Add_4(
        .opnd1(const_4),
        .opnd2(current_instr_addr),

        .res(reg_jal)
    );

    DataMemory Dmem(
        .clk(clk),
        .in_addr(alu_res),
        .we(dmem_we),
        .wdata(rs2_data),
        .rdata(read_dmem_data)
    );

    MUX3 MUX_3(
        .src1(alu_res),
        .src2(read_dmem_data),
        .src3(reg_jal),
        .control(c3),

        .out(rd_data)
    );

endmodule