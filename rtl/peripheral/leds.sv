module LEDs #(
    parameter DEVICE_START_ADDRESS = 32'h00001000,
    parameter DEVICE_FINAL_ADDRESS = 32'h00001002
) (
    input  logic clk,
    input  logic rst_n,
    input  logic read,
    input  logic write,
    input  logic [31:0] address,
    input  logic [31:0] write_data,
    output logic [31:0] read_data,
    output logic [7:0] leds,
    output logic response
);

logic [31:0] data;

assign response = read || write;

assign read_data = (read == 1'b1) ? data : 32'h00000000;

always_ff @(posedge clk ) begin : LEDS_LOGIC
    if(!rst_n) begin
        data <= 32'h0;
    end else if(write) begin
        data <= write_data;
    end
end

assign leds = ~data[7:0];
    
endmodule