module top (
    input  logic sys_clk,
    input  logic rst_n,

    input  logic rxd,
    output logic txd,

    input  logic [4:0] btn,
    output logic [7:0] led,

    inout  logic [33:0] gpio
);

    logic ddr3_clk, ddr3_ref_clk, user_clk, locked;

    clk_wiz_0 clk_wiz_0_inst (
        .clk_out1 (ddr3_clk),     // DDR3 clock - 800 MHz
        .clk_out2 (ddr3_ref_clk), // DDR3 reference clock - 200 MHz
        .clk_out3 (user_clk),     // User clock - 100 MHz
        .resetn   (rst_n),        // Active low reset
        .locked   (locked),       // Locked signal
        .clk_in1  (sys_clk)       // System clock - 50 MHz
    );

    Grande_Risco_5_SOC #(
        .CLOCK_FREQ             (120_000_000),
        .BAUD_RATE              (115200),
        .MEMORY_SIZE            (65536),
        .MEMORY_FILE            ("../../firmware/build/program.hex"),
        .GPIO_WIDTH             (6),
        .UART_BUFFER_SIZE       (32),
        .I_CACHE_SIZE           (4096),
        .D_CACHE_SIZE           (4096),
        .BRANCH_PREDICTION_SIZE (512),
        .VGA_WIDTH              (640),
        .VGA_HEIGHT             (480),
        .VGA_COLOR_DEPTH        (4),
        .LEDS_WIDTH             (8)
    ) SOC (
        .clk    (user_clk),
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
