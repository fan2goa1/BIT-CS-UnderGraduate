`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 21:45:12
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
        input wire clk,
        input wire rst,
        input wire[5:0] stall,
        
        input wire mem_we,
        input wire[4:0] mem_waddr,
        input wire[31:0] mem_wdata,
        
        output reg wb_we,
        output reg[4:0] wb_waddr,
        output reg[31:0] wb_wdata
    );
    
    always @(posedge clk) begin
        if (rst == `RstEnable || (stall[4] == `Stop && stall[5] == `NoStop)) begin
            wb_we <= `WriteDisable;
            wb_waddr <= 5'b0;
            wb_wdata <= `ZeroWord;
        end else if (stall[4] == `NoStop) begin
            wb_we <= mem_we;
            wb_waddr <= mem_waddr;
            wb_wdata <= mem_wdata;
        end
    end
endmodule
