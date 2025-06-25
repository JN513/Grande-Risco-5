module top (
    input  logic board_clk,
    input  logic rst_n,

    input  logic rxd,
    output logic txd,

    input  logic [4:0] btn,
    output logic [7:0] led,

    inout  logic [33:0] gpio

    `ifdef DRAM_ENABLE
    ,
    // DRAM interface
    inout  logic [31:0] ddram_dq,
    inout  logic [3:0]  ddram_dqs_n,
    inout  logic [3:0]  ddram_dqs_p,
    output logic [14:0] ddram_a,
    output logic [2:0]  ddram_ba,
    output logic        ddram_ras_n,
    output logic        ddram_cas_n,
    output logic        ddram_we_n,
    output logic        ddram_reset_n,
    output logic [0:0]  ddram_clk_p,
    output logic [0:0]  ddram_clk_n,
    output logic [0:0]  ddram_cke,
    output logic [0:0]  ddram_cs_n,
    output logic [3:0]  ddram_dm,
    output logic [0:0]  ddram_odt
    `endif
);

    // PLL and clock generation
    logic locked, sys_clk_100mhz;

    clk_wiz_0 clk_wiz_0_inst (
        .clk_out1 (sys_clk_100mhz), // 100 MHz system clock
        .resetn   (rst_n),          // Active low reset
        .locked   (locked),         // Locked signal
        .clk_in1  (board_clk)       // System clock - 50 MHz
    );

    Grande_Risco_5_SOC #(
        .CLOCK_FREQ             (100_000_000),
        .BAUD_RATE              (115200),
        .MEMORY_SIZE            (65536),
        .MEMORY_FILE            ("../../firmware/build/program.hex"),
        .GPIO_WIDTH             (6),
        .UART_BUFFER_SIZE       (188),
        .I_CACHE_SIZE           (4096),
        .D_CACHE_SIZE           (4096),
        .BRANCH_PREDICTION_SIZE (512),
        .VGA_WIDTH              (640),
        .VGA_HEIGHT             (480),
        .VGA_COLOR_DEPTH        (4),
        .LEDS_WIDTH             (8)
    ) SOC (
        .clk           (sys_clk_100mhz),
        .rst_n         (rst_n),
        .halt          (1'b0),
        .leds          (led),
        .rx            (rxd),
        .tx            (txd),
        .gpios         (),
        .VGA_R         (),
        .VGA_G         (),
        .VGA_B         (),
        .VGA_HS        (),
        .VGA_VS        ()

        `ifdef DRAM_ENABLE
        ,
        .ddram_dq      (ddram_dq),                      // 32 bits
        .ddram_dqs_n   (ddram_dqs_n),                   // 4 bits
        .ddram_dqs_p   (ddram_dqs_p),                   // 4
        .ddram_a       (ddram_a),                       // 15 bits
        .ddram_ba      (ddram_ba),                      // 3 bits
        .ddram_cas_n   (ddram_cas_n),                   // 1 bit
        .ddram_cke     (ddram_cke),                     // 1 bit
        .ddram_clk_n   (ddram_clk_n),                   // 1 bit
        .ddram_clk_p   (ddram_clk_p),                   // 1 bit
        .ddram_cs_n    (ddram_cs_n),                    // 1 bit
        .ddram_dm      (ddram_dm),                      // 4 bits
        .ddram_odt     (ddram_odt),                     // 1 bit
        .ddram_ras_n   (ddram_ras_n),                   // 1 bit
        .ddram_reset_n (ddram_reset_n),                 // 1 bit
        .ddram_we_n    (ddram_we_n)                     // 1 bit
        `endif
    );

endmodule
