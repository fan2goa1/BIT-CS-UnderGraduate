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
        input clk, // ʱ���ź�
        input rst, // ��λ�ź�
        input reg_we, // ��д�ź�
        input [4:0] rs_addr, // ���Ĵ�����ַ1
        input [4:0] rt_addr, // ���Ĵ�����ַ2
        input [4:0] wb_addr, // д�Ĵ����ĵ�ַ
        input [31:0] wb_data, // Ҫд��wb������
        output [31:0] rs_data, // ��������1
        output [31:0] rt_data  // ��������2
    );
    
    reg [31:0] gpr [31:0]; // 32��32λ�Ĵ���
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
