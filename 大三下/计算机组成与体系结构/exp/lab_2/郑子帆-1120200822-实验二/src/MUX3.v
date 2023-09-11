`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/29 18:59:25
// Design Name: 
// Module Name: MUX3
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


module MUX3(                    // ���ͼ�е�MUX3��32λ��3ѡ1
        input wire [31:0] src1,
        input wire [31:0] src2,
        input wire [31:0] src3,         
        input wire [1:0] control,
        output reg [31:0] out
    );

    always @(*) begin
        case (control)
            2'b00:
                begin out = src1; end

            2'b01:
                begin out = src2; end

            2'b10:
                begin out = src3; end
        endcase
    end
endmodule
