`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/25 03:21:45
// Design Name: 
// Module Name: ALU_zzf
// Project Name: CCA_lab1
// Target Devices: 
// Tool Versions: Vivado 2020.1
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_zzf(OP,A,B,F,ZF,CF,OF,SF,PF);
    parameter LEN = 32;        // 运算位数为32位
    input [3:0] OP;             // 运算操作OP
    input [LEN-1:0] A;          // 左运算数A
    input [LEN-1:0] B;          // 右运算数B
    output [LEN-1:0] F;         // 运算结果F
    output  ZF,                 // 零标志, 运算结果为0则置1, 否则置0 
            CF,                 // 进位标志, 取最高位进位C。加法时C=1则CF=1表示有进位；减法时C=0则CF=1表示有借位
            OF,                 // 溢出标志，对有符号数运算有意义，溢出则OF=1，否则为0
            SF,                 // 符号标志，与F的最高位相同，1表示负数，0表示正数
            PF;                 // 奇偶位，F有奇数个1，则PF=1，否则为0
    reg [LEN-1:0] F;
    reg C, ZF, CF, OF, SF, PF;       // C为最高位进位
    always@(*)
    begin
        C = 0;
        case(OP)
            4'b0000: begin {C, F} = A + B; end    // 算术加法，C接受最高位
            4'b0001: begin {C, F} = A - B; end    // 算术减法，C接收最高位
            4'b0010: begin F = A & B; end         // 按位与
            4'b0011: begin F = A | B; end         // 按位或
            4'b0100: begin F = A ^ B; end         // 按位异或
            4'b0101: begin F = ~(A | B); end      // 按位或非
            4'b0110: begin F = A << B; end        // A逻辑左移B位
            4'b0111: begin F = A >> B; end        // A逻辑右移B位
        endcase
        ZF = F == 0;                                
        CF = C;                                    
        OF = A[LEN-1] ^ B[LEN-1] ^ F[LEN-1] ^ C;
        SF = F[LEN-1];                              
        PF = ~^F;     // 先执行位级异或 再取反
    end     
endmodule
