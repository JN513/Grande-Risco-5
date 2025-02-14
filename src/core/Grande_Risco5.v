module Grande_Risco5 #(
    parameter BOOT_ADDRESS = 32'h00000000,
    parameter I_CACHE_SIZE = 'd32,
    parameter D_CACHE_SIZE = 'd32,
    parameter DATA_WIDTH   = 'd32,
    parameter ADDR_WIDTH   = 'd32
) (
    // Control signal
    input wire clk,
    input wire rst_n,
    input wire halt,

    // Memory BUS
    input  wire memory_response,
    output wire memory_read_request,
    output wire memory_write_request,

    input wire  [31:0] memory_read_data,
    output wire [31:0] memory_write_data,
    output wire [31:0] memory_addr,

    // Peripheral Bus
    input  wire peripheral_response,
    output wire peripheral_read_request,
    output wire peripheral_write_request,

    input wire  [31:0] peripheral_read_data,
    output wire [31:0] peripheral_write_data,
    output wire [31:0] peripheral_addr,

    input wire interruption
);

wire instruction_response, flush_bus, instruction_request;
wire [31:0] instruction_address, instruction_data;

wire data_read_request, data_write_request, data_memory_response;
wire [31:0] data_read_data, data_write_data, data_address;

Core #(
    .BOOT_ADDRESS(BOOT_ADDRESS)
) Core(
    .clk   (clk),
    .rst_n (rst_n),

    .flush_bus            (flush_bus),
    .instruction_request  (instruction_request),
    .instruction_response (instruction_response),
    .instruction_address  (instruction_address),
    .instruction_data     (instruction_data),

    .data_memory_response (data_memory_response),
    .data_address         (data_address),
    .data_memory_read     (data_read_request),
    .data_memory_write    (data_write_request),
    .write_data           (data_write_data),
    .read_data            (data_read_data)
);

ICache #(
    .CACHE_SIZE(I_CACHE_SIZE)
) ICache(
    .clk   (clk),
    .rst_n (rst_n),

    .flush_bus     (flush_bus),
    .read_request  (instruction_request),
    .addr          (instruction_address),
    .read_response (instruction_response),
    .read_data     (instruction_data),

    .memory_read_request  (i_cache_memory_read_request),
    .memory_read_response (i_cache_memory_response),
    .memory_addr          (i_cache_memory_addr),
    .memory_read_data     (i_cache_memory_read_data)
);

DCache #(
    .CACHE_SIZE(D_CACHE_SIZE)
) DCache(
    .clk   (clk),
    .rst_n (rst_n),

    .write_request (d_cache_write_request),
    .read_request  (d_cache_read_request),
    .addr          (data_address),
    .response      (d_cache_response),
    .read_data     (d_cache_read_data),
    .write_data    (data_write_data),


    .memory_read_request  (d_cache_memory_read_request),
    .memory_write_request (d_cache_memory_write_request),
    .memory_response      (d_cache_memory_response),
    .memory_addr          (d_cache_memory_addr),
    .memory_read_data     (d_cache_memory_read_data),
    .memory_write_data    (d_cache_memory_write_data)
);


// Bus logic for data memory and peripheral

wire d_cache_read_request, d_cache_write_request, d_cache_response;
wire [31:0] d_cache_read_data;

assign d_cache_read_request  = (~data_address[31]) ? data_read_request  : 1'b0;
assign d_cache_write_request = (data_address[31])  ? data_write_request : 1'b0;

assign peripheral_read_request  = (data_address[31]) ? data_read_request  : 1'b0;
assign peripheral_write_request = (data_address[31]) ? data_write_request : 1'b0;

assign data_memory_response = (data_address[31]) ? peripheral_response : d_cache_response;

assign peripheral_addr       = data_address;
assign peripheral_write_data = data_write_data;

assign data_read_data = (data_address[31]) ? peripheral_read_data : d_cache_read_data;

// Bus logic for memory

wire d_cache_memory_write_request, d_cache_memory_read_request, 
    d_cache_memory_response;

wire i_cache_memory_read_request, i_cache_memory_response;

wire [31:0] d_cache_memory_write_data, d_cache_memory_read_data,
    d_cache_memory_addr;

wire [31:0] i_cache_memory_read_data, i_cache_memory_addr;


Cache_request_Multiplexer #(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
) M1(
    .clk   (clk),
    .rst_n (rst_n),

    .i_cache_address       (i_cache_memory_addr),
    .i_cache_read_data     (i_cache_memory_read_data),
    .i_cache_read_request  (i_cache_memory_read_request),
    .i_cache_response      (i_cache_memory_response),

    .d_cache_address       (d_cache_memory_addr),
    .d_cache_read_data     (d_cache_memory_read_data),
    .d_cache_write_data    (d_cache_memory_write_data),
    .d_cache_read_request  (d_cache_memory_read_request),
    .d_cache_write_request (d_cache_memory_write_request),
    .d_cache_response      (d_cache_memory_response),

    .memory_read_request   (memory_read_request),
    .memory_write_request  (memory_write_request),
    .memory_addr           (memory_addr),
    .memory_write_data     (memory_write_data),
    .memory_response       (memory_response),
    .memory_read_data      (memory_read_data)
);

endmodule