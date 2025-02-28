`include "config.vh"

`ifdef DRAM_ENABLE
module DRAM_Controller #(
    parameter CLK_FREQ = 100_000_000
) (
    input logic clk,
    input logic rst_n
);
    
endmodule
`endif