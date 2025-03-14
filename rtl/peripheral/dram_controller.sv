`include "config.vh"

`ifdef DRAM_ENABLE
module DRAM_Controller #(
    parameter CLK_FREQ = 100_000_000
) (
    input  logic clk,
    input  logic rst_n,
    
    // Wishbone Interface
    input  logic        cyc_i,          // Wishbone cycle indicator
    input  logic        stb_i,          // Wishbone strobe (request)
    input  logic        we_i,           // Write enable

    input  logic [31:0] addr_i,         // Address input
    input  logic [31:0] data_i,         // Data input (for write)
    output logic [31:0] data_o,         // Data output (for read)
    output logic        ack_o           // Acknowledge output
);
    
endmodule
`endif