module top (
    input  wire clk,
    input  wire CPU_RESETN,
    input  wire rx,
    output wire tx,
    output wire [7:0]LED,
    inout [7:0] JA
);

reg clk_o;

Grande_Risco_5_SOC #(
    .CLOCK_FREQ       (50000000),
    .BAUD_RATE        (115200),
    .MEMORY_SIZE      (8192),
    .MEMORY_FILE      ("../../verification_tests/memory/led_test.hex"),
    .GPIO_WIDHT       (6),
    .UART_BUFFER_SIZE (16),
    .I_CACHE_SIZE     (64),
    .D_CACHE_SIZE     (64)
) SOC (
    .clk   (clk_o),
    .reset (~CPU_RESETN),
    .leds  (LED),
    .rx    (),
    .tx    (),
    .gpios ()
);

always @(posedge clk) begin
    if(!CPU_RESETN) begin
        clk_o <= 1'b0;
    end else begin
        clk_o <= ~clk_o;
    end
end

endmodule
