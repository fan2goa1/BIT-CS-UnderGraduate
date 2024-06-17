`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/01 17:21:00
// Design Name: 
// Module Name: data_sram
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


module data_sram(
        input wire clk,
        input wire ce,
        input wire[3:0] we,
        input wire[31:0] addr,
        input wire[31:0] din,
        output reg[31:0] dout
    );
    reg[31:0] data_mem[0:255];
    integer i;
    initial begin
        for (i = 0; i <= 255; i = i + 1) begin
            data_mem[i] = 0;
        end
    end
    wire[7:0] byte_addr = addr[9:2];
    always @(posedge clk) begin
        if (ce == `ChipEnable && we != 4'b0000) begin
            if (we[0] == 1'b1) begin
                data_mem[byte_addr][7:0] = din[7:0];
            end
            if (we[1] == 1'b1) begin
                data_mem[byte_addr][15:8] = din[15:8];
            end
            if (we[2] == 1'b1) begin
                data_mem[byte_addr][23:16] = din[23:16];
            end
            if (we[3] == 1'b1) begin
                data_mem[byte_addr][31:24] = din[31:24];
            end
        end
    end

    always @(*) begin
        if (ce == `ChipDisable || we != 4'b0000) begin
            dout <= `ZeroWord;
        end else begin
            dout <= data_mem[byte_addr];
        end
    end
endmodule
