module DCache #(
    parameter CACHE_SIZE = 32
) (
    input wire clk,
    input wire rst_n,

    // Processor interface
    input  wire read_request,
    input  wire write_request,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output wire response,
    output wire [31:0] read_data,

    // Memory interface
    output wire memory_read_request,
    output wire memory_write_request,
    input  wire memory_response,
    output wire [31:0] memory_addr,
    output wire [31:0] memory_write_data,
    input  wire [31:0] memory_read_data
);
    // caso mude tamanho da cache, alterar o tamanho do tag e espaco de endereco
    localparam TAG_SIZE                  = 'd32 - $clog2(CACHE_SIZE);
    localparam BLOCK_SIZE                = 'd32;
    localparam ADDRES_END_BIT            = $clog2(CACHE_SIZE) - 1'b1;

    reg [BLOCK_SIZE:0] cache_data  [0 : (CACHE_SIZE / 'd4) - 1'b1];    
    reg   [TAG_SIZE:0] cache_tag   [0 : (CACHE_SIZE / 'd4) - 1'b1];
    reg                cache_valid [0 : (CACHE_SIZE / 'd4) - 1'b1];

    wire hit;
    reg miss_finished, write_through;

    integer i;

    assign hit = (read_request && cache_valid[addr[ADDRES_END_BIT:2]] 
                 && cache_tag[addr[ADDRES_END_BIT:2]] == addr[31:ADDRES_END_BIT + 1]);

    always @(posedge clk) begin
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
