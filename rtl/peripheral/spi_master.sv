`include "config.vh"

`ifdef SPI_ENABLE
module SPI_Master #(
    parameter CLK_FREQ = 100_000_000
) (
    input logic clk,
    input logic rst_n
);
    
endmodule
`endif