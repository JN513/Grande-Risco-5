module top (
    input wire clk,
    input wire reset,
    output wire [7:0]led
);

wire reset_o;

ResetBootSystem #(
    .CYCLES(20)
) ResetBootSystem(
    .clk     (clk),
    .reset_o (reset_o)
);

Grande_Risco_5_SOC #(
    .CLOCK_FREQ       (25000000),
    .BIT_RATE         (115200),
    .MEMORY_SIZE      (4096),
    .MEMORY_FILE      ("../../verification_tests/memory/led_test.hex"),
    .GPIO_WIDHT       (6),
    .UART_BUFFER_SIZE (16),
    .I_CACHE_SIZE     (72),
    .D_CACHE_SIZE     (72)
) SOC (
    .clk   (clk),
    .reset (reset_o),
    .leds  (led),
    .rx    (),
    .tx    (),
    .gpios ()
);


endmodule
