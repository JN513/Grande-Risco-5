module Grande_Risco_5_SOC #(
    parameter CLOCK_FREQ       = 25000000,
    parameter BAUD_RATE        = 9600,
    parameter BOOT_ADDRESS     = 32'h00000000,
    parameter MEMORY_SIZE      = 4096,
    parameter MEMORY_FILE      = "",
    parameter GPIO_WIDHT       = 5,
    parameter I_CACHE_SIZE     = 1024,
    parameter D_CACHE_SIZE     = 1024,
    parameter DATA_WIDTH       = 32,
    parameter ADDR_WIDTH       = 32,
    parameter UART_BUFFER_SIZE = 16
)(
    input  logic clk,
    input  logic rst_n,
    input  logic halt,

    input  logic rx,
    output logic tx,

    output logic [7:0] leds,
    inout [GPIO_WIDHT-1:0] gpios
);

logic memory_response, memory_read_request,
    memory_write_request;

logic [DATA_WIDTH-1:0] memory_read_data,
    memory_write_data, memory_addr;

Grande_Risco5 #(
    .BOOT_ADDRESS (BOOT_ADDRESS),
    .I_CACHE_SIZE (I_CACHE_SIZE),
    .D_CACHE_SIZE (D_CACHE_SIZE),
    .DATA_WIDTH   (DATA_WIDTH),
    .ADDR_WIDTH   (ADDR_WIDTH)
) Processor(
    .clk   (clk),
    .rst_n (rst_n),
    .halt  (halt),

    .memory_response      (memory_response),
    .memory_read_request  (memory_read_request),
    .memory_write_request (memory_write_request),
    .memory_read_data     (memory_read_data),
    .memory_write_data    (memory_write_data),
    .memory_addr          (memory_addr),

    .peripheral_response      (peripheral_response),
    .peripheral_read_request  (peripheral_read_request),
    .peripheral_write_request (peripheral_write_request),
    .peripheral_read_data     (peripheral_read_data),
    .peripheral_write_data    (peripheral_write_data),
    .peripheral_addr          (peripheral_addr),

    .interruption (1'b0)
);

Memory #(
    .MEMORY_FILE (MEMORY_FILE),
    .MEMORY_SIZE (MEMORY_SIZE)
) Memory(
    .clk          (clk),
    .address      (memory_addr),
    .read_data    (memory_read_data),
    .memory_read  (memory_read_request),
    .memory_write (memory_write_request),
    .write_data   (memory_write_data),
    .response     (memory_response)
);

logic peripheral_read_request, peripheral_write_request,
    peripheral_response;
logic [31:0] peripheral_addr, peripheral_read_data,
    peripheral_write_data;

LEDs #(
    .DEVICE_START_ADDRESS (32'h00001000),
    .DEVICE_FINAL_ADDRESS (32'h00001002)
) P1(
    .clk        (clk),
    .rst_n      (rst_n),
    .read       (peripheral_read_request),
    .write      (peripheral_write_request),
    .address    (peripheral_addr),
    .write_data (peripheral_write_data),
    .read_data  (peripheral_read_data),
    .response   (peripheral_response),
    .leds       (leds)
);

endmodule
