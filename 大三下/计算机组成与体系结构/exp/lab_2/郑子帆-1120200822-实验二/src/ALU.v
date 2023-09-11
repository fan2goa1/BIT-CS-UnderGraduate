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
    parameter LEN = 32; // ����λ��Ϊ 32 λ
    input [3:0] OP; // ������� OP
    input [LEN-1:0] A; // �������� A
    input [LEN-1:0] B; // �������� B
    output [LEN-1:0] F; // ������ F
    output ZF,
 CF,
 OF, SF, PF;
    reg [LEN-1:0] F;
    reg C, ZF, CF, OF, SF, PF; // C Ϊ���λ��λ
    always@(*)
    begin
        C = 0;
        case(OP)
            // �����ӷ���C �������λ
            4'b0000: begin {C, F} = A + B; end
            // ����������C �������λ
            4'b0001: begin {C, F} = A - B; end
            // ��λ��
            4'b0010: begin F = A & B; end
            // ��λ��
            4'b0011: begin F = A | B; end
            // ��λ���
            4'b0100: begin F = A ^ B; end
            // ��λ���
            4'b0101: begin F = ~(A | B); end
            // A �߼����� B λ
            4'b0110: begin F = A << B; end
            // A �߼����� B λ
            4'b0111: begin F = A >> B; end
            endcase
            
        ZF = F == 0;
        CF = C;
        OF = A[LEN-1] ^ B[LEN-1] ^ F[LEN-1] ^ C;
        SF = F[LEN-1];
        PF = ~^F; // ��ִ��λ����� ��ȡ��
    end
endmodule