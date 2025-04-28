`timescale 1ns/1ps

module uart_rx_tb;

    // Parameters
    parameter BAUD_RATE  = 115200;
    parameter CLK_FREQ = 50_000_000; // 50 MHz
    parameter BIT_PERIOD = (CLK_FREQ / BAUD_RATE); // Em clocks (aproximadamente 4)

    // Signals
    logic clk;
    logic rst_n;
    logic wr_bit_period_i;
    logic [15:0] bit_period_i;
    logic uart_rxd;
    logic uart_rx_en;
    logic uart_rx_parity_error;
    logic uart_rx_valid;
    logic [7:0] uart_rx_data;

    // Instantiate DUT
    UART_RX #(
        .BAUD_RATE(BAUD_RATE),
        .CLK_FREQ(CLK_FREQ)
    ) dut (
        .clk                  (clk),
        .rst_n                (rst_n),
        .wr_bit_period_i      (wr_bit_period_i),
        .bit_period_i         (bit_period_i),
        .uart_rxd             (uart_rxd),
        .uart_rx_en           (uart_rx_en),
        .uart_rx_parity_error (uart_rx_parity_error),
        .uart_rx_valid        (uart_rx_valid),
        .uart_rx_data         (uart_rx_data)
    );

    // Clock Generation: 500kHz -> 2us period
    initial clk = 0;
    always #1000 clk = ~clk; // 1us high, 1us low = 2us period -> 500kHz

    // Tasks
    task uart_send_byte(input [7:0] data);
        integer i;
        reg parity;
        begin
            parity = ^data; // Calcula a paridade ímpar

            // Start bit
            uart_rxd = 0;
            repeat (BIT_PERIOD) @(posedge clk);

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                uart_rxd = data[i];
                repeat (BIT_PERIOD) @(posedge clk);
            end

            // Parity bit
            uart_rxd = parity;
            repeat (BIT_PERIOD) @(posedge clk);

            // Stop bit
            uart_rxd = 1;
            repeat (BIT_PERIOD) @(posedge clk);
        end
    endtask
    // Dump waves
    initial begin
        $dumpfile("build/uart_rx_tb.vcd");
        $dumpvars(0, uart_rx_tb);
    end

    initial begin
        // Inicialização
        uart_rxd = 1; // Linha ociosa é '1' (UART idle)
        wr_bit_period_i = 0;
        bit_period_i = 16'd0;
        uart_rx_en = 0;

        rst_n = 0;
        #10000; // 10us
        rst_n = 1;
        #10000; // 10us

        uart_rx_en = 1;
        #20000; // 20us

        // Teste: Enviar um byte 0xA5
        $display("Sending 0xA5...");
        uart_send_byte(8'hA5);

        // Timeout para evitar travar
        fork
            begin : wait_for_valid
                wait (uart_rx_valid);
                #20_000; // Pequeno tempo extra
                if (uart_rx_data == 8'hA5 && uart_rx_parity_error == 0)
                    $display("PASS: Received 0x%0h correctly!", uart_rx_data);
                else
                    $display("FAIL: Received 0x%0h (expected 0xA5), parity error = %b", uart_rx_data, uart_rx_parity_error);
            end
            begin : timeout
                #1_000_000; // 1ms timeout
                $display("TIMEOUT: uart_rx_valid not received!");
                $finish;
            end
        join_any
        disable wait_for_valid;
        disable timeout;

        // Teste: Enviar outro byte 0x3C
        $display("Sending 0x3C...");
        uart_send_byte(8'h3C);

        fork
            begin : wait_for_valid_2
                wait (uart_rx_valid);
                #20_000;
                if (uart_rx_data == 8'h3C && uart_rx_parity_error == 0)
                    $display("PASS: Received 0x%0h correctly!", uart_rx_data);
                else
                    $display("FAIL: Received 0x%0h (expected 0x3C), parity error = %b", uart_rx_data, uart_rx_parity_error);
            end
            begin : timeout_2
                #1_000_000;
                $display("TIMEOUT: uart_rx_valid not received!");
                $finish;
            end
        join_any
        disable wait_for_valid_2;
        disable timeout_2;

        // Encerrar simulação
        #500_000; // Espera final
        $finish;
    end

endmodule
