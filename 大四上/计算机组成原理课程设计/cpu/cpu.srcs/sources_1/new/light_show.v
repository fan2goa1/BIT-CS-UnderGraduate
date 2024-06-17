`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/04 16:07:13
// Design Name: 
// Module Name: light_show
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


module light_show(
        input wire clk,
        input wire rst,
        input wire[15:0] data,
        output reg[6:0] led,
        output reg[3:0] px
    );
    
    wire[6:0] led_digit[0:15];
    assign led_digit[0] = 7'h7e;
    assign led_digit[1] = 7'h30;
    assign led_digit[2] = 7'h6d;
    assign led_digit[3] = 7'h79;
    assign led_digit[4] = 7'h33;
    assign led_digit[5] = 7'h5b;
    assign led_digit[6] = 7'h5f;
    assign led_digit[7] = 7'h70;
    assign led_digit[8] = 7'h7f;
    assign led_digit[9] = 7'h7b;
    assign led_digit[10] = 7'h77;
    assign led_digit[11] = 7'h1f;
    assign led_digit[12] = 7'h4e;
    assign led_digit[13] = 7'h3d;
    assign led_digit[14] = 7'h4f;
    assign led_digit[15] = 7'h47;
    reg[12:0] i;

    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            i = 13'h0;
        end else begin
            i = i + 1;
            case (i[12:11])
                2'b00:  begin
                    px <= 4'b0001;
                    led <= led_digit[data[3:0]];
                end
                2'b01:  begin
                    px <= 4'b0010;
                    led <= led_digit[data[7:4]];
                end
                2'b10:  begin
                    px <= 4'b0100;
                    led <= led_digit[data[11:8]];
                end
                2'b11:  begin
                    px <= 4'b1000;
                    led <= led_digit[data[15:12]];
                end
            endcase
        end
    end
endmodule
