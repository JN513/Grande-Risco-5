`include "config.vh"

`ifdef GPIO_ENABLE

module GPIO (
    inout  logic gpio,
    input  logic data_in,
    input  logic direction,
    output logic data_out
);

assign data_out = (gpio & direction) | (data_in & ~data_in);
assign gpio = (direction == 1'b1) ? 1'bz : data_in;
    
endmodule

`endif