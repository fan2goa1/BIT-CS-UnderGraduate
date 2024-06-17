//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Thu Sep  1 10:34:25 2023
//Host        : DESKTOP-46PA33Q running 64-bit major release  (build 9200)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (
    output lcd_cs,
    output lcd_rstn,
    output lcd_rs,
    output lcd_sck,
    output lcd_mosi,
    
    inout rom_cs,
    inout rom_sck,
    inout rom_miso,
    inout rom_mosi,
    
    input sys_clk,
    input sys_rstn,
    
    input uart_rtl_rxd,
    output uart_rtl_txd,
    
    input rx_pin,
    output tx_pin,
    
    // bluetooth_top
    output  wire        bt_pw_on,
    output  wire        bt_master_slave,
    output  wire        bt_sw_hw,
    output  wire        bt_rst_n,
    output  wire        bt_sw,
    input   wire[5:0]   sw_pin
    );
  

  wire [4:0]lcd_rtl_tri_o;
  wire [0:0]rom_rtl_tri_i_0;
  wire [1:1]rom_rtl_tri_i_1;
  wire [2:2]rom_rtl_tri_i_2;
  wire [3:3]rom_rtl_tri_i_3;
  wire [0:0]rom_rtl_tri_io_0;
  wire [1:1]rom_rtl_tri_io_1;
  wire [2:2]rom_rtl_tri_io_2;
  wire [3:3]rom_rtl_tri_io_3;
  wire [0:0]rom_rtl_tri_o_0;
  wire [1:1]rom_rtl_tri_o_1;
  wire [2:2]rom_rtl_tri_o_2;
  wire [3:3]rom_rtl_tri_o_3;
  wire [0:0]rom_rtl_tri_t_0;
  wire [1:1]rom_rtl_tri_t_1;
  wire [2:2]rom_rtl_tri_t_2;
  wire [3:3]rom_rtl_tri_t_3;
  wire sys_clk;
  wire sys_rstn;
  wire uart_rtl_rxd;
  wire uart_rtl_txd;
  wire rx_pin;
  wire tx_pin;

  IOBUF rom_rtl_tri_iobuf_0
       (.I(rom_rtl_tri_o_0),
        .IO(rom_mosi),
        .O(rom_rtl_tri_i_0),
        .T(rom_rtl_tri_t_0));
  IOBUF rom_rtl_tri_iobuf_1
       (.I(rom_rtl_tri_o_1),
        .IO(rom_miso),
        .O(rom_rtl_tri_i_1),
        .T(rom_rtl_tri_t_1));
  IOBUF rom_rtl_tri_iobuf_2
       (.I(rom_rtl_tri_o_2),
        .IO(rom_sck),
        .O(rom_rtl_tri_i_2),
        .T(rom_rtl_tri_t_2));
  IOBUF rom_rtl_tri_iobuf_3
       (.I(rom_rtl_tri_o_3),
        .IO(rom_cs),
        .O(rom_rtl_tri_i_3),
        .T(rom_rtl_tri_t_3));
  system system_i
       (.lcd_rtl_tri_o({lcd_cs,lcd_rstn,lcd_rs,lcd_sck,lcd_mosi}),
        .rom_rtl_tri_i({rom_rtl_tri_i_3,rom_rtl_tri_i_2,rom_rtl_tri_i_1,rom_rtl_tri_i_0}),
        .rom_rtl_tri_o({rom_rtl_tri_o_3,rom_rtl_tri_o_2,rom_rtl_tri_o_1,rom_rtl_tri_o_0}),
        .rom_rtl_tri_t({rom_rtl_tri_t_3,rom_rtl_tri_t_2,rom_rtl_tri_t_1,rom_rtl_tri_t_0}),
        .sys_clk(sys_clk),
        .sys_rstn(sys_rstn),
        .uart_rtl_rxd(uart_rtl_rxd),
        .uart_rtl_txd(uart_rtl_txd),
        .rx_pin(rx_pin),
        .tx_pin(tx_pin));

    assign bt_master_slave = sw_pin[0];
    assign bt_sw_hw        = sw_pin[1];
    assign bt_rst_n        = sw_pin[2];
    assign bt_sw           = sw_pin[3];
    assign bt_pw_on        = sw_pin[4];

endmodule
