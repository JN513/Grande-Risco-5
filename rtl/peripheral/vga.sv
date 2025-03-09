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

    output logic response_o,
    input  logic read_request_i,
    input  logic write_request_i,

    input  logic [31:0] address_i,
    input  logic [31:0] write_data_i,
    output logic [31:0] read_data_o,

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