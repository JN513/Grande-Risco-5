module LEDs #(
    parameter LEDS_WIDTH = 8
) (
    input  logic clk,
    input  logic rst_n,

    output logic response_o,
    input  logic read_request_i,
    input  logic write_request_i,

    input  logic [31:0] address_i,
    input  logic [31:0] write_data_i,
    output logic [31:0] read_data_o,

    output logic [LEDS_WIDTH - 1:0] leds
);

logic [31:0] data;

assign response_o = read_request_i | write_request_i;

assign read_data_o = (read_request_i == 1'b1) ? data : 32'h00000000;

always_ff @(posedge clk ) begin : LEDS_LOGIC
    if(!rst_n) begin
        data <= 32'h0;
    end else if(write_request_i) begin
        data <= write_data_i;
    end
end

assign leds = data[LEDS_WIDTH - 1 :0];
    
endmodule