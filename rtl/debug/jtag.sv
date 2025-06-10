module JTAG #(
    parameter DMI_ADDR_BITS = 6,
    parameter DMI_DATA_BITS = 32,
    parameter DMI_OP_BITS = 2
) (
    input logic clk,
    input logic rst_n,

    input logic jtag_tck_i,
    input logic jtag_tms_i,
    input logic jtag_tdi_i,
    output logic jtag_tdo_o,

    output logic jtag_reset_o,
    output logic jtag_halt_o
);
    
endmodule