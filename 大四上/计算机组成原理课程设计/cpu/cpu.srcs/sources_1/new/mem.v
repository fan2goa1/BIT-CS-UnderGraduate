`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 21:41:17
// Design Name: 
// Module Name: mem
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


module mem(
        input wire rst,
        
        input wire we_i,
        input wire[4:0] waddr_i,
        input wire[31:0] wdata_i,
        input wire[2:0] mem_op,
        input wire[31:0] mem_rdata,
        
        output reg reg_we_o,
        output reg[4:0] reg_waddr_o,
        output reg[31:0] reg_wdata_o,
        
        output reg mem_ce,
        output reg[3:0] mem_we,
        
        output wire stall_req 
    );
    
    always @(*) begin
        if (rst == `RstEnable) begin
            reg_we_o <= `WriteDisable;
            reg_waddr_o <= 5'b0;
            reg_wdata_o <= `ZeroWord;
            mem_ce <= `ChipDisable;
        end else begin
            reg_we_o <= we_i;
            reg_waddr_o <= waddr_i;
            reg_wdata_o <= wdata_i;
            mem_we <= 4'b0000;
            mem_ce <= `ChipEnable;
            case (mem_op)
                `mem_lw:    begin
                    reg_we_o <= `WriteEnable;
                    reg_wdata_o <= mem_rdata;
                end
                `mem_sw:    begin
                    mem_we <= 4'b1111;
                end
                default:    begin
                end
            endcase
        end
    end
    
    assign stall_req = `NoStop;
endmodule
