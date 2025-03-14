`timescale 1ns / 1ps

module top(
    input  logic clk_ref_p,
    input  logic clk_ref_n,
    input  logic sys_rst_i,

    input  logic button_center,

    input  logic RxD,
    output logic TxD,
    
    output logic [7:0] led,
    inout  logic [7:0] gpio_switch
);
    
logic clk_o;
logic clk_ref; // Sinal de clock single-ended

// Instância do buffer diferencial
IBUFDS #(
    .DIFF_TERM    ("FALSE"),     // Habilita ou desabilita o terminador diferencial
    .IBUF_LOW_PWR ("TRUE"),   // Ativa o modo de baixa potência
    .IOSTANDARD   ("DIFF_SSTL15")
) ibufds_inst (
    .O  (clk_ref),    // Clock single-ended de saída
    .I  (clk_ref_p),  // Entrada diferencial positiva
    .IB (clk_ref_n)  // Entrada diferencial negativa
);

Grande_Risco_5_SOC #(
    .CLOCK_FREQ             (100000000),
    .BAUD_RATE              (115200),
    .MEMORY_SIZE            (16384),
    .MEMORY_FILE            ("../../verification_tests/memory/led_test2.hex"),
    .GPIO_WIDTH             (8),
    .UART_BUFFER_SIZE       (16),
    .I_CACHE_SIZE           (2048),
    .D_CACHE_SIZE           (2048),
    .BRANCH_PREDICTION_SIZE (512),
    .VGA_WIDTH              (640),
    .VGA_HEIGHT             (480),
    .VGA_COLOR_DEPTH        (4),
    .LEDS_WIDTH             (8)
) SOC (
    .clk    (clk_o),
    .rst_n  (!sys_rst_i),
    .leds   (led),
    .rx     (RxD),
    .tx     (TxD),
    .gpios  (gpio_switch),
    .VGA_R  (),
    .VGA_G  (),
    .VGA_B  (),
    .VGA_HS (),
    .VGA_VS ()
);

always_ff @(posedge clk_ref) begin : CLOCK_DIVIDER
    if(sys_rst_i) begin
        clk_o <= 1'b0;
    end else begin
        clk_o <= ~clk_o;
    end
end

endmodule