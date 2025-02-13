`timescale 1ns / 1ps

module top(
    input  wire clk_ref_p,
    input  wire clk_ref_n,
    input  wire sys_rst_i,
    input  wire button_center,
    input  wire RxD,
    output wire TxD,
    input  wire [7:0] gpio_switch,
    output wire [7:0] led
);
    
reg clk_o;
wire clk_ref; // Sinal de clock single-ended

// Instância do buffer diferencial
IBUFDS #(
    .DIFF_TERM("FALSE"),     // Habilita ou desabilita o terminador diferencial
    .IBUF_LOW_PWR("TRUE"),   // Ativa o modo de baixa potência
    .IOSTANDARD("DIFF_SSTL15")
) ibufds_inst (
    .O(clk_ref),    // Clock single-ended de saída
    .I(clk_ref_p),  // Entrada diferencial positiva
    .IB(clk_ref_n)  // Entrada diferencial negativa
);

Grande_Risco_5_SOC #(
    .CLOCK_FREQ       (100000000),
    .BAUD_RATE        (115200),
    .MEMORY_SIZE      (8192),
    .MEMORY_FILE      ("../../verification_tests/memory/led_test.hex"),
    .GPIO_WIDHT       (6),
    .UART_BUFFER_SIZE (16),
    .I_CACHE_SIZE     (64),
    .D_CACHE_SIZE     (64)
) SOC (
    .clk   (clk_o),
    .reset (sys_rst_i),
    .leds  (led),
    .rx    (),
    .tx    (),
    .gpios ()
);

always @(posedge clk_ref) begin
    if(sys_rst_i) begin
        clk_o <= 1'b0;
    end else begin
        clk_o <= ~clk_o;
    end
end

endmodule