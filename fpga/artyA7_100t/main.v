module top (
    input wire clk,
    input wire reset,
    input wire rx,
    output wire tx,
    output wire [3:0]led,
    inout [5:0]gpios
);

wire reset_o;
wire [7:0] leds;

assign led = leds[3:0];

ResetBootSystem #(
    .CYCLES(20)
) ResetBootSystem(
    .clk     (clk),
    .reset_o (reset_o)
);

Grande_Risco_5_SOC #(
    .CLOCK_FREQ       (100000000),
    .BAUD_RATE        (115200),
    .MEMORY_SIZE      (4096),
    .MEMORY_FILE      ("../../verification_tests/memory/led_test.hex"),
    .GPIO_WIDHT       (6),
    .UART_BUFFER_SIZE (16)
) SOC (
    .clk   (clk),
    .reset (reset_o),
    .leds  (leds),
    .rx    (),
    .tx    (),
    .gpios ()
);


endmodule
