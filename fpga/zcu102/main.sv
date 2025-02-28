module top (
    input  logic GCLK,
    input  logic BTNC,
    output logic [7:0]LED
);

logic clk_o;

Grande_Risco_5_SOC #(
    .CLOCK_FREQ       (50000000),
    .BAUD_RATE        (115200),
    .MEMORY_SIZE      (8192),
    .MEMORY_FILE      ("../../verification_tests/memory/led_test2.hex"),
    .GPIO_WIDHT       (6),
    .UART_BUFFER_SIZE (16),
    .I_CACHE_SIZE     (128),
    .D_CACHE_SIZE     (128)
) SOC (
    .clk   (clk_o),
    .rst_n (!BTNC),
    .leds  (LED),
    .rx    (),
    .tx    (),
    .gpios ()
);

always_ff @(posedge GCLK) begin : CLOCK_DIVIDER
    if(!CPU_RESETN)
        clk_o <= 1'b0;
    else
        clk_o <= ~clk_o;
end

endmodule
