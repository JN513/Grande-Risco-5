module DCache #(
    parameter CACHE_SIZE = 32
) (
    input logic clk,
    input logic rst_n,

    // Processor interface
    input  logic read_request,
    input  logic write_request,
    input  logic [31:0] addr,
    input  logic [31:0] write_data,
    output logic response,
    output logic [31:0] read_data,

    // Memory interface
    output logic memory_read_request,
    output logic memory_write_request,
    input  logic memory_response,
    output logic [31:0] memory_addr,
    output logic [31:0] memory_write_data,
    input  logic [31:0] memory_read_data
);

    // Definições automáticas com base no tamanho da cache
    localparam int TAG_SIZE   = 32 - $clog2(CACHE_SIZE);
    localparam int BLOCK_SIZE = 32;
    localparam int INDEX_BITS = $clog2(CACHE_SIZE) - 1;

    typedef logic [BLOCK_SIZE-1:0] cache_block_t;
    typedef logic [TAG_SIZE-1:0]   cache_tag_t;

    // Estruturas da cache
    cache_block_t cache_data  [0:(CACHE_SIZE/4)-1];
    cache_tag_t   cache_tag   [0:(CACHE_SIZE/4)-1];
    logic         cache_valid [0:(CACHE_SIZE/4)-1];

    logic hit;
    logic miss_finished, write_through;

    assign hit = read_request &&
                 cache_valid[addr[INDEX_BITS:2]] &&
                 cache_tag[addr[INDEX_BITS:2]] == addr[31:INDEX_BITS+1];

    always_ff @(posedge clk) begin : CACHE_LOGIC
        miss_finished <= 1'b0;

        if (!rst_n) begin
            write_through <= 1'b0;
            miss_finished <= 1'b0;
            cache_valid   <= '{default: 1'b0}; // Inicializa todas as posições como inválidas
        end else begin 
            if (memory_response && read_request && !hit) begin
                cache_valid [addr[INDEX_BITS:2]] <= 1'b1;
                cache_tag   [addr[INDEX_BITS:2]] <= addr[31:INDEX_BITS+1];
                cache_data  [addr[INDEX_BITS:2]] <= memory_read_data;
                miss_finished                    <= 1'b1;
            end
            if (write_request) begin
                cache_valid [addr[INDEX_BITS:2]] <= 1'b1;
                cache_tag   [addr[INDEX_BITS:2]] <= addr[31:INDEX_BITS+1];
                cache_data  [addr[INDEX_BITS:2]] <= write_data;
                write_through                    <= 1'b1;
            end
            if (write_through && memory_response) begin
                miss_finished <= 1'b1;
                write_through <= 1'b0;
            end
        end
    end

    // Conexão com a memória
    assign memory_addr          = addr;
    assign memory_read_request  = hit ? 1'b0 : read_request;
    assign memory_write_data    = write_data;
    assign memory_write_request = write_through;

    // Saídas
    assign response   = hit | miss_finished;
    assign read_data  = cache_data[addr[INDEX_BITS:2]];

endmodule
