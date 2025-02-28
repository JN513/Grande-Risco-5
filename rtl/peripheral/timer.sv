`include "config.vh"

`ifdef TIMER_ENABLE
module Timer #(
    parameter CLK_FREQ = 100_000_000
) (
    input logic clk,
    input logic rst_n
);
    
endmodule
`endif