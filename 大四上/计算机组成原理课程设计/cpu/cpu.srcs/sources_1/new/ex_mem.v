`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 21:35:58
// Design Name: 
// Module Name: ex_mem
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


module ex_mem(
        input wire clk,
        input wire rst,
        input wire[5:0] stall,
        
        input wire ex_reg_we,
        input wire[4:0] ex_reg_waddr,
        input wire[31:0] ex_reg_wdata,
        input wire[2:0] ex_mem_op,
        input wire[31:0] ex_mem_addr,
        input wire[31:0] ex_mem_data,
        
        output reg mem_reg_we,
        output reg[4:0] mem_reg_waddr,
        output reg[31:0] mem_reg_wdata,
        output reg[2:0] mem_op,
        output reg[31:0] mem_addr,
        output reg[31:0] mem_data
    );
    
    always @(posedge clk) begin
        if (rst == `RstEnable || (stall[3] == `Stop && stall[4] == `NoStop)) begin
            mem_reg_we <= `WriteDisable;
            mem_reg_waddr <= 5'b00000;
            mem_reg_wdata <= `ZeroWord;
            mem_op <= `mem_nop;
            mem_addr <= `ZeroWord;
            mem_data <= `ZeroWord;
        end else if (stall[3] == `NoStop) begin
            mem_reg_we <= ex_reg_we;
            mem_reg_waddr <= ex_reg_waddr;
            mem_reg_wdata <= ex_reg_wdata;
            mem_op <= ex_mem_op;
            mem_addr <= ex_mem_addr;
            mem_data <= ex_mem_data;
        end
    end
endmodule
