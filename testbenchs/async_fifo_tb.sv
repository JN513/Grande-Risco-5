`timescale 1ns/1ps

module async_fifo_tb;
    parameter DEPTH = 16;
    parameter WIDTH = 8;

    // Clocks independentes
    logic clk_wr = 0;
    logic clk_rd = 0;

    always #4 clk_wr = ~clk_wr;  // 125 MHz
    always #7 clk_rd = ~clk_rd;  // ~71 MHz

    // Sinais
    logic rst_n;
    logic wr_en_i, rd_en_i;
    logic [WIDTH-1:0] write_data_i;
    logic [WIDTH-1:0] read_data_o;
    logic full_o, empty_o;

    integer write_val;
    integer read_expected;
    logic make_read;

    // DUT
    async_fifo #(
        .DEPTH (DEPTH),
        .WIDTH (WIDTH)
    ) uut (
        .clk_wr       (clk_wr),
        .clk_rd       (clk_rd),
        .rst_n        (rst_n),
        .wr_en_i      (wr_en_i),
        .rd_en_i      (rd_en_i),
        .write_data_i (write_data_i),
        .full_o       (full_o),
        .empty_o      (empty_o),
        .read_data_o  (read_data_o)
    );

    // Controle de reset e teste
    initial begin
        $dumpfile("build/async_fifo_tb.vcd");
        $dumpvars(0, async_fifo_tb);

        // Reset inicial
        rst_n        = 0;
        wr_en_i      = 0;
        rd_en_i      = 0;
        write_data_i = 0;
        make_read    = 0;
        #20 rst_n    = 1;

        // Espera um pouco após reset
        repeat (3) @(posedge clk_wr);
        repeat (3) @(posedge clk_rd);

        // Escreve na FIFO até encher
        for (int i = 0; i < DEPTH - 1; i++) begin
            @(posedge clk_wr);
            if (!full_o) begin
                write_data_i <= i + 1;
                wr_en_i      <= 1;
            end
            @(posedge clk_wr);
            wr_en_i <= 0;
        end

        // Verifica que FIFO está cheia
        @(posedge clk_wr);
        if (!full_o) $error("Erro: FIFO deveria estar cheia!");

        // Tenta escrever mais (não deve alterar)
        write_data_i <= 99;
        wr_en_i      <= 1;
        @(posedge clk_wr);
        wr_en_i <= 0;
        @(posedge clk_wr);
        if (!full_o) $error("Erro: FIFO deveria continuar cheia!");

        // Aguarda um pouco e começa leitura
        repeat (2) @(posedge clk_rd);

        for (int i = 0; i < DEPTH - 1; i++) begin
            @(posedge clk_rd);
            if (!empty_o) begin
                rd_en_i <= 1;
            end
            @(posedge clk_rd);
            rd_en_i <= 0;

            @(posedge clk_rd);
            if (read_data_o !== i + 1)
                $error("Erro: valor lido %0d diferente de esperado %0d", read_data_o, i + 1);
        end

        // Verifica que FIFO está vazia
        @(posedge clk_rd);
        if (!empty_o) $error("Erro: FIFO deveria estar vazia!");

        // Teste leitura com FIFO vazia
        rd_en_i <= 1;
        @(posedge clk_rd);
        rd_en_i <= 0;
        @(posedge clk_rd);
        if (!empty_o) $error("Erro: FIFO deveria continuar vazia!");

        // ---
        // Teste de operação simultânea
        // ---
        repeat (3) @(posedge clk_wr);
        repeat (3) @(posedge clk_rd);

        $display("Iniciando operação simultânea de escrita e leitura");

        write_val = 100;
        read_expected = write_val;

        fork
            // Processo de escrita
            begin
                for (int i = 0; i < DEPTH * 2; i++) begin
                    @(posedge clk_wr);
                    if (!full_o) begin
                        write_data_i <= write_val;
                        wr_en_i      <= 1;
                        write_val++;
                    end else begin
                        wr_en_i <= 0;
                    end
                    @(posedge clk_wr);
                    wr_en_i <= 0;
                end
            end

            // Processo de leitura
            begin
                for (int i = 0; i < DEPTH * 2; i++) begin
                    @(posedge clk_rd);
                    if (!empty_o) begin
                        rd_en_i <= 1;
                    end else begin
                        rd_en_i <= 0;
                    end

                    @(posedge clk_rd);
                    rd_en_i <= 0;

                    if (!empty_o && make_read) begin
                        make_read <= 0;
                        if (read_data_o !== read_expected)
                            $error("Erro: leitura=%0d, esperado=%0d", read_data_o, read_expected);
                        read_expected++;
                    end
                end
            end
        join

        $display("✅ Operação simultânea finalizada com sucesso!");

        $display("✅ Testbench finalizado com sucesso!");
        $finish;
    end

    always_ff @(posedge clk_rd or negedge rst_n) begin
        make_read <= 0;
        if (!rst_n) begin
            make_read <= 0;
        end else if (rd_en_i && !empty_o) begin
            make_read <= 1;
        end
    end

endmodule