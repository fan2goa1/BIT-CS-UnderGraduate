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
    parameter LEN = 32;        // ����λ��Ϊ32λ
    input [3:0] OP;             // �������OP
    input [LEN-1:0] A;          // ��������A
    input [LEN-1:0] B;          // ��������B
    output [LEN-1:0] F;         // ������F
    output  ZF,                 // ���־, ������Ϊ0����1, ������0 
            CF,                 // ��λ��־, ȡ���λ��λC���ӷ�ʱC=1��CF=1��ʾ�н�λ������ʱC=0��CF=1��ʾ�н�λ
            OF,                 // �����־�����з��������������壬�����OF=1������Ϊ0
            SF,                 // ���ű�־����F�����λ��ͬ��1��ʾ������0��ʾ����
            PF;                 // ��żλ��F��������1����PF=1������Ϊ0
    reg [LEN-1:0] F;
    reg C, ZF, CF, OF, SF, PF;       // CΪ���λ��λ
    always@(*)
    begin
        C = 0;
        case(OP)
            4'b0000: begin {C, F} = A + B; end    // �����ӷ���C�������λ
            4'b0001: begin {C, F} = A - B; end    // ����������C�������λ
            4'b0010: begin F = A & B; end         // ��λ��
            4'b0011: begin F = A | B; end         // ��λ��
            4'b0100: begin F = A ^ B; end         // ��λ���
            4'b0101: begin F = ~(A | B); end      // ��λ���
            4'b0110: begin F = A << B; end        // A�߼�����Bλ
            4'b0111: begin F = A >> B; end        // A�߼�����Bλ
        endcase
        ZF = F == 0;                                
        CF = C;                                    
        OF = A[LEN-1] ^ B[LEN-1] ^ F[LEN-1] ^ C;
        SF = F[LEN-1];                              
        PF = ~^F;     // ��ִ��λ����� ��ȡ��
    end     
endmodule
