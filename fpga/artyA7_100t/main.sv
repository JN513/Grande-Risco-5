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
    .CLOCK_FREQ             (100000000),
    .BAUD_RATE              (115200),
    .MEMORY_SIZE            (4096),
    .MEMORY_FILE            ("../../verification_tests/memory/led_test2.hex"),
    .GPIO_WIDTH             (6),
    .UART_BUFFER_SIZE       (16),
    .I_CACHE_SIZE           (2048),
    .D_CACHE_SIZE           (1024),
    .BRANCH_PREDICTION_SIZE (512),
    .VGA_WIDTH              (640),
    .VGA_HEIGHT             (480),
    .VGA_COLOR_DEPTH        (4),
    .LEDS_WIDTH             (16)
) SOC (
    .clk    (clk),
    .rst_n  (!reset),
    .leds   (leds),
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
