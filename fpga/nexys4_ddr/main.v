module top (
    input  wire clk,
    input  wire CPU_RESETN,
    input  wire rx,
    output wire tx,
    output wire [7:0]LED,
    output wire [7:0] JA
);

reg clk_o;

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
    .rst_n (CPU_RESETN),
    .leds  (LED),
    .rx    (),
    .tx    (),
    .gpios ()
);

reg [7:0] leds;
reg [31:0] counter;

assign JA = leds;

always @(posedge clk) begin
    if(!CPU_RESETN) begin
        clk_o <= 1'b0;
        leds <= 8'b0;
    end else begin
        clk_o <= ~clk_o;

        if(counter <= 50_000_000) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
            leds <= leds + 1;
        end

    end
end

endmodule
