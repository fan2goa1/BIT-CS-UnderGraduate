`timescale 1ns/1ps

module bt_top(
    input   wire        clk_pin,
    input   wire        rst_pin,

    // Synchronous clk
    output  wire        clk_rx,     // Receive clock
    output  wire        clk_tx,     // Transmit clock

    // Synchronous rst
    output  wire        rst_clk_rx, // Reset, synchronized to clk_rx
    output  wire        rst_clk_tx, // Reset, synchronized to clk_tx
    
    // RS232 signals
    input   wire        rxd_pin,    // RS232 RXD pin
    output  wire        txd_pin,    // RS232 TXD pin

    // Received data
    output  wire[7:0]   rx_data,
    output  wire        rx_buf_rdy,

    // Send data
    input   wire[7:0]   tx_data,
    input   wire        tx_buf_en,
    output  wire        tx_buf_full
);

//***************************************************************************
// Parameter definitions
//***************************************************************************

parameter BAUD_RATE           = 9600;   

parameter CLOCK_RATE_RX       = 100_000_000;
parameter CLOCK_RATE_TX       = 100_000_000; 


wire        rst_i;          
wire        rxd_i;         
wire        txd_o;

// From Clock Generator
wire        clock_locked;   // Locked signal from clk_core

// From the character FIFO
wire [7:0]  char_fifo_dout;   // Character to be popped from the FIFO
wire        char_fifo_empty;  // The character FIFO is full

// From the UART transmitter
wire        char_fifo_rd_en;  // Pop signal to the char FIFO

//***************************************************************************
// Code
//***************************************************************************

// Instantiate input/output buffers
IBUF IBUF_rst_i0      (.I (rst_pin),      .O (rst_i));
IBUF IBUF_rxd_i0      (.I (rxd_pin),      .O (rxd_i));
OBUF OBUF_txd         (.I(txd_o),         .O(txd_pin));

// Instantiate the clock generator
clk_gen clk_gen_i0 (
    .clk_pin         (clk_pin),         // Input clock pin - IBUFG is in core
    .rst_i           (rst_i),           // Asynchronous input from IBUF

    .rst_clk_tx      (rst_clk_tx),      // For clock divider

    .pre_clk_tx      (),                // Current divider

    .clk_rx          (clk_rx),          // Receive clock
    .clk_tx          (clk_tx),          // Transmit clock6
    .clk_samp        (),                // Sample clock

    .en_clk_samp     (),                // Enable for clk_samp
    .clock_locked    (clock_locked)     // Locked signal from clk_core
);

// Instantiate the reset generator
rst_gen rst_gen_i0 (
    .clk_rx          (clk_rx),          // Receive clock
    .clk_tx          (clk_tx),          // Transmit clock
    .clk_samp        (),                // Sample clock

    .rst_i           (rst_i),           // Asynchronous input - from IBUF
    .clock_locked    (clock_locked),    // Locked signal from clk_core

    .rst_clk_rx      (rst_clk_rx),      // Reset, synchronized to clk_rx
    .rst_clk_tx      (rst_clk_tx),      // Reset, synchronized to clk_tx
    .rst_clk_samp    ()                 // Reset, synchronized to clk_samp
);

// Instantiate the UART receiver
uart_rx #(
    .BAUD_RATE   (BAUD_RATE),
    .CLOCK_RATE  (CLOCK_RATE_RX)
) uart_rx_i0 (
    .clk_rx      (clk_rx),              // Receive clock
    .rst_clk_rx  (rst_clk_rx),          // Reset, synchronized to clk_rx 

    .rxd_i       (rxd_i),               // RS232 receive pin
    .rxd_clk_rx  (),                    // RXD pin after sync to clk_rx(unused)
    
    .rx_data_rdy (rx_buf_rdy),         // New character is ready
    .rx_data     (rx_data),             // New character
    .frm_err     ()                     // Framing error (unused)
);

// Instantiate the Character FIFO - Core generator module
char_fifo char_fifo_i0 (
    .din        (tx_data), // Bus [7 : 0] 
    .rd_clk     (clk_tx),
    .rd_en      (char_fifo_rd_en),
    .rst        (rst_i),          // ASYNCHRONOUS reset - to both sides
    .wr_clk     (clk_rx),
    .wr_en      (tx_buf_en),
    .dout       (char_fifo_dout), // Bus [7 : 0] 
    .empty      (char_fifo_empty),
    .full       (tx_buf_full)
);

// Instantiate the UART transmitter
uart_tx #(
    .BAUD_RATE    (BAUD_RATE),
    .CLOCK_RATE   (CLOCK_RATE_TX)
) uart_tx_i0 (
    .clk_tx             (clk_tx),          // Clock input
    .rst_clk_tx         (rst_clk_tx),      // Reset - synchronous to clk_tx

    .char_fifo_empty    (char_fifo_empty), // Empty signal from char FIFO (FWFT)
    .char_fifo_dout     (char_fifo_dout),  // Data from the char FIFO
    .char_fifo_rd_en    (char_fifo_rd_en), // Pop signal to the char FIFO

    .txd_tx             (txd_o)           // The transmit serial signal
);

endmodule
