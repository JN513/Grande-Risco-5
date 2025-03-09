`include "config.vh"

module Grande_Risco_5_SOC #(
    parameter CLOCK_FREQ             = 50000000,
    parameter BAUD_RATE              = 115200,
    parameter BOOT_ADDRESS           = 32'h00000000,
    parameter MEMORY_SIZE            = 4096,
    parameter MEMORY_FILE            = "verification_tests/memory/generic.hex",
    parameter GPIO_WIDHT             = 5,
    parameter I_CACHE_SIZE           = 256,
    parameter D_CACHE_SIZE           = 256,
    parameter DATA_WIDTH             = 32,
    parameter ADDR_WIDTH             = 32,
    parameter UART_BUFFER_SIZE       = 16,
    parameter BRANCH_PREDICTION_SIZE = 512,
    parameter VGA_WIDTH              = 640,
    parameter VGA_HEIGHT             = 480,
    parameter VGA_COLOR_DEPTH        = 4,
    parameter LEDS_WIDTH             = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic halt,

    input  logic rx,
    output logic tx,

    output logic [LEDS_WIDTH - 1:0] leds,
    inout [GPIO_WIDHT-1:0] gpios,

    output logic [VGA_COLOR_DEPTH - 1:0] VGA_R,
    output logic [VGA_COLOR_DEPTH - 1:0] VGA_G,
    output logic [VGA_COLOR_DEPTH - 1:0] VGA_B,
    output logic VGA_HS,
    output logic VGA_VS
);

logic memory_response, memory_read_request,
    memory_write_request;

logic [DATA_WIDTH-1:0] memory_read_data,
    memory_write_data, memory_addr;

logic peripheral_read_request, peripheral_write_request,
    peripheral_response;
logic [31:0] peripheral_addr, peripheral_read_data,
    peripheral_write_data;

logic peripheral_1_response, peripheral_2_response, peripheral_3_response, 
      peripheral_4_response, peripheral_5_response, peripheral_6_response, 
      peripheral_7_response, peripheral_8_response;

logic [31:0] peripheral_1_read_data, peripheral_2_read_data, peripheral_3_read_data,
             peripheral_4_read_data, peripheral_5_read_data, peripheral_6_read_data,
             peripheral_7_read_data, peripheral_8_read_data;

logic peripheral_1_write_request, peripheral_1_read_request;
logic peripheral_2_write_request, peripheral_2_read_request;
logic peripheral_3_write_request, peripheral_3_read_request;
logic peripheral_4_write_request, peripheral_4_read_request;
logic peripheral_5_write_request, peripheral_5_read_request;
logic peripheral_6_write_request, peripheral_6_read_request;
logic peripheral_7_write_request, peripheral_7_read_request;
logic peripheral_8_write_request, peripheral_8_read_request;

Grande_Risco5 #(
    .BOOT_ADDRESS           (BOOT_ADDRESS),
    .I_CACHE_SIZE           (I_CACHE_SIZE),
    .D_CACHE_SIZE           (D_CACHE_SIZE),
    .DATA_WIDTH             (DATA_WIDTH),
    .ADDR_WIDTH             (ADDR_WIDTH),
    .BRANCH_PREDICTION_SIZE (BRANCH_PREDICTION_SIZE)
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

Peripheral_BUS u_peripheral_bus (
    .addr_i                       (peripheral_addr),
    .write_request_i              (peripheral_write_request),
    .read_request_i               (peripheral_read_request),
    .response_o                   (peripheral_response),
    .read_data_o                  (peripheral_read_data),

    .peripheral_1_write_request_o (peripheral_1_write_request),
    .peripheral_1_read_request_o  (peripheral_1_read_request),
    .peripheral_1_response_i      (peripheral_1_response),
    .peripheral_1_read_data_i     (peripheral_1_read_data),

    .peripheral_2_write_request_o (peripheral_2_write_request),
    .peripheral_2_read_request_o  (peripheral_2_read_request),
    .peripheral_2_response_i      (peripheral_2_response),
    .peripheral_2_read_data_i     (peripheral_2_read_data),

    .peripheral_3_write_request_o (peripheral_3_write_request),
    .peripheral_3_read_request_o  (peripheral_3_read_request),
    .peripheral_3_response_i      (peripheral_3_response),
    .peripheral_3_read_data_i     (peripheral_3_read_data),

    .peripheral_4_write_request_o (peripheral_4_write_request),
    .peripheral_4_read_request_o  (peripheral_4_read_request),
    .peripheral_4_response_i      (peripheral_4_response),
    .peripheral_4_read_data_i     (peripheral_4_read_data),

    .peripheral_5_write_request_o (peripheral_5_write_request),
    .peripheral_5_read_request_o  (peripheral_5_read_request),
    .peripheral_5_response_i      (peripheral_5_response),
    .peripheral_5_read_data_i     (peripheral_5_read_data),

    .peripheral_6_write_request_o (peripheral_6_write_request),
    .peripheral_6_read_request_o  (peripheral_6_read_request),
    .peripheral_6_response_i      (peripheral_6_response),
    .peripheral_6_read_data_i     (peripheral_6_read_data),

    .peripheral_7_write_request_o (peripheral_7_write_request),
    .peripheral_7_read_request_o  (peripheral_7_read_request),
    .peripheral_7_response_i      (peripheral_7_response),
    .peripheral_7_read_data_i     (peripheral_7_read_data),

    .peripheral_8_write_request_o (peripheral_8_write_request),
    .peripheral_8_read_request_o  (peripheral_8_read_request),
    .peripheral_8_response_i      (peripheral_8_response),
    .peripheral_8_read_data_i     (peripheral_8_read_data)
);

`ifdef LED_ENABLE
LEDs #(
    .LEDS_WIDTH (LEDS_WIDTH)
) Leds (
    .clk             (clk),
    .rst_n           (rst_n),

    .read_request_i  (peripheral_1_read_request),
    .write_request_i (peripheral_1_write_request),
    .response_o      (peripheral_1_response),

    .address_i       (peripheral_addr),
    .write_data_i    (peripheral_write_data),
    .read_data_o     (peripheral_1_read_data),

    .leds            (leds)
);
`endif

`ifdef UART_ENABLE
UART #(
    .CLK_FREQ     (CLOCK_FREQ),
    .BIT_RATE     (BAUD_RATE),
    .BUFFER_SIZE  (UART_BUFFER_SIZE)
) UART (
    .clk          (clk),
    .rst_n        (rst_n),

    .rxd          (rx),
    .txd          (tx),

    .response_o   (peripheral_2_response),
    .rd_en_i      (peripheral_2_read_request),
    .wr_en_i      (peripheral_2_write_request),

    .address_i    (peripheral_addr),
    .write_data_i (peripheral_write_data),
    .read_data_o  (peripheral_2_read_data)
);
`endif

`ifdef GPIO_ENABLE
GPIOS #(
    .WIDHT (GPIO_WIDHT)
) Gpios (
    .clk             (clk),
    .rst_n           (rst_n),

    .response_o      (peripheral_3_response),
    .read_request_i  (peripheral_3_read_request),
    .write_request_i (peripheral_3_write_request),

    .address_i       (peripheral_addr),
    .write_data_i    (peripheral_write_data),
    .read_data_o     (peripheral_3_read_data),

    .gpios           (gpios)
);
`endif

`ifdef VGA_ENABLE
VGA #(
    .CLK_FREQ        (CLOCK_FREQ),
    .VGA_WIDTH       (VGA_WIDTH),
    .VGA_HEIGHT      (VGA_HEIGHT),
    .VGA_COLOR_DEPTH (VGA_COLOR_DEPTH)
) VGA (
    .clk             (clk),
    .rst_n           (rst_n),

    .response_o      (peripheral_4_response),
    .read_request_i  (peripheral_4_read_request),
    .write_request_i (peripheral_4_write_request),

    .address_i       (peripheral_addr),
    .write_data_i    (peripheral_write_data),
    .read_data_o     (peripheral_4_read_data),

    .vga_r           (VGA_R),
    .vga_g           (VGA_G),
    .vga_b           (VGA_B),
    .hsync           (VGA_HS),
    .vsync           (VGA_VS)
);
`else

assign VGA_R = 4'b0;
assign VGA_G = 4'b0;
assign VGA_B = 4'b0;
assign VGA_HS = 1'b0;
assign VGA_VS = 1'b0;

`endif

`ifdef SPI_ENABLE
SPI_Master #(
    .CLK_FREQ        (CLOCK_FREQ)
) SPI (
    .clk             (clk),
    .rst_n           (rst_n),

    .response_o      (peripheral_5_response),
    .read_request_i  (peripheral_5_read_request),
    .write_request_i (peripheral_5_write_request),

    .address_i       (peripheral_addr),
    .write_data_i    (peripheral_write_data),
    .read_data_o     (peripheral_5_read_data)
);
`endif

`ifdef I2C_ENABLE
I2C_Master #(
    .CLK_FREQ        (CLOCK_FREQ)
) I2C (
    .clk             (clk),
    .rst_n           (rst_n),

    .response_o      (peripheral_6_response),
    .read_request_i  (peripheral_6_read_request),
    .write_request_i (peripheral_6_write_request),

    .address_i       (peripheral_addr),
    .write_data_i    (peripheral_write_data),
    .read_data_o     (peripheral_6_read_data)
);
`endif

`ifdef TIMER_ENABLE
Timer #(
    .CLK_FREQ        (CLOCK_FREQ)
) Timer (
    .clk             (clk),
    .rst_n           (rst_n),

    .response_o      (peripheral_7_response),
    .read_request_i  (peripheral_7_read_request),
    .write_request_i (peripheral_7_write_request),

    .address_i       (peripheral_addr),
    .write_data_i    (peripheral_write_data),
    .read_data_o     (peripheral_7_read_data)
);
`endif

`ifdef DRAM_ENABLE
DRAM_Controller #(
    .CLK_FREQ (CLOCK_FREQ)
) DRAM (
    .clk             (clk),
    .rst_n           (rst_n),

    .response_o      (peripheral_8_response),
    .read_request_i  (peripheral_8_read_request),
    .write_request_i (peripheral_8_write_request),

    .address_i       (peripheral_addr),
    .write_data_i    (peripheral_write_data),
    .read_data_o     (peripheral_8_read_data)
);
`endif

endmodule
