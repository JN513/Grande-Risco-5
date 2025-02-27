`timescale 1ns/1ps
module top();

reg clk, reset;
wire rx, tx;
wire [7:0] led;

always #1 clk = ~clk;

Grande_Risco_5_SOC #(
    .CLOCK_FREQ       (25000000),
    .BAUD_RATE        (115200),
    .MEMORY_SIZE      (4096),
    .MEMORY_FILE      ("verification_tests/memory/generic.hex"),
    .GPIO_WIDHT       (6),
    .UART_BUFFER_SIZE (16),
    .I_CACHE_SIZE     (64),
    .D_CACHE_SIZE     (64)
) SOC (
    .clk   (clk),
    .rst_n (reset),
    .leds  (led),
    .rx    (),
    .tx    (),
    .gpios (),
    .halt  ()
);

initial begin
    $dumpfile("build/soc.vcd");
    $dumpvars;
    // Monitor leds signal
    $monitor("leds = %h", led);

    clk = 1'b0;
    reset = 1'b0;
    #6
    reset = 1'b1;
    //#560

    #1200

    $finish;
end

endmodule
