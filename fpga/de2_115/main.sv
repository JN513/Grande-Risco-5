module top (
    input  logic clk,
    input  logic [3:0] btn,
    input  logic [17:0] sw,
    output logic [17:0] led,
    input  logic uart_rx,
    output logic uart_tx
);

Grande_Risco_5_SOC #(
    .CLOCK_FREQ       (50000000),
    .BAUD_RATE        (115200),
    .MEMORY_SIZE      (8192),
    .MEMORY_FILE      ("../../verification_tests/memory/led_test2.hex"),
    .GPIO_WIDHT       (6),
    .UART_BUFFER_SIZE (16),
    .I_CACHE_SIZE     (128),
    .D_CACHE_SIZE     (128)
) SOC (
    .clk   (clk),
    .rst_n (btn[0]),
    .leds  (led),
    .rx    (uart_rx),
    .tx    (uart_tx),
    .gpios ()
);

endmodule
