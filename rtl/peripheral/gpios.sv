module GPIOS #(
    parameter WIDHT = 20
) (
    input  logic clk,
    input  logic rst_n,
    input  logic read,
    input  logic write,
    input  logic [31:0] address,
    input  logic [31:0] write_data,
    output logic [31:0] read_data,
    inout [WIDHT - 1:0] gpios
);

logic [WIDHT - 1:0] gpio_direction, gpio_value;
logic [WIDHT -1:0] gpio_out;

parameter SET_DIRECTION = 1'b0;
parameter READ = 1'b1;

assign read_data = (read == 1'b1) ? gpio_out : 32'h00000000;

GPIO Gpios[WIDHT - 1:0](
    .gpio(gpios),
    .direction(gpio_direction),
    .data_in(gpio_value),
    .data_out(gpio_out)
);

always_ff @(posedge clk) begin
    if(!rst_n) begin
        gpio_direction <= 32'h00000000;
        gpio_value <= 32'h00000000;
    end else if(write) begin
        if(write_data[31] == SET_DIRECTION)
            gpio_direction <= write_data[WIDHT - 1: 0];
        else
            gpio_value <= write_data[WIDHT - 1: 0];
    end
end
    
endmodule
