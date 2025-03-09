`include "config.vh"

`ifdef GPIO_ENABLE

module GPIOS #(
    parameter WIDHT = 20
) (
    input  logic clk,
    input  logic rst_n,
    
    output logic response_o,
    input  logic read_request_i,
    input  logic write_request_i,

    input  logic [31:0] address_i,
    input  logic [31:0] write_data_i,
    output logic [31:0] read_data_o,

    inout [WIDHT - 1:0] gpios
);

logic [WIDHT - 1:0] gpio_direction, gpio_value;
logic [WIDHT - 1:0] gpio_out;
logic [1:0] pwm_out;
logic [1:0] is_pwm;

logic [15:0] duty_cycle[1:0];
logic [15:0] period[1:0];

localparam SET_DIRECTION     = 8'h00;
localparam WRITE_DATA        = 8'h04;
localparam CONFIG_PWM        = 8'h08;
localparam CONFIG_PERIOD     = 8'h0C;
localparam CONFIG_DUTY_CYCLE = 8'h10;

assign read_data_o = (read_request_i) ? gpio_out : 32'h00000000;
assign response_o  = read_request_i | write_request_i;

GPIO Gpios[WIDHT - 1:0](
    .gpio       (gpios),
    .direction  ({gpio_direction[WIDHT - 1: 2], gpio_direction[1:0] & ~is_pwm}),
    .data_in    ({gpio_value[WIDHT - 1: 2], 
                    (gpio_value[1:0] & ~is_pwm) | (pwm_out[1:0] & is_pwm)}),
    .data_out   (gpio_out)
);

PWM Pwm0(
    .clk        (clk),
    .rst_n      (rst_n),
    .duty_cycle (duty_cycle[0]),
    .period     (period[0]),
    .pwm_out    (pwm_out[0])
);

PWM Pwm1(
    .clk        (clk),
    .rst_n      (rst_n),
    .duty_cycle (duty_cycle[1]),
    .period     (period[1]),
    .pwm_out    (pwm_out[1])
);

always_ff @(posedge clk) begin
    if(!rst_n) begin
        is_pwm         <= 2'b00;
        gpio_direction <= 32'h00000000;
        gpio_value     <= 32'h00000000;
    end else if(write_request_i) begin
        case (address_i[7:0])
            SET_DIRECTION:     gpio_direction               <= write_data_i[WIDHT - 1: 0];
            WRITE_DATA:        gpio_value                   <= write_data_i[WIDHT - 1: 0];
            CONFIG_PWM:        is_pwm                       <= write_data_i[1:0];
            CONFIG_PERIOD:     period[write_data_i[16]]     <= write_data_i[15:0];
            CONFIG_DUTY_CYCLE: duty_cycle[write_data_i[16]] <= write_data_i[15:0];
        endcase
    end
end
    
endmodule

`endif