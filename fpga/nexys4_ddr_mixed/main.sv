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

Grande_Risco_5_SOC #(
    .CLOCK_FREQ             (50000000),
    .BAUD_RATE              (115200),
    .MEMORY_SIZE            (16384),
    .MEMORY_FILE            ("../../verification_tests/memory/led_test2.hex"),
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

always_ff @(posedge clk) begin : CLOCK_DIVIDER
    if(!CPU_RESETN)
        clk_o <= 1'b0;
    else
        clk_o <= ~clk_o;
end

endmodule
