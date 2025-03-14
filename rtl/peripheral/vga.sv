`include "config.vh"

`ifdef VGA_ENABLE
module VGA #(
    parameter CLK_FREQ        = 100_000_000,
    parameter VGA_WIDTH       = 640,
    parameter VGA_HEIGHT      = 480,
    parameter VGA_COLOR_DEPTH = 8
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
    output logic        ack_o,          // Acknowledge output

    output logic [VGA_COLOR_DEPTH - 1:0] vga_r,
    output logic [VGA_COLOR_DEPTH - 1:0] vga_g,
    output logic [VGA_COLOR_DEPTH - 1:0] vga_b,
    output logic hsync,
    output logic vsync
);

localparam BUFFER_SIZE = WIDTH * HEIGHT;

`ifdef BLACK_AND_WHITE
localparam BUFFER_WIDTH = 1;
`elsif GRAY_SCALE
localparam BUFFER_WIDTH = VGA_COLOR_DEPTH;
`else
localparam BUFFER_WIDTH = (VGA_COLOR_DEPTH * 3);
`endif

logic [BUFFER_WIDTH - 1:0] video_buffer [0: BUFFER_SIZE - 1];


    
endmodule

`endif