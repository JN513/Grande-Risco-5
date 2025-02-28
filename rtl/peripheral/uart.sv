module UART #(
    parameter CLK_FREQ     = 25000000,
    parameter BIT_RATE     = 115200,
    parameter PAYLOAD_BITS = 8,
    parameter BUFFER_SIZE  = 32,
    parameter WORD_SIZE_B  = 1
) (
    input  logic clk,
    input  logic rst_n,

    input  logic rx,
    output logic tx,

    input  logic read_request,
    input  logic write_request,
    output logic read_response,
    output logic write_response,

    input  logic [31:0] address,
    input  logic [31:0] write_data,
    output logic [31:0] read_data
);


endmodule
