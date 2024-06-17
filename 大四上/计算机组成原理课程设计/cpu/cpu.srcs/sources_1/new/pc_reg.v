`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 16:21:45
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(
        input wire clk,
        input wire rst,
        input wire[5:0] stall,
        input wire branch_tag,
        input wire[31:0] branch_address,
        output reg[31:0] pc,
        output reg ce
    );
    
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            ce <= `ChipDisable;
        end else begin
            ce <= `ChipEnable;
        end
    end
    always @(posedge clk) begin
        if (ce == `ChipDisable) begin
            pc <= `ZeroWord;
        end else if (branch_tag == `Branch) begin
            pc <= branch_address;
        end else if (stall[0] == `NoStop) begin
            pc <= pc + 4'h4;
        end
    end
endmodule
