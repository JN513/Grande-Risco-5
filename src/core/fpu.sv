`ifdef ENABLE_FPU

module FPU (
    input  logic clk,
    input  logic rst_n,
    input  logic [31:0] input_a,
    input  logic [31:0] input_b,
    input  logic [2:0] op,
    output logic [31:0] out
);
    
endmodule

`endif
