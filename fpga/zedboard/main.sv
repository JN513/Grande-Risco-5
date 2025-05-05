module top (
    input  logic GCLK,
    input  logic BTNC,
    output logic [7:0]LED
);

Grande_Risco_5_SOC #(
    .CLOCK_FREQ       (50_000_000),
    .BAUD_RATE        (115200),
    .MEMORY_SIZE      (8192),
    .MEMORY_FILE      ("../../verification_tests/memory/led_test2.hex"),
    .GPIO_WIDTH       (6),
    .UART_BUFFER_SIZE (16),
    .I_CACHE_SIZE     (128),
    .D_CACHE_SIZE     (128)
) SOC (
    .clk   (GCLK),
    .rst_n (!BTNC),
    .leds  (LED),
    .rx    (),
    .tx    (),
    .gpios ()
);

endmodule
