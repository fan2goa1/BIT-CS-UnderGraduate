`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 16:06:29
// Design Name: 
// Module Name: alu
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


module alu(
        input[31:0] in0, in1,
        input[3:0] op,
        output[31:0] out,
        output SF, CF, ZF, OF, PF
    );
    begin
        wire[32:0] unsignedAddSum = $unsigned(in0) + $unsigned(in1);
        wire[32:0] unsignedSubVal = $unsigned(in0) - $unsigned(in1);
        assign out =    (op == `alu_nop) ? 0 : 
                        (op == `alu_sadd) ? ($signed(in0) + $signed(in1)) :
                        (op == `alu_ssub) ? ($signed(in0) - $signed(in1)) :
                        (op == `alu_smul) ? ($signed(in0) * $signed(in1)) :
                        (op == `alu_sdiv) ? ($signed(in0) / $signed(in1)) :
                        (op == `alu_uadd) ? unsignedAddSum[31:0] :
                        (op == `alu_usub) ? unsignedSubVal[31:0] :
                        (op == `alu_shl) ? (in0 << in1) :
                        (op == `alu_shr) ? (in0 >> in1) :
                        (op == `alu_ushr) ? (in0 >>> in1) :
                        (op == `alu_and) ? (in0 & in1) :
                        (op == `alu_or) ? (in0 | in1) :
                        (op == `alu_xor) ? (in0 ^ in1) :
                        (op == `alu_slt) ? ($signed(in0) < $signed(in1) ? 1 : 0) : 
                        (op == `alu_ult) ? ($unsigned(in0) < $unsigned(in1) ? 1 : 0) :
                        (op == `alu_rem) ? ($signed(in0) % $signed(in1)): 0;
        assign ZF = (out == 0) ? 1 : 0;      
        assign PF = ^out;
        assign SF = out[31];
        assign CF = (op == `alu_uadd) ? unsignedAddSum[32] :
                    (op == `alu_usub) ? unsignedSubVal[32] : 0;
        assign OF = (op == `alu_sadd) ? ((~in0[31] ^ in1[31]) & (out[31] ^ in0[31])) : 
                    (op == `alu_ssub) ? ((in0[31] ^ in1[31]) & (out[31] ^ in0[31])) : 0;
    end
endmodule

