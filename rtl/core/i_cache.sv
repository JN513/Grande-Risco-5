module ICache #(
    parameter CACHE_SIZE = 72
) (
    input logic clk,
    input logic rst_n,

    // Processor interface
    input  logic flush_bus,
    input  logic read_request,
    input  logic [31:0] addr,
    output logic read_response,
    output logic [31:0] read_data,

    // Memory interface
    output logic memory_read_request,
    input  logic memory_read_response,
    output logic [31:0] memory_addr,
    input  logic [31:0] memory_read_data
);

    localparam TAG_SIZE   = 'd32 - $clog2(CACHE_SIZE);
    localparam BLOCK_SIZE = 'd32;
    localparam INDEX_BITS = $clog2(CACHE_SIZE) - 1'b1;

    typedef logic [BLOCK_SIZE-1:0] cache_block_t;
    typedef logic [TAG_SIZE-1:0]   cache_tag_t;

    cache_block_t cache_data  [0 : (CACHE_SIZE / 'd4) - 1'b1];    
    cache_tag_t   cache_tag   [0 : (CACHE_SIZE / 'd4) - 1'b1];
    logic         cache_valid [0 : (CACHE_SIZE / 'd4) - 1'b1];

    logic request_to_memory, clear_response;
    logic hit;
    logic miss_finished;

    assign hit = (read_request && cache_valid[addr[INDEX_BITS:2]] 
                 && cache_tag[addr[INDEX_BITS:2]] == addr[31:INDEX_BITS + 1]);

    always_ff @( posedge clk ) begin : CACHE_LOGIC
        miss_finished <= 1'b0;

        if(!rst_n) begin 
            clear_response    <= 1'b0;
            miss_finished     <= 1'b0;
            request_to_memory <= 1'b0;
            cache_valid       <= '{default: 1'b0}; // Inicializa todas as posições como inválidas
        end else begin
            if(read_request && !hit && !flush_bus) begin
                request_to_memory <= 1'b1;
            end

            if(request_to_memory && flush_bus) begin
                clear_response    <= 1'b1;
                request_to_memory <= 1'b0;
            end

            if(memory_read_response && clear_response) begin
                clear_response <= 1'b0;
            end

            if(memory_read_response && request_to_memory && !hit 
                && !flush_bus && !clear_response) begin
                cache_valid  [addr[INDEX_BITS:2]] <= 1'b1;
                cache_tag    [addr[INDEX_BITS:2]] <= addr[31:INDEX_BITS + 1];
                cache_data   [addr[INDEX_BITS:2]] <= memory_read_data;
                miss_finished                     <= 1'b1;
                request_to_memory                 <= 1'b0;
            end
        end
    end

    assign memory_addr         = addr;
    assign memory_read_request = request_to_memory;

    assign read_response = hit | miss_finished;
    assign read_data     = cache_data[addr[INDEX_BITS:2]];

endmodule
