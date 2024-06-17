-- (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:user:bt_top:1.0
-- IP Revision: 2

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT bt_top_0
  PORT (
    clk_pin : IN STD_LOGIC;
    rst_pin : IN STD_LOGIC;
    clk_rx : OUT STD_LOGIC;
    clk_tx : OUT STD_LOGIC;
    rst_clk_rx : OUT STD_LOGIC;
    rst_clk_tx : OUT STD_LOGIC;
    rxd_pin : IN STD_LOGIC;
    txd_pin : OUT STD_LOGIC;
    rx_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    rx_buf_rdy : OUT STD_LOGIC;
    tx_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    tx_buf_en : IN STD_LOGIC;
    tx_buf_full : OUT STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : bt_top_0
  PORT MAP (
    clk_pin => clk_pin,
    rst_pin => rst_pin,
    clk_rx => clk_rx,
    clk_tx => clk_tx,
    rst_clk_rx => rst_clk_rx,
    rst_clk_tx => rst_clk_tx,
    rxd_pin => rxd_pin,
    txd_pin => txd_pin,
    rx_data => rx_data,
    rx_buf_rdy => rx_buf_rdy,
    tx_data => tx_data,
    tx_buf_en => tx_buf_en,
    tx_buf_full => tx_buf_full
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file bt_top_0.vhd when simulating
-- the core, bt_top_0. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.

