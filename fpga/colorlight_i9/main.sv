module top (
    input  logic clk,
    input  logic rst_n,

    output logic rx,
    input  logic tx,

    output logic [7:0]led,
    inout  logic [5:0]gpios
);

Grande_Risco_5_SOC #(
    .CLOCK_FREQ             (25000000),
    .BAUD_RATE              (115200),
    .MEMORY_SIZE            (4096),
    .MEMORY_FILE            ("../../verification_tests/memory/led_test2.hex"),
    .GPIO_WIDTH             (6),
    .UART_BUFFER_SIZE       (16),
    .I_CACHE_SIZE           (72),
    .D_CACHE_SIZE           (72),
    .BRANCH_PREDICTION_SIZE (64),
    .VGA_WIDTH              (640),
    .VGA_HEIGHT             (480),
    .VGA_COLOR_DEPTH        (4),
    .LEDS_WIDTH             (8)
) SOC (
    .clk    (clk),
    .rst_n  (rst_n),
    .halt   (1'b0),
    .leds   (led),
    .rx     (rx),
    .tx     (tx),
    .gpios  (gpios),
    .VGA_R  (),
    .VGA_G  (),
    .VGA_B  (),
    .VGA_HS (),
    .VGA_VS ()
);


endmodule
