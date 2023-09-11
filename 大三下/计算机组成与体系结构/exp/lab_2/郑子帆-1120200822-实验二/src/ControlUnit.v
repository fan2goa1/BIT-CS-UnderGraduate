`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/29 07:39:08
// Design Name: 
// Module Name: ControlUnit
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

`include "macro.vh"
module ControlUnit(
        input [6:0] opcode,
        input [2:0] funct3,
        input [6:0] funct7,
        output c1,
        output c2,
        output [1:0] c3,
        output [3:0] alu_op,
        output [2:0] branch,
        output dmem_we,
        output reg_we
    );

    wire [3:0] instr_id = get_instr_id(opcode, funct3, funct7);
    function [3:0] get_instr_id(input [6:0] opcode, input [2:0] funct3, input [6:0] funct7);
        begin
            case (opcode)
                `OPCODE_R: begin
                    case (funct3)
                        `FUNCT3_ADD: begin
                            case (funct7)
                                `FUNCT7_ADD: get_instr_id = `ID_ADD;
                                `FUNCT7_SUB: get_instr_id = `ID_SUB; 
                                default: get_instr_id = `ID_NULL;
                            endcase
                        end
                        default: get_instr_id = `ID_NULL;
                    endcase
                end 

                `OPCODE_I: begin
                    case (funct3)
                        `FUNCT3_ORI: get_instr_id = `ID_ORI;
                        `FUNCT3_ADDI: get_instr_id = `ID_ADDI;
                        default: get_instr_id = `ID_NULL;
                    endcase
                end

                `OPCODE_LW: begin
                    case (funct3)
                        `FUNCT3_LW: get_instr_id = `ID_LW;
                        default: get_instr_id = `ID_NULL;
                    endcase
                end

                `OPCODE_S: begin
                    case (funct3)
                        `FUNCT3_SW: get_instr_id = `ID_SW;
                        default: get_instr_id = `ID_NULL;
                    endcase
                end

                `OPCODE_B: begin
                    case (funct3)
                        `FUNCT3_BLT: get_instr_id = `ID_BLT;
                        `FUNCT3_BEQ: get_instr_id = `ID_BEQ;
                        `FUNCT3_BGE: get_instr_id = `ID_BGE;
                        `FUNCT3_BNE: get_instr_id = `ID_BNE;
                        default: get_instr_id = `ID_NULL;
                    endcase
                end

                `OPCODE_J: get_instr_id = `ID_JAL;
                default: get_instr_id = `ID_NULL;
            endcase
        end
        
    endfunction

    assign c1 = (instr_id == `ID_SW) ? 1:0;

    reg [11:0] mask_c2 = 12'b1111_1111_1001;
    assign c2 = mask_c2[instr_id];

    assign c3 = get_c3(instr_id);
    function [1:0] get_c3(input [3:0] instr_id);
        begin
            case (instr_id)
                `ID_ADD, `ID_ADDI, `ID_SUB, `ID_ORI: get_c3 = 2'b00;
                `ID_LW: get_c3 = 2'b01;
                `ID_JAL: get_c3 = 2'b10;
                default: get_c3 = 2'b00;
            endcase
        end
        
    endfunction

    assign alu_op = get_alu_op(instr_id);
    function [7:0] get_alu_op(input [3:0] instr_id);
        begin
            case (instr_id)
                `ID_ADD, `ID_ADDI, `ID_LW, `ID_SW: get_alu_op = `ALU_ADD;
                `ID_SUB: get_alu_op = `ALU_SUB;
                `ID_ORI: get_alu_op = `ALU_OR;
                default: get_alu_op = `ALU_NULL;
            endcase
        end
        
    endfunction

    assign branch = get_branch(instr_id);
    function [2:0] get_branch(input [3:0] instr_id);
        begin
            case (instr_id)     // 跳转指令类型
                `ID_BEQ: get_branch = `BR_BEQ;
                `ID_BGE: get_branch = `BR_BGE;
                `ID_BLT: get_branch = `BR_BLT;
                `ID_BNE: get_branch = `BR_BNE;
                `ID_JAL: get_branch = `BR_JAL;
                default: get_branch = `BR_NULL;
            endcase
        end
        
    endfunction

    assign dmem_we = (instr_id == `ID_SW) ? 1:0;

    reg [11:0] mask_reg_we = 12'b0101_0101_1110;
    assign reg_we = mask_reg_we[instr_id];
endmodule

