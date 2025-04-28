`timescale 1ns/1ps

module uart_tx_tb;

    // Parameters
    parameter BAUD_RATE = 115200;
    parameter CLK_FREQ  = 50_000_000;
    parameter BIT_PERIOD = (CLK_FREQ / BAUD_RATE); // em ciclos de clock

    // Signals
    logic clk;
    logic rst_n;
    logic wr_bit_period_i;
    logic [15:0] bit_period_i;
    logic uart_tx_en;
    logic [7:0] uart_tx_data;
    logic uart_txd;
    logic uart_tx_busy;

    // Instantiate DUT
    UART_TX #(
        .BAUD_RATE (BAUD_RATE),
        .CLK_FREQ  (CLK_FREQ)
    ) dut (
        .clk             (clk),
        .rst_n           (rst_n),
        .wr_bit_period_i (wr_bit_period_i),
        .bit_period_i    (bit_period_i),
        .uart_tx_en      (uart_tx_en),
        .uart_tx_data    (uart_tx_data),
        .uart_txd        (uart_txd),
        .uart_tx_busy    (uart_tx_busy)
    );

    // Clock generation: 50MHz => 20ns period
    initial clk = 0;
    always #10 clk = ~clk;

    // Control Variables
    integer i;

    // Tasks
    task uart_send(input [7:0] data);
        begin
            @(posedge clk);
            uart_tx_data = data;
            uart_tx_en = 1;
            @(posedge clk);
            uart_tx_en = 0;
            // Aguarda UART ficar livre (tx_busy == 0)
            wait (uart_tx_busy == 1);
            wait (uart_tx_busy == 0);
        end
    endtask

    // Monitor UART_TXD (não obrigatório, mas ajuda a ver o sinal)
    initial begin
        $dumpfile("build/uart_tx_tb.vcd");
        $dumpvars(0, uart_tx_tb);
        $monitor("Time: %0t | TXD: %b | TX_BUSY: %b", $time, uart_txd, uart_tx_busy);
    end

    // Initial block
    initial begin
        // Inicialização
        rst_n = 0;
        wr_bit_period_i = 0;
        bit_period_i = 16'd0;
        uart_tx_en = 0;
        uart_tx_data = 8'h00;

        #100;
        rst_n = 1;
        #100;

        // Opcional: Configurar bit_period manualmente
        /*
        wr_bit_period_i = 1;
        bit_period_i = (CLK_FREQ / BAUD_RATE) - 1;
        #20;
        wr_bit_period_i = 0;
        */

        // Teste 1: enviar 0xA5
        $display("Sending 0xA5...");
        uart_send(8'hA5);

        #10000;

        // Teste 2: enviar 0x5A
        $display("Sending 0x5A...");
        uart_send(8'h5A);

        #10000;

        // Teste 3: enviar 0xFF
        $display("Sending 0xFF...");
        uart_send(8'hFF);

        #10000;

        // Fim da simulação
        $display("Finished Transmission Test.");
        $finish;
    end

endmodule
