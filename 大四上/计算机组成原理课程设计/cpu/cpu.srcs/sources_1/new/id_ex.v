`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 19:06:18
// Design Name: 
// Module Name: id_ex
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


module id_ex(
        input wire clk,
        input wire rst,
        input wire[5:0] stall,
        
        input wire[2:0] inst_type_id,
        input wire[2:0] inst_op_id,
        input wire[3:0] alu_op_id,
        input wire[31:0] reg1_id,
        input wire[31:0] reg2_id,
        input wire[31:0] reg3_id,
        input wire reg_we_id,
        input wire[4:0] reg_waddr_id,
        
        output reg[2:0] inst_type_ex,
        output reg[2:0] inst_op_ex,
        output reg[3:0] alu_op_ex,
        output reg[31:0] reg1_ex,
        output reg[31:0] reg2_ex,
        output reg[31:0] reg3_ex,
        output reg reg_we_ex,
        output reg[4:0] reg_waddr_ex
    );
    
    always @(posedge clk) begin
        if (rst == `RstEnable || (stall[2] == `Stop && stall[3] == `NoStop)) begin
            inst_type_ex <= `inst_type_nop;
            inst_op_ex <= `calc_nop;
            alu_op_ex <= `alu_nop;
            reg1_ex <= `ZeroWord;
            reg2_ex <= `ZeroWord;
            reg3_ex <= `ZeroWord;
            reg_we_ex <= `WriteDisable;
            reg_waddr_ex <= 5'b00000;
        end else if (stall[2] == `NoStop) begin
            inst_type_ex <= inst_type_id;
            inst_op_ex <= inst_op_id;
            alu_op_ex <= alu_op_id;
            reg1_ex <= reg1_id;
            reg2_ex <= reg2_id;
            reg3_ex <= reg3_id;
            reg_we_ex <= reg_we_id;
            reg_waddr_ex <= reg_waddr_id;
        end
    end
endmodule
