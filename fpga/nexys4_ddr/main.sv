module top (
    input  logic clk,
    input  logic CPU_RESETN,

    input  logic rx,
    output logic tx,

    output logic [15:0]LED,
    inout  logic [7:0] JA,

    output logic [3:0] VGA_R,
    output logic [3:0] VGA_G,
    output logic [3:0] VGA_B,
    output logic VGA_HS,
    output logic VGA_VS
);

logic clk_o;

clk_wiz_0 clk_wiz_inst (
    .clk_in1  (clk),
    .resetn   (CPU_RESETN),
    .clk_out1 (clk_o),
    .locked   ()
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
    .LEDS_WIDTH             (16)
) SOC (
    .clk    (clk_o),
    .rst_n  (CPU_RESETN),
    .halt   (1'b0),
    .leds   (LED),
    .rx     (rx),
    .tx     (tx),
    .gpios  (JA),
    .VGA_R  (VGA_R),
    .VGA_G  (VGA_G),
    .VGA_B  (VGA_B),
    .VGA_HS (VGA_HS),
    .VGA_VS (VGA_VS)
);

endmodule
