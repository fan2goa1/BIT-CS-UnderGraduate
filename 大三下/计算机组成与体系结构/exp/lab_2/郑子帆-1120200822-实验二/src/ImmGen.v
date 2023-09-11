`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/29 05:44:43
// Design Name: 
// Module Name: ImmGen
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


module ImmGen(
        input [11:0] in,
        output reg [31:0] out
    );

    integer one = 32'hffffffff, zero = 32'h00000000;
    always @(*) begin
        if (in[11] == 1) begin
            out = one;
            out[11:0] = in;
        end
        else begin
            out = zero;
            out[11:0] = in;
        end
    end
endmodule

