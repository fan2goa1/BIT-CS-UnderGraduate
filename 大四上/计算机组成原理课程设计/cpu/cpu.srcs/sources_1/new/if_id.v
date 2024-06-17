`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 16:26:57
// Design Name: 
// Module Name: if_id
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


module if_id(
        input wire clk,
        input wire rst,
        input wire[5:0] stall,
        
        input wire[31:0] if_pc,
        input wire[31:0] if_inst,
        
        output reg[31:0] id_pc,
        output reg[31:0] id_inst
    );
    
    always @(posedge clk) begin
        if (rst == `RstEnable || (stall[1] == `Stop && stall[2] == `NoStop)) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end else if (stall[1] == `NoStop) begin
            id_pc <= if_pc;
            id_inst <= if_inst;
        end
    end
endmodule
