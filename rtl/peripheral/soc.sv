`include "config.vh"

module Grande_Risco_5_SOC #(
    parameter CLOCK_FREQ             = 100_000_000,
    parameter BAUD_RATE              = 2_500_000,
    parameter BOOT_ADDRESS           = 32'h00000000,
    parameter MEMORY_SIZE            = 65536, // 64KB
    parameter MEMORY_FILE            = "verification_tests/memory/generic.hex",
    parameter GPIO_WIDTH             = 5,
    parameter I_CACHE_SIZE           = 4096,
    parameter D_CACHE_SIZE           = 4096,
    parameter DATA_WIDTH             = 32,
    parameter ADDR_WIDTH             = 32,
    parameter UART_BUFFER_SIZE       = 188,
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

    `ifdef DRAM_ENABLE
    ,
    // DRAM interface
    inout  logic [31:0] ddram_dq,
    inout  logic [3:0]  ddram_dqs_n,
    inout  logic [3:0]  ddram_dqs_p,
    output logic [14:0] ddram_a,
    output logic [2:0]  ddram_ba,
    output logic        ddram_ras_n,
    output logic        ddram_cas_n,
    output logic        ddram_we_n,
    output logic        ddram_reset_n,
    output logic [0:0]  ddram_clk_p,
    output logic [0:0]  ddram_clk_n,
    output logic [0:0]  ddram_cke,
    output logic [0:0]  ddram_cs_n,
    output logic [3:0]  ddram_dm,
    output logic [0:0]  ddram_odt
    `endif
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

`ifdef DRAM_ENABLE
// Control signals
logic ddram_init_done;
logic ddram_init_error;
logic dram_pll_locked;
`endif


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
    `ifdef DRAM_ENABLE
    .halt              (halt | ~ddram_init_done | ddram_init_error | ~dram_pll_locked),
    `else
    .halt              (halt),
    `endif

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

    .jtag_halt_flag_i  (1'b0),  // JTAG halt flag
    .jtag_reset_flag_i (1'b0)   // JTAG reset flag
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
    // User port signals
    logic user_rst;
    logic user_clk;

    // User wishbone signals
    logic user_port_wishbone_0_ack;
    logic [24:0] user_port_wishbone_0_adr;
    logic user_port_wishbone_0_cyc;
    logic [255:0] user_port_wishbone_0_dat_r;
    logic [255:0] user_port_wishbone_0_dat_w;
    logic user_port_wishbone_0_err;
    logic [31:0] user_port_wishbone_0_sel;
    logic user_port_wishbone_0_stb;
    logic user_port_wishbone_0_we;

    litedram_core u_litedram_core (
        .clk                        (clk),                           // 1 bit
        .rst                        (~rst_n),                        // 1 bit
        
        .ddram_dq                   (ddram_dq),                      // 32 bits
        .ddram_dqs_n                (ddram_dqs_n),                   // 4 bits
        .ddram_dqs_p                (ddram_dqs_p),                   // 4
        .ddram_a                    (ddram_a),                       // 15 bits
        .ddram_ba                   (ddram_ba),                      // 3 bits
        .ddram_cas_n                (ddram_cas_n),                   // 1 bit
        .ddram_cke                  (ddram_cke),                     // 1 bit
        .ddram_clk_n                (ddram_clk_n),                   // 1 bit
        .ddram_clk_p                (ddram_clk_p),                   // 1 bit
        .ddram_cs_n                 (ddram_cs_n),                    // 1 bit
        .ddram_dm                   (ddram_dm),                      // 4 bits
        .ddram_odt                  (ddram_odt),                     // 1 bit
        .ddram_ras_n                (ddram_ras_n),                   // 1 bit
        .ddram_reset_n              (ddram_reset_n),                 // 1 bit
        .ddram_we_n                 (ddram_we_n),                    // 1 bit
        .init_done                  (ddram_init_done),               // 1 bit
        .init_error                 (ddram_init_error),              // 1 bit
        .pll_locked                 (dram_pll_locked),               // 1 bit
        
        .user_clk                   (user_clk),                      // 1 bit
        .user_port_wishbone_0_ack   (user_port_wishbone_0_ack),      // 1 bit
        .user_port_wishbone_0_adr   (user_port_wishbone_0_adr),      // 25 bits
        .user_port_wishbone_0_cyc   (user_port_wishbone_0_cyc),      // 1 bit
        .user_port_wishbone_0_dat_r (user_port_wishbone_0_dat_r),    // 256 bits
        .user_port_wishbone_0_dat_w (user_port_wishbone_0_dat_w),    // 256 bits
        .user_port_wishbone_0_err   (user_port_wishbone_0_err),      // 1 bit
        .user_port_wishbone_0_sel   (user_port_wishbone_0_sel),      // 32 bits
        .user_port_wishbone_0_stb   (user_port_wishbone_0_stb),      // 1 bit
        .user_port_wishbone_0_we    (user_port_wishbone_0_we),       // 1 bit
        .user_rst                   (user_rst),                      // 1 bit

        .uart_rx                    (0)
    );
`endif

endmodule
