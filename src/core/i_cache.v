module ICache #(
    parameter N = 32,
    parameter M = 32
) (
    input wire clk,
    input wire reset,
    input wire read_request,
    input wire [31:0] addr,
    output wire read_response,
    output wire [31:0] data
);
    
endmodule
