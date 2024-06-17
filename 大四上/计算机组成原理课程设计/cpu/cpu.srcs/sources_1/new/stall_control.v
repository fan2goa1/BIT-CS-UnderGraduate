`include "defines.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/01 14:40:12
// Design Name: 
// Module Name: stall_control
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


module stall_control(
        input wire stall_req_id,
        input wire stall_req_ex,
        input wire stall_req_mem,
        
        output wire[5:0] stall
    );

    assign stall =  (stall_req_mem == `Stop) ? 6'b001111 :
                    (stall_req_ex == `Stop) ? 6'b000111 :
                    (stall_req_id == `Stop) ? 6'b000011 : 6'b000000;
endmodule
