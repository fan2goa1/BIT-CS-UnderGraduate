`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/30 03:39:48
// Design Name: 
// Module Name: ALU
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


module ALU(
        OP,
        A,B,F,
        ZF,CF,OF,SF,PF
    );
    parameter LEN = 32; // 运算位数为 32 位
    input [3:0] OP; // 运算操作 OP
    input [LEN-1:0] A; // 左运算数 A
    input [LEN-1:0] B; // 右运算数 B
    output [LEN-1:0] F; // 运算结果 F
    output ZF,
 CF,
 OF, SF, PF;
    reg [LEN-1:0] F;
    reg C, ZF, CF, OF, SF, PF; // C 为最高位进位
    always@(*)
    begin
        C = 0;
        case(OP)
            // 算术加法，C 接受最高位
            4'b0000: begin {C, F} = A + B; end
            // 算术减法，C 接收最高位
            4'b0001: begin {C, F} = A - B; end
            // 按位与
            4'b0010: begin F = A & B; end
            // 按位或
            4'b0011: begin F = A | B; end
            // 按位异或
            4'b0100: begin F = A ^ B; end
            // 按位或非
            4'b0101: begin F = ~(A | B); end
            // A 逻辑左移 B 位
            4'b0110: begin F = A << B; end
            // A 逻辑右移 B 位
            4'b0111: begin F = A >> B; end
            endcase
            
        ZF = F == 0;
        CF = C;
        OF = A[LEN-1] ^ B[LEN-1] ^ F[LEN-1] ^ C;
        SF = F[LEN-1];
        PF = ~^F; // 先执行位级异或 再取反
    end
endmodule