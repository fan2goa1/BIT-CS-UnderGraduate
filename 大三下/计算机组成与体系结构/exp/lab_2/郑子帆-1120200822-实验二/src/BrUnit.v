`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/29 18:49:10
// Design Name: 
// Module Name: BrUnit
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


module BrUnit(
        input [11:0] br_offset,   // ������תƫ��
        input [19:0] jal_offset,  // ֱ����תƫ��
        input [31:0] rs1_data,    // Դ��1
        input [31:0] rs2_data,    // Դ��2
        input [2:0] branch,      // �����ź�
        output reg jump,        // �Ƿ���ת
        output reg [31:0] offset // ƫ����
    );

    reg [31:0] act_br_offset, act_jal_offset;
    always @(*) begin
        act_br_offset[12:0] = {br_offset[11], br_offset[0], br_offset[10:1], 1'b0};
        if (br_offset[11] == 1) begin
            act_br_offset[31:13] = 19'b1111_11111_11111_11111;
        end else begin
            act_br_offset[31:13] = 19'b0;
        end

        act_jal_offset[20:0] = {jal_offset[19], jal_offset[7:0], jal_offset[8], jal_offset[18:9], 1'b0};
        if (jal_offset[19] == 1) begin
            act_jal_offset[31:21] = 11'b1_11111_11111;
        end else begin
            act_jal_offset[31:21] = 11'b0;
        end
    end

    always @(*) begin
        case (branch)
            3'b000:begin
                jump = 0;
            end 
            
            3'b011:begin        // blt
               offset = act_br_offset;
                if ((rs1_data[31] == 0 && rs2_data[31] == 1) || (rs1_data[31] == rs2_data[31] && rs1_data >= rs2_data)) begin
                    jump = 0;
                end
                else begin
                    jump = 1;
                end
            end
            
            3'b100:begin        //bge
                offset = act_br_offset;
                if ((rs1_data[31] == 0 && rs2_data[31] == 1) || (rs1_data[31] == rs2_data[31] && rs1_data >= rs2_data)) begin
                    jump = 1;
                end
                else begin
                    jump = 0;
                end
            end

            3'b101:begin        //beq
                offset = act_br_offset;
                if (rs1_data == rs2_data) begin
                    jump = 1;
                end else begin
                    jump = 0;
                end
            end

            3'b110:begin        //bne
                offset = act_br_offset;
                if (rs1_data != rs2_data) begin
                    jump = 1;
                end else begin
                    jump = 0;
                end
            end

            3'b111:begin        //jal
                offset = act_jal_offset;
                jump = 1;
            end
        endcase
    end

endmodule

