module FIFO #(
    parameter DEPTH = 8,
    parameter WIDTH = 8
) (
    input  logic clk,
    input  logic rst_n,
    input  logic write,
    input  logic read,
    input  logic [WIDTH-1:0] write_data,
    output logic full,
    output logic empty,
    output logic [WIDTH-1:0] read_data
);

logic [WIDTH-1:0] memory[DEPTH-1:0];
logic [5:0] read_ptr;
logic [5:0] write_ptr;

always_ff @(posedge clk ) begin
    if(!rst_n) begin
        read_ptr <= 6'd0;
    end else begin
        if(read == 1'b1 && empty == 1'b0) begin
            read_data <= memory[read_ptr];
            read_ptr <= (read_ptr == DEPTH-1'b1) ? 'd0 : read_ptr + 1'b1;
        end
    end
end

always_ff @(posedge clk ) begin
    if(!rst_n) begin
        write_ptr <= 6'd0;
    end else begin
        if(write == 1'b1 && full == 1'b0) begin
            memory[write_ptr] <= write_data;
            write_ptr <= (write_ptr == DEPTH-1'b1) ? 'd0 : write_ptr + 1'b1;
        end
    end
end

assign full = ((write_ptr == read_ptr - 1) || (write_ptr == DEPTH-1 && read_ptr == 'd0)) ? 1'b1 : 1'b0;
assign empty = (write_ptr == read_ptr) ? 1'b1 : 1'b0;
    
endmodule