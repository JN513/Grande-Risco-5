module ICache #(
    parameter CACHE_SIZE = 72
) (
    input wire clk,
    input wire rst_n,

    // Processor interface
    input  wire flush_bus,
    input  wire read_request,
    input  wire [31:0] addr,
    output wire read_response,
    output wire [31:0] read_data,

    // Memory interface
    output wire memory_read_request,
    input  wire memory_read_response,
    output wire [31:0] memory_addr,
    input  wire [31:0] memory_read_data
);

    localparam TAG_SIZE                  = 'd32 - $clog2(CACHE_SIZE);
    localparam BLOCK_SIZE                = 'd32;
    localparam ADDRES_END_BIT            = $clog2(CACHE_SIZE) - 1'b1;

    reg [BLOCK_SIZE:0] cache_data  [0 : (CACHE_SIZE / 'd4) - 1'b1];    
    reg   [TAG_SIZE:0] cache_tag   [0 : (CACHE_SIZE / 'd4) - 1'b1];
    reg                cache_valid [0 : (CACHE_SIZE / 'd4) - 1'b1];

    reg request_to_memory, clear_response;
    wire hit;
    reg miss_finished;

    integer i;

    assign hit = (read_request && cache_valid[addr[ADDRES_END_BIT:2]] 
                 && cache_tag[addr[ADDRES_END_BIT:2]] == addr[31:ADDRES_END_BIT + 1]);

    always @(posedge clk) begin
        miss_finished <= 1'b0;

        if(!rst_n) begin 
            clear_response        <= 1'b0;
            miss_finished         <= 1'b0;
            request_to_memory     <= 1'b0;

            for(i = 0; i < (CACHE_SIZE / 'd4 ); i = i + 1'b1) begin
                cache_valid [i] = 1'b0;
            end
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
                cache_valid  [addr[ADDRES_END_BIT:2]] <= 1'b1;
                cache_tag    [addr[ADDRES_END_BIT:2]] <= addr[31:ADDRES_END_BIT + 1];
                cache_data   [addr[ADDRES_END_BIT:2]] <= memory_read_data;
                miss_finished                         <= 1'b1;
                request_to_memory                     <= 1'b0;
            end
        end
    end

    assign memory_addr         = addr;
    assign memory_read_request = request_to_memory;

    assign read_response = hit | miss_finished;
    assign read_data     = cache_data[addr[ADDRES_END_BIT:2]];

endmodule
