module bmu_tb ();
    
logic clk, reset;

always #1 clk = ~clk;

initial begin
    $dumpfile("build/bmu_tb.vcd");
    $dumpvars(0, bmu_tb);

    clk = 0;
    reset = 0;

    #2

    $finish;
end

endmodule