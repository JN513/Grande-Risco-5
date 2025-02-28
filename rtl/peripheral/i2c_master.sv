`include "config.vh"

`ifdef I2C_ENABLE
module I2C_Master #(
    parameter CLK_FREQ = 100_000_000
) (
    input logic clk,
    input logic rst_n
);
    
endmodule
`endif