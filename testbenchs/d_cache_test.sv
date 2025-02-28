module d_cache_tb ();
    
logic clk, reset;

always #1 clk = ~clk;

initial begin
    $dumpfile("build/d_cache_test.vcd");
    $dumpvars(0, d_cache_tb);

    clk = 0;
    reset = 1;
    write_request = 0;
    write_data = 0;
    #10 reset = 0;

    read_request = 1'b1;
    addr = 32'h0;

    #8

    addr = 32'h4;

    #8

    addr = 32'h8;

    #8

    read_request = 1'b0;
    addr = 32'h14;
    write_data = 32'h6a6a6a6a;
    write_request = 32'h1;

    #12

    write_request = 0;
    read_request = 1'b1;

    #12

    addr = 32'h4;
    write_request = 1'b1;
    read_request = 1'b0;
    write_data = 32'h736F6669;

    #12

    write_request = 1'b0;
    read_request = 1'b1;

    #12

    #1000 $finish;
end

wire memory_read_request, memory_response, memory_write_request;
wire [31:0] memory_addr, memory_read_data;

reg read_request, write_request;
reg [31:0] addr, write_data;

wire read;
wire [31:0] read_data, memory_write_data;

DCache #(
    .CACHE_SIZE(1024)
) Cache(
    .clk  (clk),
    .reset(reset),

    .write_request (write_request),
    .read_request  (read_request),
    .addr          (addr),
    .response      (response),
    .read_data     (read_data),
    .write_data    (write_data),


    .memory_read_request  (memory_read_request),
    .memory_write_request (memory_write_request),
    .memory_response      (memory_response),
    .memory_addr          (memory_addr),
    .memory_read_data     (memory_read_data),
    .memory_write_data    (memory_write_data)
);

Memory #(
    .MEMORY_FILE("utils/test_cache.hex"),
    .MEMORY_SIZE(4096)
) Memory(
    .clk         (clk),
    .memory_read (memory_read_request),
    .memory_write(memory_write_request),
    .address     (memory_addr),
    .write_data  (memory_write_data),
    .read_data   (memory_read_data),
    .response    (memory_response)
);

endmodule