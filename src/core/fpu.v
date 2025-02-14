`ifdef ENABLE_FPU

module FPU (
    input wire clk,
    input wire rst_n,
    input wire [31:0] input_a,
    input wire [31:0] input_b,
    input wire [2:0] op,
    output wire [31:0] out
);
    
endmodule

`endif
