module top (
    input wire clk,
    input wire reset,
    input wire rx,
    output wire tx,
    output wire [3:0]led,
    inout [5:0]gpios
);

wire reset_o;
wire [7:0] leds;

assign led = leds[3:0];

ResetBootSystem #(
    .CYCLES(20)
) ResetBootSystem(
    .clk(clk),
    .reset_o(reset_o)
);

Risco_5_SOC #(
    .CLOCK_FREQ(100000000),
    .BIT_RATE(115200),
    .MEMORY_SIZE(2048),
    .MEMORY_FILE("../../software/memory/fpga_test_3.hex"),
    .GPIO_WIDHT(6)
) SOC(
    .clk(clk),
    .reset(reset_o),
    .leds(leds),
    .rx(rx),
    .tx(tx),
    .gpios(gpios)
);


endmodule
