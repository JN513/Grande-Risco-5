`include "config.vh"

`ifdef SPI_ENABLE
module SPI_Master #(
    parameter CLK_FREQ = 100_000_000
) (
    input  logic clk,
    input  logic rst_n,

    output logic response_o,
    input  logic read_request_i,
    input  logic write_request_i,

    input  logic [31:0] address_i,
    input  logic [31:0] write_data_i,
    output logic [31:0] read_data_o

);
    
endmodule
`endif