`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/29 00:48:19
// Design Name: 
// Module Name: InstructionMemory
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


module InstructionMemory(
        input [31:0] in_addr,   
        output [31:0] instruction
    );
    
    reg [31:0] Imem [255:0];

    initial begin
        $readmemh("C:/Users/steve/Desktop/CCA/exp/lab_2/text.txt", Imem); // 从文件中读取指令二进制代码赋值给mem
    end

    wire [7:0] addr = in_addr[9:2];
    assign instruction = Imem[addr];

endmodule 