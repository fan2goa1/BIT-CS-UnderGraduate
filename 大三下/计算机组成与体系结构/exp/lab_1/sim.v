`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/25 03:24:12
// Design Name: 
// Module Name: sim
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


module sim();
    reg [31:0] A,B;
    reg [3:0] OP;
    initial
    begin
        OP = 4'b0000; A = 32'h7FFF_FFFF; B = 32'h7FFF_FFFF; #100;   // 算术加
        OP = 4'b0001; A = 32'h7FFF_FFFF; B = 32'h7FFF_FFFE; #100;   // 算术减
        OP = 4'b0010; A = 32'h0000_000A; B = 32'h0000_0008; #100;   // 按位与
        OP = 4'b0011; A = 32'h0000_0002; B = 32'h0000_0001; #100;   // 按位或
        OP = 4'b0100; A = 32'h0000_000F; B = 32'h0000_0003; #100;   // 按位异或
        OP = 4'b0101; A = 32'h0000_0000; B = 32'h0000_0001; #100;   //按位或非
        OP = 4'b0110; A = 32'h0000_0001; B = 32'h0000_0004; #100;   // 逻辑左移
        OP = 4'b0111; A = 32'h0000_1000; B = 32'h0000_000C; #100;   // 逻辑左移
    end
    
    wire [31:0] F;
    wire ZF, CF, OF, SF, PF;
    ALU_zzf ALU_sim(
        .OP(OP),
        .A(A),
        .B(B),
        .F(F),
        .ZF(ZF),
        .CF(CF),
        .OF(OF),
        .SF(SF),
        .PF(PF)
    );
    
endmodule
