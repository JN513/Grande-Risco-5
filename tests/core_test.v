module core_tb();

reg clk, reset;

wire [31:0] instruction_address, instruction_data;
wire [31:0] data_address, data_write_data, data_read_data;
wire data_read, data_write;

always #1 clk = ~clk;

Grande_Risco5 Core(
    .clk(clk),
    .reset(reset),

    .instruction_address(instruction_address),
    .instruction_data(instruction_data),

    .data_address(data_address),
    .data_memory_read(data_read),
    .data_memory_write(data_write),
    .write_data(data_write_data),
    .read_data(data_read_data)
);

Memory #(
    .MEMORY_FILE("software/memory/generic.hex"),
    .MEMORY_SIZE(4096)
) instruction_memory(
    .clk(clk),
    .address(instruction_address),
    .read_data(instruction_data),
    .memory_read(1'b1),
    .memory_write(1'b0),
    .write_data(0)
);

Memory #(
    .MEMORY_FILE(""),
    .MEMORY_SIZE(4096)
) data_memory(
    .clk(clk),
    .address(data_address),
    .read_data(data_write_data),
    .memory_read(data_read),
    .memory_write(data_write),
    .write_data(data_write_data)
);

initial begin
    $dumpfile("build/core.vcd");
    $dumpvars;

    clk = 1'b0;
    reset = 1'b1;
    #6
    reset = 1'b0;
    #120

    $finish;
end

endmodule
