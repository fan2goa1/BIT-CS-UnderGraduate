`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/28 23:43:08
// Design Name: 
// Module Name: PC
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


module PC(
        input clk,
        input [31:0] nxt_inst,
        output [31:0] now_inst
    );

    reg [31:0] getinst;

    initial begin
        getinst = 0;
    end

    always @(posedge clk) begin
        getinst = nxt_inst;
    end

    assign now_inst = getinst;
endmodule