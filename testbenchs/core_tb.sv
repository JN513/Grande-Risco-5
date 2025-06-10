`timescale 1ns/1ps
`default_nettype wire

module core_tb();

localparam CLOCK_FREQ = 100_000_000;
localparam CLK_PERIOD = 10; // 100 MHz clock


logic clk, rst_n;

logic [31:0] master_addr_o, master_data_o;
logic master_cyc, master_stb, master_we, master_ack;

Grande_Risco5 #(
    .BOOT_ADDRESS           (32'h00000000),
    .I_CACHE_SIZE           (1024),
    .D_CACHE_SIZE           (1024),
    .DATA_WIDTH             (32),
    .ADDR_WIDTH             (32)
    .BRANCH_PREDICTION_SIZE (512),
    .CLK_FREQ               (100_000_000)
) Processor (
    .clk          (clk),
    .rst_n        (rst_n),
    .halt         (1'b0),

    .cyc_o        (master_cyc),
    .stb_o        (master_stb),
    .we_o         (master_we),

    .addr_o       (master_addr_o),
    .data_o       (master_data_o),

    .ack_i        (master_ack),
    .data_i       (master_data),

    .interruption (1'b0)
);


Memory #(
    .MEMORY_FILE ("verification_tests/memory/generic.hex"),
    .MEMORY_SIZE (4096)
) Memory (
    .clk    (clk),
    
    .cyc_i  (master_cyc),
    .stb_i  (master_stb),
    .we_i   (master_we),

    .addr_i (master_addr_o),
    .data_i (master_data_o),
    .data_o (master_data),

    .ack_o  (master_ack)
);


initial begin
    $dumpfile("build/core.vcd");
    $dumpvars;

    clk = 1'b0;
    rst_n = 1'b0;
    #6
    rst_n = 1'b1;
    #1200

    $finish;
end

always #5 clk = ~clk; // Toggle clock every 5 ns for a 100 MHz clock

endmodule
