module ICache #(
    parameter N = 32,
    parameter M = 32
) (
    input wire clk,
    input wire reset,

    // Processor interface
    input wire read_request,
    input wire [31:0] addr,
    output wire read_response,
    output wire [31:0] read_data,

    // Memory interface
    output wire memory_read_request,
    output wire [31:0] memory_addr,
    input wire memory_read_response,
    input wire [31:0] memory_read_data
);
    
endmodule
