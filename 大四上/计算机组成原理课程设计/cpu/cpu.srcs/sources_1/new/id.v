`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 17:01:10
// Design Name: 
// Module Name: id
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


module id(
        input wire rst,
        input wire[31:0] pc_i,
        input wire[31:0] inst_i,
        
        input wire[31:0] reg1_data_i,
        input wire[31:0] reg2_data_i,
        
        output reg reg1_re_o,
        output reg reg2_re_o,
        output reg[4:0] reg1_addr_o,
        output reg[4:0] reg2_addr_o,

        output reg[2:0] inst_type_o,
        output reg[2:0] inst_op_o,
        output reg[3:0] alu_op_o,
        output reg reg_we_o,
        output reg[4:0] reg_waddr_o,
        
        output reg stall_req,
        
        output reg branch_tag,
        output reg[31:0] branch_address,
        
        output reg[31:0] reg1_o,
        output reg[31:0] reg2_o,
        output reg[31:0] reg3_o
    );
    
    wire[5:0] opcode = inst_i[31:26];
    wire[4:0] rs = inst_i[25:21];
    wire[4:0] rt = inst_i[20:16];
    wire[4:0] rd = inst_i[15:11];
    wire[5:0] func = inst_i[5:0];
    wire[15:0] imm = inst_i[15:0];
    wire[31:0] shamt = {27'h0, inst_i[10:6]};
    wire[31:0] zimm = {16'h0,imm};
    wire[31:0] simm = {{(16){imm[15]}}, imm};
    wire[31:0] fimm = {imm, 16'h0};
    wire[25:0] inst_index = inst_i[25:0];
    wire[31:0] pc_plus_4 = pc_i + 4;
    wire[31:0] pc_plus_8 = pc_i + 8;
    
    reg[31:0] imm_val;
    
    always @(*) begin
        if (rst == `RstEnable) begin
            reg1_re_o = `ReadDisable;
            reg2_re_o = `ReadDisable;
            reg1_addr_o = 5'b0;
            reg2_addr_o = 5'b0;
            
            inst_type_o <= `inst_type_nop;
            inst_op_o <= `calc_nop;
            alu_op_o <= `alu_nop;
            reg_we_o <= `WriteDisable;
            reg_waddr_o <= 5'b0;
            
            stall_req <= `NoStop;
            
            branch_tag <= `NoBranch;
            branch_address <= `ZeroWord;
        end else begin
            stall_req <= `NoStop;
            branch_tag <= `NoBranch;
            branch_address <= `ZeroWord;
            inst_type_o <= `inst_type_nop;
            inst_op_o <= `calc_nop;
            alu_op_o <= `alu_nop;
            reg1_re_o <= `ReadDisable;
            reg2_re_o <= `ReadDisable;
            reg_we_o <= `WriteDisable;
            imm_val <= `ZeroWord;
            reg1_addr_o <= 5'b0;
            reg2_addr_o <= 5'b0;
            reg_waddr_o <= 5'b0;
            case (opcode)
                `OPCODE_SPECIAL:begin
                    case (func)
                        `FUNC_ADD:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_sadd;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rs;
                            reg2_re_o <= `ReadEnable;
                            reg2_addr_o <= rt;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                        end
                        `FUNC_ADDU: begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_uadd;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rs;
                            reg2_re_o <= `ReadEnable;
                            reg2_addr_o <= rt;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                        end
                        `FUNC_SUB:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_ssub;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rs;
                            reg2_re_o <= `ReadEnable;
                            reg2_addr_o <= rt;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                        end
                        `FUNC_SUBU:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_usub;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rs;
                            reg2_re_o <= `ReadEnable;
                            reg2_addr_o <= rt;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                        end
                        `FUNC_AND:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_and;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rs;
                            reg2_re_o <= `ReadEnable;
                            reg2_addr_o <= rt;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                        end
                        `FUNC_OR:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_or;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rs;
                            reg2_re_o <= `ReadEnable;
                            reg2_addr_o <= rt;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                        end
                        `FUNC_XOR:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_xor;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rs;
                            reg2_re_o <= `ReadEnable;
                            reg2_addr_o <= rt;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                        end
                        `FUNC_SLT:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_slt;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rs;
                            reg2_re_o <= `ReadEnable;
                            reg2_addr_o <= rt;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                        end
                        `FUNC_SLTU:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_ult;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rs;
                            reg2_re_o <= `ReadEnable;
                            reg2_addr_o <= rt;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                        end
                        `FUNC_SLL:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_shl;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rt;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                            imm_val <= shamt;
                        end
                        `FUNC_SRL:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_ushr;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rt;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                            imm_val <= shamt;
                        end
                        `FUNC_SRA:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_shr;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rt;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                            imm_val <= shamt;
                        end
                        `FUNC_SLLV:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_shl;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rt;
                            reg2_re_o <= `ReadEnable;
                            reg2_addr_o <= rs;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                        end
                        `FUNC_SRLV:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_ushr;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rt;
                            reg2_re_o <= `ReadEnable;
                            reg2_addr_o <= rs;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                        end
                        `FUNC_SRAV:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_shr;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rt;
                            reg2_re_o <= `ReadEnable;
                            reg2_addr_o <= rs;
                            reg_we_o <= `WriteEnable;
                            reg_waddr_o <= rd;
                        end
                        `FUNC_JR:  begin
                            inst_type_o <= `inst_type_calc;
                            inst_op_o <= `calc_alu;
                            alu_op_o <= `alu_shr;
                            reg1_re_o <= `ReadEnable;
                            reg1_addr_o <= rs;
                            branch_tag <= `Branch;
                            branch_address <= reg1_data_i;
                            stall_req <= `Stop;
                        end
                        default:    begin
                        end
                    endcase
                end
                `OPCODE_J:      begin
                    branch_tag <= `Branch;
                    branch_address <= {pc_plus_4[31:28], inst_index, 2'b00};
                    stall_req <= `Stop;
                end
                `OPCODE_JAL:      begin
                    inst_type_o <= `inst_type_calc;
                    inst_op_o <= `calc_alu;
                    alu_op_o <= `alu_sadd;
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= 5'b0;
                    imm_val <= pc_plus_4;
                    branch_tag <= `Branch;
                    branch_address <= {pc_plus_4[31:28], inst_index, 2'b00};
                    stall_req <= `Stop;
                end
                `OPCODE_BEQ:    begin
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg2_re_o <= `ReadEnable;
                    reg2_addr_o <= rt;
                    if (reg1_data_i == reg2_data_i) begin
                        branch_tag <= `Branch;
                        branch_address <= pc_plus_4 + {simm[29:0], 2'b00};
                        stall_req <= `Stop;
                    end
                end
                `OPCODE_BNE:    begin
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg2_re_o <= `ReadEnable;
                    reg2_addr_o <= rt;
                    if (reg1_data_i != reg2_data_i) begin
                        branch_tag <= `Branch;
                        branch_address <= pc_plus_4 + {simm[29:0], 2'b00};
                        stall_req <= `Stop;
                    end
                end
                `OPCODE_LW:     begin
                    inst_type_o <= `inst_type_mem;
                    inst_op_o <= `mem_lw;
                    alu_op_o <= `alu_sadd;
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg_waddr_o <= rt;
                    imm_val <= simm;
                    stall_req <= `Stop;
                end
                `OPCODE_SW:     begin
                    inst_type_o <= `inst_type_mem;
                    inst_op_o <= `mem_sw;
                    alu_op_o <= `alu_sadd;
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg2_re_o <= `ReadEnable;
                    reg2_addr_o <= rt;
                    imm_val <= simm;
                end
                `OPCODE_ORI:    begin
                    inst_type_o <= `inst_type_calc;
                    inst_op_o <= `calc_alu;
                    alu_op_o <= `alu_or;
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg_we_o <= `WriteEnable;
                    reg_waddr_o <= rt;
                    imm_val <= zimm;
                end
                `OPCODE_ADDI:  begin
                    inst_type_o <= `inst_type_calc;
                    inst_op_o <= `calc_alu;
                    alu_op_o <= `alu_sadd;
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg_we_o <= `WriteEnable;
                    reg_waddr_o <= rt;
                    imm_val <= simm;
                end
                `OPCODE_ADDIU:  begin
                    inst_type_o <= `inst_type_calc;
                    inst_op_o <= `calc_alu;
                    alu_op_o <= `alu_uadd;
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg_we_o <= `WriteEnable;
                    reg_waddr_o <= rt;
                    imm_val <= zimm;
                end
                `OPCODE_LUI:    begin
                    inst_type_o <= `inst_type_calc;
                    inst_op_o <= `calc_alu;
                    alu_op_o <= `alu_or;
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg_we_o <= `WriteEnable;
                    reg_waddr_o <= rt;
                    imm_val <= fimm;
                end
                `OPCODE_ANDI:    begin
                    inst_type_o <= `inst_type_calc;
                    inst_op_o <= `calc_alu;
                    alu_op_o <= `alu_and;
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg_we_o <= `WriteEnable;
                    reg_waddr_o <= rt;
                    imm_val <= zimm;
                end
                `OPCODE_ORI:    begin
                    inst_type_o <= `inst_type_calc;
                    inst_op_o <= `calc_alu;
                    alu_op_o <= `alu_or;
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg_we_o <= `WriteEnable;
                    reg_waddr_o <= rt;
                    imm_val <= zimm;
                end
                `OPCODE_XORI:    begin
                    inst_type_o <= `inst_type_calc;
                    inst_op_o <= `calc_alu;
                    alu_op_o <= `alu_xor;
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg_we_o <= `WriteEnable;
                    reg_waddr_o <= rt;
                    imm_val <= zimm;
                end
                `OPCODE_SLTI:    begin
                    inst_type_o <= `inst_type_calc;
                    inst_op_o <= `calc_alu;
                    alu_op_o <= `alu_slt;
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg_we_o <= `WriteEnable;
                    reg_waddr_o <= rt;
                    imm_val <= simm;
                end
                `OPCODE_SLTIU:    begin
                    inst_type_o <= `inst_type_calc;
                    inst_op_o <= `calc_alu;
                    alu_op_o <= `alu_ult;
                    reg1_re_o <= `ReadEnable;
                    reg1_addr_o <= rs;
                    reg_we_o <= `WriteEnable;
                    reg_waddr_o <= rt;
                    imm_val <= zimm;
                end
                default:        begin
                end
            endcase
        end
    end
    
    always @(*) begin
        reg1_o <= (rst == `RstEnable) ? `ZeroWord : 
                        (reg1_re_o == `ReadEnable) ? reg1_data_i : imm_val;
        reg2_o <= (rst == `RstEnable) ? `ZeroWord :
                        (reg2_re_o == `ReadEnable && opcode != `OPCODE_SW) ? reg2_data_i : imm_val;
        reg3_o <= (rst != `RstEnable && opcode == `OPCODE_SW) ? reg2_data_i : `ZeroWord;
    end

endmodule