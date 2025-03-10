module Memory #(
    parameter MEMORY_FILE = "",
    parameter MEMORY_SIZE = 4096
)(
    input  logic clk,
    input  logic memory_read,
    input  logic memory_write,
    input  logic [31:0] address,
    input  logic [31:0] write_data,
    output logic [31:0] read_data,
    output logic response
);


localparam BIT_INDEX = $clog2(MEMORY_SIZE) - 1'b1;

logic [31:0] memory [(MEMORY_SIZE/4)-1: 0];

initial begin
    if(MEMORY_FILE != "") begin
        $readmemh(MEMORY_FILE, memory, 0, (MEMORY_SIZE/4) - 1);
    end
end

assign read_data = (memory_read == 1'b1) ? memory[address[BIT_INDEX:2]] : 32'd0; 
assign response = memory_read | memory_write;

always @(posedge clk ) begin // Always ff does not work with Initialization in slang
    if(memory_write) begin
        memory[address[BIT_INDEX:2]] <= write_data;
    end
end

endmodule
