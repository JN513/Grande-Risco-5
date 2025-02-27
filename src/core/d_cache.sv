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
    // caso mude tamanho da cache, alterar o tamanho do tag e espaco de endereco
    localparam TAG_SIZE                  = 'd32 - $clog2(CACHE_SIZE);
    localparam BLOCK_SIZE                = 'd32;
    localparam ADDRES_END_BIT            = $clog2(CACHE_SIZE) - 1'b1;

    logic [BLOCK_SIZE:0] cache_data  [0 : (CACHE_SIZE / 'd4) - 1'b1];    
    logic   [TAG_SIZE:0] cache_tag   [0 : (CACHE_SIZE / 'd4) - 1'b1];
    logic                cache_valid [0 : (CACHE_SIZE / 'd4) - 1'b1];

    logic hit;
    logic miss_finished, write_through;

    integer i;

    assign hit = (read_request && cache_valid[addr[ADDRES_END_BIT:2]] 
                 && cache_tag[addr[ADDRES_END_BIT:2]] == addr[31:ADDRES_END_BIT + 1]);

    always_ff @( posedge clk ) begin : CACHE_LOGIC
        miss_finished <= 1'b0;

        if(!rst_n) begin
            write_through <= 1'b0;
            miss_finished <= 1'b0;
            
            for(i = 0; i < (CACHE_SIZE / 'd4 ); i = i + 1'b1) begin
                cache_valid [i] = 1'b0;
            end
        end else begin 
            if(memory_response && read_request && !hit) begin
                cache_valid   [addr[ADDRES_END_BIT:2]] <= 1'b1;
                cache_tag     [addr[ADDRES_END_BIT:2]] <= addr[31:ADDRES_END_BIT + 1];
                cache_data    [addr[ADDRES_END_BIT:2]] <= memory_read_data;
                miss_finished                          <= 1'b1;
            end
            if(write_request) begin
                cache_valid [addr[ADDRES_END_BIT:2]] <= 1'b1;
                cache_data  [addr[ADDRES_END_BIT:2]] <= write_data;
                cache_tag   [addr[ADDRES_END_BIT:2]] <= addr[31:ADDRES_END_BIT + 1];
                write_through                        <= 1'b1;
            end
            if(write_through && memory_response) begin
                miss_finished <= 1'b1;
                write_through <= 1'b0;
            end
        end
    end

    assign memory_addr          = addr;
    assign memory_read_request  = (hit) ? 1'b0  : read_request;
    assign memory_write_data    = write_data;
    assign memory_write_request = write_through;

    assign response   = hit | miss_finished;
    assign read_data  = cache_data[addr[ADDRES_END_BIT:2]];

endmodule
