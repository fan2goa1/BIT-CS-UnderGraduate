`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 21:26:51
// Design Name: 
// Module Name: ex
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


module ex(
        input wire rst,
        
        input wire[2:0] inst_type,
        input wire[2:0] inst_op,
        input wire[3:0] alu_op,
        input wire[31:0] reg1,
        input wire[31:0] reg2,
        input wire[31:0] reg3,
        input wire reg_we_i,
        input wire[4:0] reg_waddr_i,
        
        output reg reg_we_o,
        output reg[4:0] reg_waddr_o,
        output reg[31:0] reg_wdata_o,
        output reg[2:0] mem_op,
        output reg[31:0] mem_addr,
        output reg[31:0] mem_data,
        output reg stall_req
    );
    
    wire[31:0] alu_out;
    wire SF, CF, ZF, OF, PF;
    alu alu(.in0(reg1),
            .in1(reg2),
            .op(alu_op),
            .out(alu_out),
            .SF(SF),.CF(CF),.ZF(ZF),.OF(OF),.PF(PF));
    always @(*) begin
        reg_we_o <= reg_we_i;
        reg_waddr_o <= reg_waddr_i;
        reg_wdata_o <= (inst_type == `inst_type_calc && inst_op == `calc_alu) ? alu_out : `ZeroWord;
        mem_op <= `mem_nop;
        mem_addr <= `ZeroWord;
        mem_data <= `ZeroWord;
        stall_req <= `NoStop;
        if (inst_type == `inst_type_mem) begin
            mem_op <= inst_op;
            case (inst_op)
                `mem_lw:    begin
                    mem_addr <= alu_out;
                end
                `mem_sw:    begin
                    mem_addr <= alu_out;
                    mem_data <= reg3;
                end
                default:    begin
                end
            endcase
        end
    end
endmodule
