module Peripheral_BUS (
    // master connection
    input  logic [31:0] addr_i,
    input  logic write_request_i,
    input  logic read_request_i,
    output logic response_o,
    output logic [31:0] read_data_o,

    // peripheral connection
    output logic peripheral_1_write_request_o,
    output logic peripheral_1_read_request_o,
    input  logic peripheral_1_response_i,
    input  logic [31:0] peripheral_1_read_data_i,

    output logic peripheral_2_write_request_o,
    output logic peripheral_2_read_request_o,
    input  logic peripheral_2_response_i,
    input  logic [31:0] peripheral_2_read_data_i,

    output logic peripheral_3_write_request_o,
    output logic peripheral_3_read_request_o,
    input  logic peripheral_3_response_i,
    input  logic [31:0] peripheral_3_read_data_i,

    output logic peripheral_4_write_request_o,
    output logic peripheral_4_read_request_o,
    input  logic peripheral_4_response_i,
    input  logic [31:0] peripheral_4_read_data_i,

    output logic peripheral_5_write_request_o,
    output logic peripheral_5_read_request_o,
    input  logic peripheral_5_response_i,
    input  logic [31:0] peripheral_5_read_data_i,

    output logic peripheral_6_write_request_o,
    output logic peripheral_6_read_request_o,
    input  logic peripheral_6_response_i,
    input  logic [31:0] peripheral_6_read_data_i,

    output logic peripheral_7_write_request_o,
    output logic peripheral_7_read_request_o,
    input  logic peripheral_7_response_i,
    input  logic [31:0] peripheral_7_read_data_i,

    output logic peripheral_8_write_request_o,
    output logic peripheral_8_read_request_o,
    input  logic peripheral_8_response_i,
    input  logic [31:0] peripheral_8_read_data_i
);

always_comb begin : RESPONSE_MUX
    unique case(addr_i[30:28])
        3'b000: response_o = peripheral_1_response_i;
        3'b001: response_o = peripheral_2_response_i;
        3'b010: response_o = peripheral_3_response_i;
        3'b011: response_o = peripheral_4_response_i;
        3'b100: response_o = peripheral_5_response_i;
        3'b101: response_o = peripheral_6_response_i;
        3'b110: response_o = peripheral_7_response_i;
        3'b111: response_o = peripheral_8_response_i;
        default: response_o = 1'b0;
    endcase
end

always_comb begin
    unique case (addr_i[30:28])
        3'b000: read_data_o = peripheral_1_read_data_i;
        3'b001: read_data_o = peripheral_2_read_data_i;
        3'b010: read_data_o = peripheral_3_read_data_i;
        3'b011: read_data_o = peripheral_4_read_data_i;
        3'b100: read_data_o = peripheral_5_read_data_i;
        3'b101: read_data_o = peripheral_6_read_data_i;
        3'b110: read_data_o = peripheral_7_read_data_i;
        3'b111: read_data_o = peripheral_8_read_data_i;
        default: read_data_o = 32'h00000000;
    endcase
end

// Write request assignment
assign peripheral_1_write_request_o = (addr_i[30:28] == 3'b000) ? write_request_i : 1'b0;
assign peripheral_2_write_request_o = (addr_i[30:28] == 3'b001) ? write_request_i : 1'b0;
assign peripheral_3_write_request_o = (addr_i[30:28] == 3'b010) ? write_request_i : 1'b0;
assign peripheral_4_write_request_o = (addr_i[30:28] == 3'b011) ? write_request_i : 1'b0;
assign peripheral_5_write_request_o = (addr_i[30:28] == 3'b100) ? write_request_i : 1'b0;
assign peripheral_6_write_request_o = (addr_i[30:28] == 3'b101) ? write_request_i : 1'b0;
assign peripheral_7_write_request_o = (addr_i[30:28] == 3'b110) ? write_request_i : 1'b0;
assign peripheral_8_write_request_o = (addr_i[30:28] == 3'b111) ? write_request_i : 1'b0;

// Read request assignment
assign peripheral_1_read_request_o = (addr_i[30:28] == 3'b000) ? read_request_i : 1'b0;
assign peripheral_2_read_request_o = (addr_i[30:28] == 3'b001) ? read_request_i : 1'b0;
assign peripheral_3_read_request_o = (addr_i[30:28] == 3'b010) ? read_request_i : 1'b0;
assign peripheral_4_read_request_o = (addr_i[30:28] == 3'b011) ? read_request_i : 1'b0;
assign peripheral_5_read_request_o = (addr_i[30:28] == 3'b100) ? read_request_i : 1'b0;
assign peripheral_6_read_request_o = (addr_i[30:28] == 3'b101) ? read_request_i : 1'b0;
assign peripheral_7_read_request_o = (addr_i[30:28] == 3'b110) ? read_request_i : 1'b0;
assign peripheral_8_read_request_o = (addr_i[30:28] == 3'b111) ? read_request_i : 1'b0;

endmodule
