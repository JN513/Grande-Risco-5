`timescale 1ns/1ps

module uart_tb;

    // Parameters
    parameter BIT_RATE = 115200;
    parameter CLK_FREQ = 500_000;
    parameter BIT_PERIOD = (CLK_FREQ / BIT_RATE); // em ciclos de clock

    // Signals
    logic clk;
    logic rst_n;

    logic rx;
    logic tx;

    logic uart_tx_en;
    logic [7:0] uart_tx_data;
    logic uart_tx_busy;

    logic uart_rx_valid;
    logic [7:0] uart_rx_data;
    logic parity_error;

    // Instantiate DUT
    UART #(
        .BIT_RATE (BIT_RATE),
        .CLK_FREQ (CLK_FREQ)
    ) dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .rx            (rx),
        .tx            (tx),
        .uart_tx_en    (uart_tx_en),
        .uart_tx_data  (uart_tx_data),
        .uart_tx_busy  (uart_tx_busy),
        .uart_rx_valid (uart_rx_valid),
        .uart_rx_data  (uart_rx_data),
        .parity_error  (parity_error)
    );

    // Clock generation: 50MHz -> 20ns
    initial clk = 0;
    always #10 clk = ~clk;

    // Variables
    integer i;

    // Task to transmit one byte
    task uart_send(input [7:0] data);
        begin
            @(posedge clk);
            uart_tx_data = data;
            uart_tx_en = 1;
            @(posedge clk);
            uart_tx_en = 0;
            wait (uart_tx_busy == 1);
            wait (uart_tx_busy == 0);
        end
    endtask

    // Initial block
    initial begin
        // Inicialização
        rst_n = 0;
        rx = 1; // Idle
        uart_tx_en = 0;
        uart_tx_data = 8'd0;

        #100;
        rst_n = 1;
        #100;

        // Conectar loopback
        force rx = tx;

        // Teste 1: enviar 0xA5
        $display("Sending 0xA5...");
        uart_send(8'hA5);

        wait (uart_rx_valid);
        @(posedge clk); // Espera próximo clock para leitura

        if (uart_rx_data == 8'hA5 && parity_error == 0)
            $display("PASS: Received 0x%0h correctly!", uart_rx_data);
        else
            $display("FAIL: Received 0x%0h (expected 0xA5), parity_error = %b", uart_rx_data, parity_error);

        #1000;

        // Teste 2: enviar 0x3C
        $display("Sending 0x3C...");
        uart_send(8'h3C);

        wait (uart_rx_valid);
        @(posedge clk);

        if (uart_rx_data == 8'h3C && parity_error == 0)
            $display("PASS: Received 0x%0h correctly!", uart_rx_data);
        else
            $display("FAIL: Received 0x%0h (expected 0x3C), parity_error = %b", uart_rx_data, parity_error);

        #1000;

        // Teste 3: enviar 0xFF
        $display("Sending 0xFF...");
        uart_send(8'hFF);

        wait (uart_rx_valid);
        @(posedge clk);

        if (uart_rx_data == 8'hFF && parity_error == 0)
            $display("PASS: Received 0x%0h correctly!", uart_rx_data);
        else
            $display("FAIL: Received 0x%0h (expected 0xFF), parity_error = %b", uart_rx_data, parity_error);

        #5000;

        $display("Finished UART loopback test.");
        $finish;
    end

    // Dump para waveform opcional
    initial begin
        $dumpfile("build/uart.vcd");
        $dumpvars(0, uart_tb);
    end

endmodule
