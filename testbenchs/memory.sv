module Memory #(
    parameter MEMORY_FILE = "",
    parameter MEMORY_SIZE = 4096
)(
    input  logic clk,
    input  logic reset,
    input  logic memory_read,
    input  logic memory_write,
    input  logic [31:0] address,
    input  logic [31:0] write_data,
    output logic memory_response,
    output logic [31:0] read_data
);

logic [31:0] memory [(MEMORY_SIZE/4)-1: 0];

//assign memory_response = memory_read | memory_write;

assign read_data = memory[{2'b00, address[31:2]}];
assign memory_response = memory_read | memory_write;

initial begin
    if(MEMORY_FILE != "") begin
        $readmemh(MEMORY_FILE, memory, 0, (MEMORY_SIZE/4) - 1);
    end
end


always_ff @(posedge clk) begin
    if(memory_write) begin
        memory[{2'b00, address[31:2]}] <= write_data;
    end
end

endmodule