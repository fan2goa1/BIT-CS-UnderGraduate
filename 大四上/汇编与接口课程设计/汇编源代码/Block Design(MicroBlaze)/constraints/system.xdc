set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rstn]
set_property PACKAGE_PIN T5 [get_ports sys_clk]
set_property PACKAGE_PIN P15 [get_ports sys_rstn]

#/////////////////////////////LCD屏幕的SPI接口/////////////////////////////////////////////
set_property IOSTANDARD LVCMOS33 [get_ports lcd_cs]
set_property IOSTANDARD LVCMOS33 [get_ports lcd_rstn]
set_property IOSTANDARD LVCMOS33 [get_ports lcd_rs]
set_property IOSTANDARD LVCMOS33 [get_ports lcd_sck]
set_property IOSTANDARD LVCMOS33 [get_ports lcd_mosi]
set_property PACKAGE_PIN V6 [get_ports lcd_sck]
set_property PACKAGE_PIN U9 [get_ports lcd_mosi]
set_property PACKAGE_PIN T6 [get_ports lcd_rs]
set_property PACKAGE_PIN R7 [get_ports lcd_rstn]
set_property PACKAGE_PIN U6 [get_ports lcd_cs]

#/////////////////////////////串口/////////////////////////////////////////////
set_property -dict {PACKAGE_PIN N5 IOSTANDARD LVCMOS33} [get_ports uart_rtl_rxd]
set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS33} [get_ports uart_rtl_txd]

#/////////////////////////////蓝牙/////////////////////////////////////////////
set_property -dict {PACKAGE_PIN L3 IOSTANDARD LVCMOS33} [get_ports rx_pin]
set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS33} [get_ports tx_pin]

#/////////////////////////////开关/////////////////////////////////////////////
set_property IOSTANDARD LVCMOS33 [get_ports {sw_pin[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_pin[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_pin[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_pin[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_pin[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_pin[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports bt_master_slave]
set_property IOSTANDARD LVCMOS33 [get_ports bt_pw_on]
set_property IOSTANDARD LVCMOS33 [get_ports bt_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports bt_sw]
set_property IOSTANDARD LVCMOS33 [get_ports bt_sw_hw]

set_property PACKAGE_PIN R1 [get_ports {sw_pin[0]}]
set_property PACKAGE_PIN N4 [get_ports {sw_pin[1]}]
set_property PACKAGE_PIN M4 [get_ports {sw_pin[2]}]
set_property PACKAGE_PIN R2 [get_ports {sw_pin[3]}]
set_property PACKAGE_PIN P2 [get_ports {sw_pin[4]}]
set_property PACKAGE_PIN P3 [get_ports {sw_pin[5]}]
set_property PACKAGE_PIN C16 [get_ports bt_master_slave]
set_property PACKAGE_PIN D18 [get_ports bt_pw_on]
set_property PACKAGE_PIN M2 [get_ports bt_rst_n]
set_property PACKAGE_PIN E18 [get_ports bt_sw]
set_property PACKAGE_PIN H15 [get_ports bt_sw_hw]

#/////////////////////////////LCD字库ROM的SPI接口/////////////////////////////////////////////
set_property IOSTANDARD LVCMOS33 [get_ports rom_cs]
set_property IOSTANDARD LVCMOS33 [get_ports rom_sck]
set_property IOSTANDARD LVCMOS33 [get_ports rom_miso]
set_property IOSTANDARD LVCMOS33 [get_ports rom_mosi]
set_property PACKAGE_PIN H17 [get_ports rom_miso]
set_property PACKAGE_PIN G17 [get_ports rom_mosi]
set_property PACKAGE_PIN J13 [get_ports rom_sck]
set_property PACKAGE_PIN K13 [get_ports rom_cs]
