module async_fifo #(
    parameter DEPTH = 8,
    parameter WIDTH = 8
)(
    input  logic clk_wr,        // clock de escrita
    input  logic clk_rd,        // clock de leitura
    input  logic rst_n,         // reset ativo baixo

    input  logic wr_en_i,       // habilita escrita
    input  logic rd_en_i,       // habilita leitura

    input  logic [WIDTH-1:0] write_data_i,  // dado para escrever

    output logic full_o,        // FIFO cheia (no domínio escrita)
    output logic empty_o,       // FIFO vazia (no domínio leitura)
    output logic [WIDTH-1:0] read_data_o    // dado lido
);

    localparam PTR_WIDTH = $clog2(DEPTH);

    logic [WIDTH-1:0] memory [0:DEPTH-1];

    // Ponteiros binários
    logic [PTR_WIDTH-1:0] wr_ptr_bin, rd_ptr_bin;

    // Ponteiros em Gray code
    logic [PTR_WIDTH-1:0] wr_ptr_gray, rd_ptr_gray;

    // Ponteiros Gray sincronizados entre domínios
    logic [PTR_WIDTH-1:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;
    logic [PTR_WIDTH-1:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;


    function automatic logic [PTR_WIDTH-1:0] bin2gray(input logic [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction


    function automatic logic [PTR_WIDTH-1:0] gray2bin(input logic [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // --- Domínio escrita ---

    // Atualiza ponteiro de escrita binário
    always_ff @(posedge clk_wr or negedge rst_n) begin
        if (!rst_n)
            wr_ptr_bin <= 0;
        else if (wr_en_i && !full_o)
            wr_ptr_bin <= wr_ptr_bin + 1;
    end

    // Ponteiro escrita em Gray
    assign wr_ptr_gray = bin2gray(wr_ptr_bin);

    // Sincroniza ponteiro de leitura Gray para domínio escrita
    always_ff @(posedge clk_wr or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr_gray_sync1 <= 0;
            rd_ptr_gray_sync2 <= 0;
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

    // Converte ponteiro leitura sincronizado para binário no domínio escrita
    logic [PTR_WIDTH-1:0] rd_ptr_bin_sync;
    assign rd_ptr_bin_sync = gray2bin(rd_ptr_gray_sync2);

    // Escreve na memória
    always_ff @(posedge clk_wr) begin
        if (wr_en_i && !full_o)
            memory[wr_ptr_bin[PTR_WIDTH-1:0]] <= write_data_i;
    end

    // Detecta FIFO cheia no domínio escrita
    // FIFO cheia ocorre quando próximo wr_ptr_bin == rd_ptr_bin_sync
    assign full_o = ((wr_ptr_bin + 1) % DEPTH) == rd_ptr_bin_sync;

    // --- Domínio leitura ---

    // Atualiza ponteiro de leitura binário
    always_ff @(posedge clk_rd or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr_bin <= 0;
            read_data_o <= '0;
        end else if (rd_en_i && !empty_o) begin
            read_data_o <= memory[rd_ptr_bin];
            rd_ptr_bin <= rd_ptr_bin + 1;
        end
    end

    // Ponteiro leitura em Gray
    assign rd_ptr_gray = bin2gray(rd_ptr_bin);

    // Sincroniza ponteiro de escrita Gray para domínio leitura
    always_ff @(posedge clk_rd or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr_gray_sync1 <= 0;
            wr_ptr_gray_sync2 <= 0;
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

    // Converte ponteiro escrita sincronizado para binário no domínio leitura
    logic [PTR_WIDTH-1:0] wr_ptr_bin_sync;
    assign wr_ptr_bin_sync = gray2bin(wr_ptr_gray_sync2);

    // Detecta FIFO vazia no domínio leitura
    assign empty_o = (rd_ptr_bin == wr_ptr_bin_sync);

endmodule