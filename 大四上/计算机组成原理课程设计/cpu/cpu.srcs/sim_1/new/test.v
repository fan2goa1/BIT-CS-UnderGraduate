`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/04 19:00:36
// Design Name: 
// Module Name: test
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


module test(
    );
    reg clk, rst_rev;
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end
    initial begin
        rst_rev = 1'b0;
        #20;
        rst_rev = 1'b1;
        #50000;
    end
    wire[6:0] led0, led1;
    wire[3:0] px0, px1;
    sopc sopc(
        .clk(clk),
        .rst_rev(rst_rev),
        .led0(led0),
        .px0(px0),
        .led1(led1),
        .px1(px1)
    );
endmodule
