module top (
    input  logic clk,
    input  logic reset,
    input  logic rx,
    output logic tx,
    output logic [3:0]led,
    inout [5:0]gpios
);

logic [7:0] leds;

assign led = leds[3:0];

Grande_Risco_5_SOC #(
    .CLOCK_FREQ       (100000000),
    .BAUD_RATE        (115200),
    .MEMORY_SIZE      (4096),
    .MEMORY_FILE      ("../../verification_tests/memory/led_test.hex"),
    .GPIO_WIDHT       (6),
    .UART_BUFFER_SIZE (16)
) SOC (
    .clk   (clk),
    .rst_n (!reset),
    .leds  (leds),
    .rx    (rx),
    .tx    (tx),
    .gpios (gpios)
);


endmodule
