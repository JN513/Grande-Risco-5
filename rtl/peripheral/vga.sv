`include "config.vh"

`ifdef VGA_ENABLE
module VGA #(
    parameter CLK_FREQ = 100_000_000
) (
    input logic clk,
    input logic rst_n
);
    
endmodule
`endif