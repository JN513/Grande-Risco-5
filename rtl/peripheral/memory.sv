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

logic [31:0] memory [(MEMORY_SIZE/4)-1: 0];

`ifdef __ICARUS__
integer i;
`endif

initial begin
    `ifdef __ICARUS__
        for(i = 0; i < (MEMORY_SIZE/4); i = i + 1) begin
            memory[i] = 32'h0;
        end
    `endif
    if(MEMORY_FILE != "") begin
        $readmemh(MEMORY_FILE, memory, 0, (MEMORY_SIZE/4) - 1);
    end
end

assign read_data = (memory_read == 1'b1) ? memory[address[31:2]] : 32'd0; 
assign response = memory_read | memory_write;

always @(posedge clk ) begin // Always ff does not work with Initialization in slang
    if(memory_write) begin
        memory[address[31:2]] <= write_data;
    end
end

endmodule
