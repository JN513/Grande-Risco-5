`include "config.vh"

`ifdef LED_ENABLE

module LEDs #(
    parameter LEDS_WIDTH = 8
) (
    input  logic clk,
    input  logic rst_n,
    
    // Wishbone Interface
    input  logic        cyc_i,          // Wishbone cycle indicator
    input  logic        stb_i,          // Wishbone strobe (request)
    input  logic        we_i,           // Write enable
    input  logic [31:0] addr_i,          // Address input
    input  logic [31:0] data_i,          // Data input (for write)
    output logic [31:0] data_o,          // Data output (for read)
    output logic        ack_o,          // Acknowledge output
    
    // LEDs Interface
    output logic [LEDS_WIDTH - 1:0] leds
);

logic [31:0] data;

// Handle Read and Write for Wishbone Interface
assign data_o = (cyc_i && stb_i && !we_i) ? data : 32'h00000000;  // Read operation
assign ack_o  = cyc_i && stb_i;  // Acknowledge if the transaction is active

// Handle Write operation
always_ff @(posedge clk) begin
    if (!rst_n) begin
        data <= 32'h0;
    end else if (cyc_i && stb_i && we_i) begin  // Write operation
        data <= data_i;
    end
end

// LED Output assignment
assign leds = data[LEDS_WIDTH - 1:0];

endmodule

`endif
