`include "config.vh"

`ifdef GPIO_ENABLE

module GPIOS #(
    parameter WIDTH = 20
) (
    input  logic clk,
    input  logic rst_n,
    
    // Wishbone Interface
    input  logic        cyc_i,          // Wishbone cycle indicator
    input  logic        stb_i,          // Wishbone strobe (request)
    input  logic        we_i,           // Write enable
    input  logic [31:0] addr_i,         // Address input
    input  logic [31:0] data_i,         // Data input (for write)
    output logic [31:0] data_o,         // Data output (for read)
    output logic        ack_o,          // Acknowledge output
    
    // GPIO Interface
    inout [WIDTH - 1:0] gpios
);

logic [WIDTH - 1:0] gpio_direction, gpio_value;
logic [WIDTH - 1:0] gpio_out;
logic [1:0] pwm_out;
logic [1:0] is_pwm;

logic [15:0] duty_cycle[1:0];
logic [15:0] period[1:0];

localparam SET_DIRECTION     = 8'h00;
localparam WRITE_DATA        = 8'h04;
localparam CONFIG_PWM        = 8'h08;
localparam CONFIG_PERIOD     = 8'h0C;
localparam CONFIG_DUTY_CYCLE = 8'h10;

assign data_o = (cyc_i && stb_i && !we_i) ? { {32-WIDTH{1'b0}}, gpio_out } : 32'h00000000;  // Read operation
assign ack_o  = cyc_i && stb_i;  // Acknowledge if the transaction is active

// GPIO Instance
GPIO Gpios[WIDTH - 1:0](
    .gpio       (gpios),
    .direction  ({gpio_direction[WIDTH - 1: 2], gpio_direction[1:0] & ~is_pwm}),
    .data_in    ({gpio_value[WIDTH - 1: 2], 
                    (gpio_value[1:0] & ~is_pwm) | (pwm_out[1:0] & is_pwm)}),
    .data_out   (gpio_out)
);

// PWM Instances
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

// Handle Wishbone Write Requests
always_ff @(posedge clk) begin
    if (!rst_n) begin
        is_pwm         <= 2'b00;
        gpio_direction <= 'h0;
        gpio_value     <= 'h0;
    end else if (cyc_i && stb_i && we_i) begin  // Write operation
        case (addr_i[7:0])
            SET_DIRECTION:     gpio_direction               <= data_i[WIDTH - 1:0];
            WRITE_DATA:        gpio_value                   <= data_i[WIDTH - 1:0];
            CONFIG_PWM:        is_pwm                       <= data_i[1:0];
            CONFIG_PERIOD:     period[data_i[16]]           <= data_i[15:0];
            CONFIG_DUTY_CYCLE: duty_cycle[data_i[16]]       <= data_i[15:0];
            default: begin
                // Do nothing
            end
        endcase
    end
end

endmodule

`endif
