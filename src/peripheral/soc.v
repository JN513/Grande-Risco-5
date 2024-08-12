module Risco_5_SOC #(
    parameter CLOCK_FREQ = 25000000,
    parameter BIT_RATE = 9600,
    parameter BOOT_ADDRESS = 32'h00000000,
    parameter MEMORY_SIZE = 4096,
    parameter MEMORY_FILE = "",
    parameter GPIO_WIDHT = 5
)(
    input wire clk,
    input wire reset,
    input wire rx,
    output wire tx,
    output wire [7:0] leds,
    inout [GPIO_WIDHT-1:0] gpios
);

endmodule
