`include "config.vh"

`ifdef HDMI_ENABLE
module HDMI #(
    parameter CLK_FREQ            = 100_000_000,
    parameter DISPLAY_WIDTH       = 640,
    parameter DISPLAY_HEIGHT      = 480,
    parameter DISPLAY_COLOR_DEPTH = 8
) (
    input  logic clk,
    input  logic rst_n,
    
    // Wishbone Interface
    input  logic        cyc_i,     // Wishbone cycle indicator
    input  logic        stb_i,     // Wishbone strobe (request)
    input  logic        we_i,      // Write enable
    input  logic [31:0] addr_i,    // Address input
    input  logic [31:0] data_i,    // Data input (for write)
    output logic [31:0] data_o,    // Data output (for read)
    output logic        ack_o,     // Acknowledge output

    output logic TDMS_DATA_P[2:0], // TMDS data output
    output logic TDMS_DATA_N[2:0], // TMDS data output
    output logic TMDS_CLK_P,       // TMDS clock output
    output logic TMDS_CLK_N        // TMDS clock output
);


    
endmodule

`endif