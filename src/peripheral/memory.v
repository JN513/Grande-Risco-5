module Memory #(
    parameter MEMORY_FILE = "",
    parameter MEMORY_SIZE = 4096
)(
    input wire clk,
    input wire memory_read,
    input wire memory_write,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output wire [31:0] read_data
);

reg [31:0] memory [(MEMORY_SIZE/4)-1: 0];

initial begin
    if(MEMORY_FILE != "") begin
        $readmemh(MEMORY_FILE, memory, 0, (MEMORY_SIZE/4) - 1);
    end
end

assign read_data = (memory_read == 1'b1) ? memory[address[31:2]] : 32'd0; 

always @(posedge clk ) begin
    if(memory_write) begin
        memory[address[31:2]] <= write_data;
    end
end

endmodule
