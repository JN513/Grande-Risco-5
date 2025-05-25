module core_tb();

logic clk, reset;

logic memory_response, memory_read_request,
    memory_write_request;

logic [31:0] memory_read_data,
    memory_write_data, memory_addr;

Grande_Risco5 #(
    .BOOT_ADDRESS (32'h00000000),
    .I_CACHE_SIZE (1024),
    .D_CACHE_SIZE (1024),
    .DATA_WIDTH   (32),
    .ADDR_WIDTH   (32)
) Grande_Risco5 (
    .clk   (clk),
    .reset (reset),
    .halt  (1'b0),

    .memory_response      (memory_response),
    .memory_read_request  (memory_read_request),
    .memory_write_request (memory_write_request),
    .memory_read_data     (memory_read_data),
    .memory_write_data    (memory_write_data),
    .memory_addr          (memory_addr),

    .peripheral_response      (),
    .peripheral_read_request  (),
    .peripheral_write_request (),
    .peripheral_read_data     (),
    .peripheral_write_data    (),
    .peripheral_addr          (),

    .interruption (1'b0)
);

Memory #(
    .MEMORY_FILE ("verification_tests/memory/generic.hex"),
    .MEMORY_SIZE (4096)
) Memory(
    .clk          (clk),
    .address      (memory_addr),
    .read_data    (memory_read_data),
    .memory_read  (memory_read_request),
    .memory_write (memory_write_request),
    .write_data   (memory_write_data),
    .response     (memory_response)
);


initial begin
    $dumpfile("build/core.vcd");
    $dumpvars;

    clk = 1'b0;
    reset = 1'b1;
    #6
    reset = 1'b0;
    #1200

    $finish;
end

always #1 clk = ~clk;

endmodule
