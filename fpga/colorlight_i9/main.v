module top (
    input wire clk,
    input wire reset,
    output wire [7:0]led
);

wire reset_o;

ResetBootSystem #(
    .CYCLES(20)
) ResetBootSystem(
    .clk(clk),
    .reset_o(reset_o)
);

wire [31:0] instruction_address, instruction_data;
wire [31:0] data_address, data_write_data, data_read_data;
wire data_read, data_write;

Grande_Risco5 Core(
    .clk(clk),
    .reset(reset_o),

    .instruction_response(1'b1),
    .instruction_address(instruction_address),
    .instruction_data(instruction_data),

    .data_memory_response(1'b1),
    .data_address(data_address),
    .data_memory_read(data_read),
    .data_memory_write(data_write),
    .write_data(data_write_data),
    .read_data(data_read_data)
);

LEDs Leds(
    .clk(clk),
    .reset(reset_o),
    .read(data_read),
    .write(data_write),
    .write_data(data_write_data),
    .read_data(),
    .address(data_address),
    .leds(led)
);

Memory #(
    .MEMORY_FILE("../../software/memory/addi.hex"),
    .MEMORY_SIZE(1024)
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
    .MEMORY_SIZE(1024)
) data_memory(
    .clk(clk),
    .address(data_address),
    .read_data(data_read_data),
    .memory_read(data_read),
    .memory_write(data_write),
    .write_data(data_write_data)
);
endmodule
