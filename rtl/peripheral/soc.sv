`include "config.vh"

module Grande_Risco_5_SOC #(
    parameter CLOCK_FREQ             = 50_000_000,
    parameter BAUD_RATE              = 2_500_000,
    parameter BOOT_ADDRESS           = 32'h00000000,
    parameter MEMORY_SIZE            = 4096,
    parameter MEMORY_FILE            = "verification_tests/memory/generic.hex",
    parameter GPIO_WIDTH             = 5,
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
    inout        [GPIO_WIDTH-1:0]   gpios,

    output logic [VGA_COLOR_DEPTH - 1:0] VGA_R,
    output logic [VGA_COLOR_DEPTH - 1:0] VGA_G,
    output logic [VGA_COLOR_DEPTH - 1:0] VGA_B,
    output logic VGA_HS,
    output logic VGA_VS
);

logic [31:0] master_addr_o, master_data_o;

logic master_cyc, master_stb, master_we, master_ack;

logic peripheral_cyc, peripheral_stb, peripheral_ack;
logic memory_cyc, memory_stb, memory_ack;
logic [31:0] peripheral_data, memory_data, master_data;

assign master_data    = (master_addr_o[31]) ? peripheral_data : memory_data;
assign master_ack     = (master_addr_o[31]) ? peripheral_ack : memory_ack;
assign peripheral_cyc = (master_addr_o[31]) ? master_cyc : 1'b0;
assign peripheral_stb = (master_addr_o[31]) ? master_stb : 1'b0;
assign memory_cyc     = (master_addr_o[31]) ? 1'b0 : master_cyc;
assign memory_stb     = (master_addr_o[31]) ? 1'b0 : master_stb;



Grande_Risco5 #(
    .BOOT_ADDRESS           (BOOT_ADDRESS),
    .I_CACHE_SIZE           (I_CACHE_SIZE),
    .D_CACHE_SIZE           (D_CACHE_SIZE),
    .DATA_WIDTH             (DATA_WIDTH),
    .ADDR_WIDTH             (ADDR_WIDTH),
    .BRANCH_PREDICTION_SIZE (BRANCH_PREDICTION_SIZE),
    .CLK_FREQ               (CLOCK_FREQ)
) Processor (
    .clk               (clk),
    .rst_n             (rst_n),
    .halt              (halt),

    .cyc_o             (master_cyc),
    .stb_o             (master_stb),
    .we_o              (master_we),

    .addr_o            (master_addr_o),
    .data_o            (master_data_o),

    .ack_i             (master_ack),
    .data_i            (master_data),

    .interruption      (1'b0),

    // JTAG interface
    .jtag_we_en_i      (1'b0),  // JTAG write enable
    .jtag_addr_i       (5'b0),  // JTAG address
    .jtag_data_i       (32'b0), // JTAG data input
    .jtag_data_o       (),      // JTAG data output

    .jtag_halt_flag_i  (1'b0), // JTAG halt flag
    .jtag_reset_flag_i (1'b0)  // JTAG reset flag
);

Memory #(
    .MEMORY_FILE (MEMORY_FILE),
    .MEMORY_SIZE (MEMORY_SIZE)
) Memory (
    .clk    (clk),
    
    .cyc_i  (memory_cyc),
    .stb_i  (memory_stb),
    .we_i   (master_we),

    .addr_i (master_addr_o),
    .data_i (master_data_o),
    .data_o (memory_data),

    .ack_o  (memory_ack)
);

logic peripheral_1_cyc_o, peripheral_1_stb_o, peripheral_1_we_o, peripheral_1_ack_i;
logic peripheral_2_cyc_o, peripheral_2_stb_o, peripheral_2_we_o, peripheral_2_ack_i;
logic peripheral_3_cyc_o, peripheral_3_stb_o, peripheral_3_we_o, peripheral_3_ack_i;
logic peripheral_4_cyc_o, peripheral_4_stb_o, peripheral_4_we_o, peripheral_4_ack_i;
logic peripheral_5_cyc_o, peripheral_5_stb_o, peripheral_5_we_o, peripheral_5_ack_i;
logic peripheral_6_cyc_o, peripheral_6_stb_o, peripheral_6_we_o, peripheral_6_ack_i;
logic peripheral_7_cyc_o, peripheral_7_stb_o, peripheral_7_we_o, peripheral_7_ack_i;
logic peripheral_8_cyc_o, peripheral_8_stb_o, peripheral_8_we_o, peripheral_8_ack_i;

logic [31:0] peripheral_1_data_i, peripheral_2_data_i, peripheral_3_data_i, peripheral_4_data_i;
logic [31:0] peripheral_5_data_i, peripheral_6_data_i, peripheral_7_data_i, peripheral_8_data_i;

Peripheral_BUS peripheral_bus (
    // Wishbone Master Interface
    .clk    (clk),
    .rst_n  (rst_n),
    
    .cyc_i  (peripheral_cyc),
    .stb_i  (peripheral_stb),
    .we_i   (master_we),

    .addr_i (master_addr_o),
    .data_i (master_data_o),
    .data_o (peripheral_data),

    .ack_o  (peripheral_ack),

    // Wishbone Peripheral Interface
    .peripheral_1_cyc_o  (peripheral_1_cyc_o),
    .peripheral_1_stb_o  (peripheral_1_stb_o),
    .peripheral_1_we_o   (peripheral_1_we_o),
    .peripheral_1_ack_i  (peripheral_1_ack_i),
    .peripheral_1_data_i (peripheral_1_data_i),

    .peripheral_2_cyc_o  (peripheral_2_cyc_o),
    .peripheral_2_stb_o  (peripheral_2_stb_o),
    .peripheral_2_we_o   (peripheral_2_we_o),
    .peripheral_2_ack_i  (peripheral_2_ack_i),
    .peripheral_2_data_i (peripheral_2_data_i),

    .peripheral_3_cyc_o  (peripheral_3_cyc_o),
    .peripheral_3_stb_o  (peripheral_3_stb_o),
    .peripheral_3_we_o   (peripheral_3_we_o),
    .peripheral_3_ack_i  (peripheral_3_ack_i),
    .peripheral_3_data_i (peripheral_3_data_i),

    .peripheral_4_cyc_o  (peripheral_4_cyc_o),
    .peripheral_4_stb_o  (peripheral_4_stb_o),
    .peripheral_4_we_o   (peripheral_4_we_o),
    .peripheral_4_ack_i  (peripheral_4_ack_i),
    .peripheral_4_data_i (peripheral_4_data_i),

    .peripheral_5_cyc_o  (peripheral_5_cyc_o),
    .peripheral_5_stb_o  (peripheral_5_stb_o),
    .peripheral_5_we_o   (peripheral_5_we_o),
    .peripheral_5_ack_i  (peripheral_5_ack_i),
    .peripheral_5_data_i (peripheral_5_data_i),

    .peripheral_6_cyc_o  (peripheral_6_cyc_o),
    .peripheral_6_stb_o  (peripheral_6_stb_o),
    .peripheral_6_we_o   (peripheral_6_we_o),
    .peripheral_6_ack_i  (peripheral_6_ack_i),
    .peripheral_6_data_i (peripheral_6_data_i),

    .peripheral_7_cyc_o  (peripheral_7_cyc_o),
    .peripheral_7_stb_o  (peripheral_7_stb_o),
    .peripheral_7_we_o   (peripheral_7_we_o),
    .peripheral_7_ack_i  (peripheral_7_ack_i),
    .peripheral_7_data_i (peripheral_7_data_i),

    .peripheral_8_cyc_o  (peripheral_8_cyc_o),
    .peripheral_8_stb_o  (peripheral_8_stb_o),
    .peripheral_8_we_o   (peripheral_8_we_o),
    .peripheral_8_ack_i  (peripheral_8_ack_i),
    .peripheral_8_data_i (peripheral_8_data_i)
);

`ifdef LED_ENABLE
LEDs #(
    .LEDS_WIDTH (LEDS_WIDTH)
) Leds (
    .clk    (clk),
    .rst_n  (rst_n),

    .cyc_i  (peripheral_1_cyc_o),
    .stb_i  (peripheral_1_stb_o),
    .we_i   (peripheral_1_we_o),

    .addr_i (master_addr_o),
    .data_i (master_data_o),
    .data_o (peripheral_1_data_i),

    .ack_o  (peripheral_1_ack_i),

    .leds   (leds)
);
`endif

`ifdef UART_ENABLE
UART #(
    .CLK_FREQ     (CLOCK_FREQ),
    .BIT_RATE     (BAUD_RATE),
    .BUFFER_SIZE  (UART_BUFFER_SIZE)
) UART (
    .clk    (clk),
    .rst_n  (rst_n),

    .rxd    (rx),
    .txd    (tx),

    .cyc_i  (peripheral_2_cyc_o),
    .stb_i  (peripheral_2_stb_o),
    .we_i   (peripheral_2_we_o),

    .addr_i (master_addr_o),
    .data_i (master_data_o),
    .data_o (peripheral_2_data_i),

    .ack_o  (peripheral_2_ack_i)
);
`endif

`ifdef GPIO_ENABLE
GPIOS #(
    .WIDTH (GPIO_WIDTH)
) Gpios (
    .clk    (clk),
    .rst_n  (rst_n),

    .cyc_i  (peripheral_3_cyc_o),
    .stb_i  (peripheral_3_stb_o),
    .we_i   (peripheral_3_we_o),

    .addr_i (master_addr_o),
    .data_i (master_data_o),
    .data_o (peripheral_3_data_i),

    .ack_o  (peripheral_3_ack_i),

    .gpios  (gpios)
);
`endif

`ifdef VGA_ENABLE
VGA #(
    .CLK_FREQ        (CLOCK_FREQ),
    .VGA_WIDTH       (VGA_WIDTH),
    .VGA_HEIGHT      (VGA_HEIGHT),
    .VGA_COLOR_DEPTH (VGA_COLOR_DEPTH)
) VGA (
    .clk    (clk),
    .rst_n  (rst_n),

    .cyc_i  (peripheral_4_cyc_o),
    .stb_i  (peripheral_4_stb_o),
    .we_i   (peripheral_4_we_o),

    .addr_i (master_addr_o),
    .data_i (master_data_o),
    .data_o (peripheral_4_data_i),

    .ack_o  (peripheral_4_ack_i),

    .vga_r  (VGA_R),
    .vga_g  (VGA_G),
    .vga_b  (VGA_B),
    .hsync  (VGA_HS),
    .vsync  (VGA_VS)
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
    .clk    (clk),
    .rst_n  (rst_n),

    .cyc_i  (peripheral_5_cyc_o),
    .stb_i  (peripheral_5_stb_o),
    .we_i   (peripheral_5_we_o),

    .addr_i (master_addr_o),
    .data_i (master_data_o),
    .data_o (peripheral_5_data_i),

    .ack_o  (peripheral_5_ack_i)
);
`endif

`ifdef I2C_ENABLE
I2C_Master #(
    .CLK_FREQ        (CLOCK_FREQ)
) I2C (
    .clk    (clk),
    .rst_n  (rst_n),

    .cyc_i  (peripheral_6_cyc_o),
    .stb_i  (peripheral_6_stb_o),
    .we_i   (peripheral_6_we_o),

    .addr_i (master_addr_o),
    .data_i (master_data_o),
    .data_o (peripheral_6_data_i),

    .ack_o  (peripheral_6_ack_i)
);
`endif

`ifdef TIMER_ENABLE
Timer #(
    .CLK_FREQ (CLOCK_FREQ)
) Timer (
    .clk    (clk),
    .rst_n  (rst_n),

    .cyc_i  (peripheral_7_cyc_o),
    .stb_i  (peripheral_7_stb_o),
    .we_i   (peripheral_7_we_o),

    .addr_i (master_addr_o),
    .data_i (master_data_o),
    .data_o (peripheral_7_data_i),

    .ack_o  (peripheral_7_ack_i)
);
`endif

`ifdef DRAM_ENABLE
DRAM_Controller #(
    .CLK_FREQ (CLOCK_FREQ)
) DRAM (
    .clk    (clk),
    .rst_n  (rst_n),

    .cyc_i  (peripheral_8_cyc_o),
    .stb_i  (peripheral_8_stb_o),
    .we_i   (peripheral_8_we_o),

    .addr_i (master_addr_o),
    .data_i (master_data_o),
    .data_o (peripheral_8_data_i),

    .ack_o  (peripheral_8_ack_i)
);
`endif

endmodule
