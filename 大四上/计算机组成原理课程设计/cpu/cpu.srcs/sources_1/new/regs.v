`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 16:48:02
// Design Name: 
// Module Name: regs
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


module regs(
        input wire clk,
        input wire rst,
        
        input wire we,
        input wire[4:0] waddr,
        input wire[31:0] wdata,
        
        input wire ex_we,
        input wire[4:0] ex_waddr,
        input wire[31:0] ex_wdata,
        
        input wire mem_we,
        input wire[4:0] mem_waddr,
        input wire[31:0] mem_wdata,
        
        input wire re1,
        input wire[4:0] raddr1,
        output wire[31:0] rdata1,
        
        input wire re2,
        input wire[4:0] raddr2,
        output wire[31:0] rdata2
    );
    
    reg[31:0] regs[0:31];
    integer i;
    always @(posedge clk) begin
        if (rst == `RstDisable) begin
            if ((we == `WriteEnable) && (waddr != 5'b00000)) begin
                regs[waddr] <= wdata;
            end
        end else begin
            for(i=0; i<=31; i=i+1) begin
                regs[i] <= 32'b0;
            end
        end
    end
    
    assign rdata1 = (rst == `RstEnable || re1 == `ReadDisable || raddr1 == 5'b00000) ? `ZeroWord :
                    (ex_we == `WriteEnable && ex_waddr == raddr1) ? ex_wdata :
                    (mem_we == `WriteEnable && mem_waddr == raddr1) ? mem_wdata :
                    (we == `WriteEnable && waddr == raddr1) ? wdata : regs[raddr1];
    
    assign rdata2 = (rst == `RstEnable || re2 == `ReadDisable || raddr2 == 5'b00000) ? `ZeroWord :
                    (ex_we == `WriteEnable && ex_waddr == raddr2) ? ex_wdata :
                    (mem_we == `WriteEnable && mem_waddr == raddr2) ? mem_wdata :
                    (we == `WriteEnable && waddr == raddr2) ? wdata : regs[raddr2];
endmodule
