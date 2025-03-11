module top (
    input  logic clk,
    input  logic rst_n,
    output logic [7:0]led
);

Grande_Risco_5_SOC #(
    .CLOCK_FREQ             (25000000),
    .BAUD_RATE              (115200),
    .MEMORY_SIZE            (4096),
    .MEMORY_FILE            ("../../verification_tests/memory/led_test2.hex"),
    .GPIO_WIDHT             (6),
    .UART_BUFFER_SIZE       (16),
    .I_CACHE_SIZE           (72),
    .D_CACHE_SIZE           (72),
    .BRANCH_PREDICTION_SIZE (64)
) SOC (
    .clk   (clk),
    .rst_n (rst_n),
    .halt  (1'b0),
    .leds  (led),
    .rx    (),
    .tx    (),
    .gpios ()
);


endmodule
