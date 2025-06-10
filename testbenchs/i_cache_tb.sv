`timescale 1ns / 1ps

module i_cache_tb ();
    
logic clk, reset;

always #1 clk = ~clk;

initial begin
    $dumpfile("build/i_cache_test.vcd");
    $dumpvars(0, i_cache_tb);

    clk = 0;
    reset = 1;
    #10 reset = 0;

    read_request = 1'b1;
    addr = 32'h0;

    #8

    addr = 32'h4;

    #8

    addr = 32'h8;

    #8

    addr = 32'h6;
    
    #4

    addr = 32'hE;

    #100 $finish;
end

logic memory_read_request, memory_read_response;
logic [31:0] memory_addr, memory_read_data;

logic read_request;
logic [31:0] addr;

logic read_response;
logic [31:0] read_data;

ICache #(
    .CACHE_SIZE(1024)
) Cache(
    .clk  (clk),
    .reset(reset),

    .read_request (read_request),
    .addr         (addr),
    .read_response(read_response),
    .read_data    (read_data),

    .memory_read_request (memory_read_request),
    .memory_read_response(memory_read_response),
    .memory_addr         (memory_addr),
    .memory_read_data    (memory_read_data)
);

Memory #(
    .MEMORY_FILE("utils/test_cache.hex"),
    .MEMORY_SIZE(4096)
) Memory(
    .clk         (clk),
    .memory_read (memory_read_request),
    .memory_write(1'b0),
    .address     (memory_addr),
    .write_data  (32'h0),
    .read_data   (memory_read_data),
    .response    (memory_read_response)
);

endmodule