module ICache #(
    parameter CACHE_SIZE = 1024
) (
    input wire clk,
    input wire reset,

    // Processor interface
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

    localparam IDLE                      = 3'b000;
    localparam READ_FIRST_WORD           = 3'b001;
    localparam RESOLVE_FIRST_WORLD_MISS  = 3'b010;
    localparam READ_SECOND_WORD          = 3'b011;
    localparam RESOLVE_SECOND_WORLD_MISS = 3'b100;

    reg [31:0] cache_data  [(CACHE_SIZE/4)-1: 0];    
    reg [21:0] cache_tag   [(CACHE_SIZE/4)-1: 0];
    reg        cache_valid [(CACHE_SIZE/4)-1: 0];

    reg [2:0] state;
    wire hit;
    wire is_unaligned;
    reg miss_finished, internal_read_request;
    reg [31:0] internal_addr, temp_data;

    integer i;

    initial begin
        for(i = 0; i < (CACHE_SIZE/4) - 1; i++) begin
            cache_valid [i] = 1'b0;
        end
    end

    assign hit = (read_request && cache_valid[addr[31:2]] 
                 && cache_tag[addr[31:2]] == addr[31:10] && !is_unaligned);

    always @(posedge clk) begin
        miss_finished <= 1'b0;

        if(reset) begin 
            miss_finished         <= 1'b0;
            internal_addr         <= 32'h0;
            internal_read_request <= 1'b0;
            state                 <= IDLE;
        end else begin 
            if(memory_read_response && read_request && !hit) begin
                cache_valid  [addr[31:2]] <= 1'b1;
                cache_tag    [addr[31:2]] <= addr[31:10];
                cache_data   [addr[31:2]] <= memory_read_data;
                miss_finished       <= 1'b1;
            end

            case (state)
                IDLE: begin
                    if(read_request && is_unaligned) begin
                        state         <= READ_FIRST_WORD;
                        internal_addr <= addr;
                    end
                end 
                READ_FIRST_WORD: begin
                    if(cache_valid[internal_addr[31:2]]) begin
                        temp_data     <= {16'h0, cache_data[addr[31:2]][31:16]};
                        state         <= READ_SECOND_WORD;
                        internal_addr <= internal_addr + 32'h4;
                    end else begin
                        internal_read_request <= 1'b1;
                        state                 <= RESOLVE_FIRST_WORLD_MISS;
                    end
                end
                RESOLVE_FIRST_WORLD_MISS: begin
                    if(memory_read_response) begin
                        internal_read_request       <= 1'b0;
                        cache_valid [internal_addr[31:2]] <= 1'b1;
                        cache_tag   [internal_addr[31:2]] <= internal_addr[31:10];
                        cache_data  [internal_addr[31:2]] <= memory_read_data;
                        state                       <= READ_SECOND_WORD;
                        temp_data                   <= {16'h0, memory_read_data[31:16]};
                        internal_addr               <= internal_addr + 32'h4;
                    end
                end
                READ_SECOND_WORD: begin
                    if(cache_valid[internal_addr[31:2]]) begin
                        temp_data     <= {cache_data[internal_addr[31:2]][15:0], temp_data[15:0]};
                        state         <= IDLE;
                        internal_addr <= 32'h0;
                        miss_finished <= 1'b1;
                    end else begin
                        internal_read_request <= 1'b1;
                        state                 <= RESOLVE_SECOND_WORLD_MISS;
                    end
                end
                RESOLVE_SECOND_WORLD_MISS: begin
                    if(memory_read_response) begin
                        internal_read_request       <= 1'b0;
                        cache_valid [internal_addr[31:2]] <= 1'b1;
                        cache_tag   [internal_addr[31:2]] <= internal_addr[31:10];
                        cache_data  [internal_addr[31:2]] <= memory_read_data;
                        state                       <= IDLE;
                        temp_data                   <= {memory_read_data[31:16], temp_data[15:0]};
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign memory_addr         = (is_unaligned) ? internal_addr : addr;
    assign memory_read_request = (hit) ? 32'h0 : (is_unaligned) ? 
        internal_read_request : read_request; // internal_read_request

    assign read_response = hit | miss_finished;
    assign read_data     = (is_unaligned) ? temp_data : cache_data[addr[31:2]];

    assign is_unaligned = addr[1];

endmodule
