module Cache_request_Multiplexer #( 
    parameter DATA_WIDTH = 32, // Largura dos dados na requisição
    parameter ADDR_WIDTH = 32
)(
    input logic clk,
    input logic rst_n,

    // Entradas das caches
    
    input  logic [ADDR_WIDTH-1:0] i_cache_address,
    output logic [DATA_WIDTH-1:0] i_cache_read_data,
    input  logic i_cache_read_request,

    input  logic [ADDR_WIDTH-1:0] d_cache_address,
    output logic [DATA_WIDTH-1:0] d_cache_read_data,
    input  logic [DATA_WIDTH-1:0] d_cache_write_data,
    input  logic d_cache_read_request,
    input  logic d_cache_write_request,

    // Saidas das caches

    output logic i_cache_response,
    output logic d_cache_response,

    // Sinais de memória
     
    output logic memory_read_request,
    output logic memory_write_request,
    output logic [ADDR_WIDTH-1:0] memory_addr,
    output logic [DATA_WIDTH-1:0] memory_write_data,
    input  logic memory_response,
    input  logic [DATA_WIDTH-1:0] memory_read_data
);

// response out: 0 = i_cache, 1 = d_cache
// request type: 0 = read, 1 = write

logic [31:0] requested_memory_addr, write_data;
logic response_out, write_request, read_request, access_pedding;

always_ff @(posedge clk ) begin : cache_request_multiplexer
    i_cache_response <= 1'b0;
    d_cache_response <= 1'b0;

    if(!rst_n) begin
        requested_memory_addr <= 32'h0;
        response_out          <= 1'b0;
        write_request         <= 1'b0;
        read_request          <= 1'b0;
        access_pedding        <= 1'b0;
    end else begin
        if(memory_response && access_pedding) begin
            access_pedding <= 1'b0;
            read_request   <= 1'b0;
            write_request  <= 1'b0;
            if(response_out) begin
                d_cache_response  <= 1'b1;
                d_cache_read_data <= memory_read_data;
            end else begin
                i_cache_response  <= 1'b1;
                i_cache_read_data <= memory_read_data;
            end
        end

        if(~access_pedding) begin
            if((d_cache_read_request || d_cache_write_request) && ~d_cache_response) begin
                requested_memory_addr <= d_cache_address;
                response_out          <= 1'b1;
                write_request         <= d_cache_write_request;
                read_request          <= d_cache_read_request;
                write_data            <= d_cache_write_data;
                access_pedding        <= 1'b1;
            end else if(i_cache_read_request && ~i_cache_response) begin
                requested_memory_addr <= i_cache_address;
                response_out          <= 1'b0;
                write_request         <= 1'b0;
                read_request          <= 1'b1;
                access_pedding        <= 1'b1;
            end
        end
    end
end

assign memory_addr          = requested_memory_addr;
assign memory_read_request  = read_request;
assign memory_write_request = write_request;
assign memory_write_data    = write_data;

endmodule
