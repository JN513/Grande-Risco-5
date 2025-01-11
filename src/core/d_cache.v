module DCache #(
    parameter CACHE_SIZE = 32
) (
    input wire clk,
    input wire reset,

    // Processor interface
    input  wire valid_addr,
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
 
    reg [31:0] cache_data  [(CACHE_SIZE/4)-1: 0];    
    reg [21:0] cache_tag   [(CACHE_SIZE/4)-1: 0];
    reg        cache_valid [(CACHE_SIZE/4)-1: 0];

    wire hit;
    reg miss_finished, write_through;

    integer i;

    initial begin
        for(i = 0; i < (CACHE_SIZE/4) - 1; i++) begin
            cache_valid [i] = 1'b0;
        end
    end

    assign hit = (read_request && cache_valid[addr[31:2]] 
                 && cache_tag[addr[31:2]] == addr[31:10]);

    always @(posedge clk) begin
        miss_finished <= 1'b0;

        if(reset) begin
            write_through <= 1'b0;
            miss_finished <= 1'b0;
        end else begin 
            if(memory_response && read_request && !hit) begin
                cache_valid   [addr[31:2]] <= 1'b1;
                cache_tag     [addr[31:2]] <= addr[31:10];
                cache_data    [addr[31:2]] <= memory_read_data;
                miss_finished        <= 1'b1;
            end
            if(write_request) begin
                cache_valid[addr[31:2]] <= 1'b1;
                cache_data [addr[31:2]] <= write_data;
                cache_tag  [addr[31:2]] <= addr[31:10];
                write_through           <= 1'b1;
            end
            if(write_through && memory_response) begin
                miss_finished <= 1'b1;
                write_through <= 1'b0;
            end
        end
    end

    assign memory_addr          = (hit) ? 32'h0 : addr;
    assign memory_read_request  = (hit) ? 1'b0  : read_request;
    assign memory_write_data    = (hit) ? 32'h0 : write_data;
    assign memory_write_request = (hit) ? 1'b0  : write_request;

    assign response   = hit | miss_finished;
    assign read_data  = cache_data[addr[31:2]];

endmodule
