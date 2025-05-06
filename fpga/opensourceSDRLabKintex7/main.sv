module top (
    input  logic clk,
    input  logic rst_n,

    input  logic rxd,
    output logic txd,

    output logic [7:0]led
);


Grande_Risco_5_SOC #(
    .CLOCK_FREQ             (50000000),
    .BAUD_RATE              (115200),
    .MEMORY_SIZE            (16384),
    .MEMORY_FILE            ("../../firmware/build/program.hex"),
    .GPIO_WIDTH             (6),
    .UART_BUFFER_SIZE       (32),
    .I_CACHE_SIZE           (2048),
    .D_CACHE_SIZE           (1024),
    .BRANCH_PREDICTION_SIZE (512),
    .VGA_WIDTH              (640),
    .VGA_HEIGHT             (480),
    .VGA_COLOR_DEPTH        (4),
    .LEDS_WIDTH             (8)
) SOC (
    .clk    (clk),
    .rst_n  (rst_n),
    .halt   (1'b0),
    .leds   (led),
    .rx     (rxd),
    .tx     (txd),
    .gpios  (),
    .VGA_R  (),
    .VGA_G  (),
    .VGA_B  (),
    .VGA_HS (),
    .VGA_VS ()
);

endmodule
