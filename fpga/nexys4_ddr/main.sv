module top (
    input  logic clk,
    input  logic CPU_RESETN,
    input  logic rx,
    output logic tx,
    output logic [7:0]LED,
    output logic [7:0] JA
);

logic clk_o;

Grande_Risco_5_SOC #(
    .CLOCK_FREQ             (50000000),
    .BAUD_RATE              (115200),
    /*.MEMORY_SIZE            (16384),
    .MEMORY_FILE            ("../../verification_tests/memory/led_test2.hex"),
    .GPIO_WIDHT             (6),
    .UART_BUFFER_SIZE       (16),
    .I_CACHE_SIZE           (2048),
    .D_CACHE_SIZE           (1024),
    .BRANCH_PREDICTION_SIZE (512)*/
    .MEMORY_SIZE            (4096),
    .MEMORY_FILE            ("../../verification_tests/memory/led_test2.hex"),
    .GPIO_WIDHT             (6),
    .UART_BUFFER_SIZE       (16),
    .I_CACHE_SIZE           (72),
    .D_CACHE_SIZE           (72),
    .BRANCH_PREDICTION_SIZE (64)
) SOC (
    .clk   (clk_o),
    .rst_n (CPU_RESETN),
    .leds  (LED),
    .rx    (),
    .tx    (),
    .gpios ()
);

always_ff @(posedge clk) begin : CLOCK_DIVIDER
    if(!CPU_RESETN)
        clk_o <= 1'b0;
    else
        clk_o <= ~clk_o;
end

endmodule
