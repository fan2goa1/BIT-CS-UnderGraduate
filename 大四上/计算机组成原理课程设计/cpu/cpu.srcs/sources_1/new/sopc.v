`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/04 17:22:13
// Design Name: 
// Module Name: sopc
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


module sopc(
        input wire clk_fast,
        input wire rst_rev,
        output wire[6:0] led0,
        output wire[3:0] px0,
        output wire[6:0] led1,
        output wire[3:0] px1
    );
    wire rst;
    assign rst = rst_rev ^ 1;
    wire clk;
    slow_clock(
        .clk(clk_fast),
        .clk_out(clk)
    );

    wire inst_sram_ce;
    wire[3:0] inst_sram_we;
    wire[31:0] inst_sram_addr;
    wire[31:0] inst_sram_wdata;
    wire[31:0] inst_sram_rdata;
    
    wire data_sram_ce;
    wire[3:0] data_sram_we;
    wire[31:0] data_sram_addr;
    wire[31:0] data_sram_wdata;
    wire[31:0] data_sram_rdata;

    cpu_top cpu_top(
        .clk(clk),
        .rst(rst),
        
        .inst_sram_ce(inst_sram_ce),
        .inst_sram_we(inst_sram_we),
        .inst_sram_addr(inst_sram_addr),
        .inst_sram_wdata(inst_sram_wdata),
        .inst_sram_rdata(inst_sram_rdata),
        
        .data_sram_we(data_sram_we),
        .data_sram_ce(data_sram_ce),
        .data_sram_addr(data_sram_addr),
        .data_sram_wdata(data_sram_wdata),
        .data_sram_rdata(data_sram_rdata)
    );
    //
//    inst_sram inst_sram(
//        .clk(clk),
//        .ce(inst_sram_ce),
//        .we(inst_sram_we),
//        .addr(inst_sram_addr),
//        .din(inst_sram_wdata),
//        .dout(inst_sram_rdata)
//    );
//    data_sram data_sram(
//        .clk(clk),
//        .ce(data_sram_ce),
//        .we(data_sram_we),
//        .addr(data_sram_addr),
//        .din(data_sram_wdata),
//        .dout(data_sram_rdata)
//    );
    // IP core
    inst_sram inst_sram(
        .clk(clk),
        .a(inst_sram_addr[11:2]),
        .d(inst_sram_wdata),
        .we(inst_sram_we[0]),
        .spo(inst_sram_rdata)
     );
     
     data_sram data_sram(
        .clk(clk),
        .a(data_sram_addr[9:0]),
        .d(data_sram_wdata),
        .we(data_sram_we[0]),
        .spo(data_sram_rdata)
     );
        
    
    light_show light_show0(
        .clk(clk),
        .rst(rst),
        .data(data_sram_rdata[15:0]),
        .led(led0),
        .px(px0)
    );
    light_show light_show1(
        .clk(clk),
        .rst(rst),
        .data(data_sram_rdata[31:16]),
        .led(led1),
        .px(px1)
    );
endmodule
