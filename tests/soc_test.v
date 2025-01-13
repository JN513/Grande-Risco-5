module soc_tb();

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
    .UART_BUFFER_SIZE (16)
) SOC (
    .clk   (clk),
    .reset (reset),
    .leds  (led),
    .rx    (),
    .tx    (),
    .gpios ()
);

initial begin
    $dumpfile("build/soc.vcd");
    $dumpvars;

    clk = 1'b0;
    reset = 1'b1;
    #6
    reset = 1'b0;
    //#560

    #1200

    $finish;
end

endmodule
