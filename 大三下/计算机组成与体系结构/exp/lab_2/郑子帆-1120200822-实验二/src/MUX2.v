`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/29 18:50:34
// Design Name: 
// Module Name: MUX2
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


module MUX2(            // 32λ2ѡ1
        input wire [31:0] src1,
        input wire [31:0] src2,
        input wire control,
        output reg [31:0] out
    );

    always @(*) begin
        case (control)
            1'b0:
                begin out = src1; end

            1'b1:
                begin out = src2; end
        endcase
    end
endmodule

