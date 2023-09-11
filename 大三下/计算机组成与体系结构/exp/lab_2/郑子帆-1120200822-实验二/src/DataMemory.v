`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/29 02:46:47
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
        input clk,
        input [31:0] in_addr,
        input we,
        input [31:0] wdata,
        output [31:0] rdata
    );
    reg [31:0] Dmem [255:0];

    initial begin
        $readmemh("C:/Users/steve/Desktop/CCA/exp/lab_2/data.txt", Dmem);
    end
    
    wire [7:0] addr = in_addr[9:2];
    assign rdata = Dmem[addr];
    
    always @(negedge clk) begin
        if (we) begin
            Dmem[addr] <= wdata;
        end
        
    end
endmodule