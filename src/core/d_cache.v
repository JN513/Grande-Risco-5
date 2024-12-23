module DCache #(
    parameter N = 32,
    parameter M = 32
) (
    input wire clk,
    input wire reset,

    // Processor interface
    input wire read_request,
    input wire write_request,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    output wire response,
    output wire [31:0] read_data,

    // Memory interface
    output wire memory_read_request,
    output wire memory_write_request,
    output wire [31:0] memory_addr,
    output wire [31:0] memory_write_data,
    input wire memory_response,
    input wire [31:0] memory_read_data
);
    
endmodule
