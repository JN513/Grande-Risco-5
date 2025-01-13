module LEDs #(
    parameter DEVICE_START_ADDRESS = 32'h00001000,
    parameter DEVICE_FINAL_ADDRESS = 32'h00001002
) (
    input wire clk,
    input wire reset,
    input wire read,
    input wire write,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output wire [31:0] read_data,
    output wire [7:0] leds,
    output wire response
);

reg [32:0] data;

assign response = read || write;

assign read_data = (read == 1'b1) ? data : 32'h00000000;

always @(posedge clk ) begin
    if(reset == 1'b1) begin
        data <= 32'h0;
    end else if(write) begin
        data <= write_data;
    end
end

assign leds = ~data[7:0];
    
endmodule