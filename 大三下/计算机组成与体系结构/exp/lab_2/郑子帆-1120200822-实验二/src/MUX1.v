`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/30 18:57:16
// Design Name: 
// Module Name: MUX1
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


module MUX1(                        // 12λ2ѡ1
        input wire [11:0] src1,
        input wire [11:0] src2,
        input wire control,
        output reg [11:0] out
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
