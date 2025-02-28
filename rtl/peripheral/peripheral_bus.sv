module Peripheral_BUS #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
)(
    // master connection
    input  logic read_request,
    input  logic write_request,
    output logic response,
    input  logic [ADDR_WIDTH-1:0] address,
    input  logic [DATA_WIDTH-1:0] write_data,
    output logic [DATA_WIDTH-1:0] read_data,

    // slave 0 signal
    output logic slave_0_read,
    output logic slave_0_write,
    input  logic slave_0_response,
    input  logic [DATA_WIDTH-1:0] slave_0_read_data,
    output logic [ADDR_WIDTH-1:0] slave_0_address,
    output logic [DATA_WIDTH-1:0] slave_0_write_data,

    // slave 1 signal
    output logic slave_1_read,
    output logic slave_1_write,
    input  logic slave_1_response,
    input  logic [DATA_WIDTH-1:0] slave_1_read_data,
    output logic [ADDR_WIDTH-1:0] slave_1_address,
    output logic [DATA_WIDTH-1:0] slave_1_write_data,

    // slave 2 signal
    output logic slave_2_read,
    output logic slave_2_write,
    input  logic slave_2_response,
    input  logic [DATA_WIDTH-1:0] slave_2_read_data,
    output logic [ADDR_WIDTH-1:0] slave_2_address,
    output logic [DATA_WIDTH-1:0] slave_2_write_data,

    // slave 3 signal
    output logic slave_3_read,
    output logic slave_3_write,
    input  logic slave_3_response,
    input  logic [DATA_WIDTH-1:0] slave_3_read_data,
    output logic [ADDR_WIDTH-1:0] slave_3_address,
    output logic [DATA_WIDTH-1:0] slave_3_write_data
);

endmodule
