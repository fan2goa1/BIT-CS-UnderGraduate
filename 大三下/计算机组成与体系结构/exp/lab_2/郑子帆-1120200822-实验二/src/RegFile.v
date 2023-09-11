`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/29 12:57:01
// Design Name: 
// Module Name: RegFile
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


module RegFile(
        input clk, // 时钟信号
        input rst, // 复位信号
        input reg_we, // 读写信号
        input [4:0] rs_addr, // 读寄存器地址1
        input [4:0] rt_addr, // 读寄存器地址2
        input [4:0] wb_addr, // 写寄存器的地址
        input [31:0] wb_data, // 要写入wb的数据
        output [31:0] rs_data, // 读出数据1
        output [31:0] rt_data  // 读出数据2
    );
    
    reg [31:0] gpr [31:0]; // 32个32位寄存器
    integer i;
    always @(negedge clk or negedge rst) begin
        if(!rst) begin
            for(i = 0; i < 32; i = i + 1) begin
                gpr[i] <= 32'b0;
            end
        end
        else if (reg_we) begin
            gpr[wb_addr] = wb_data;
        end
    end
    
    assign rs_data = gpr[rs_addr];
    assign rt_data = gpr[rt_addr];
    
endmodule
