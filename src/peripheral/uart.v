module UART #(
    parameter CLK_FREQ     = 25000000,
    parameter BIT_RATE     = 115200,
    parameter PAYLOAD_BITS = 8,
    parameter BUFFER_SIZE  = 32,
    parameter WORD_SIZE_B  = 1
) (
    input wire clk,
    input wire rst_n,

    input wire rx,
    output wire tx,

    input wire read_request,
    input wire write_request,
    output reg read_response,
    output reg write_response,

    input wire [31:0] address,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);


endmodule
