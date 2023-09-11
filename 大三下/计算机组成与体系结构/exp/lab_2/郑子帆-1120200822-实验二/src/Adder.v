`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/29 19:18:44
// Design Name: 
// Module Name: Adder
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


module Adder(
        input [31:0] opnd1,
        input [31:0] opnd2,
        output [31:0] res
    );

    reg [31:0] out;

    always @(*) begin
        out = opnd1 + opnd2;
    end

    assign res = out;
endmodule

