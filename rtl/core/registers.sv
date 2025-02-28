module Registers (
    input  logic clk,
    input  logic wr_en_i,
    input  logic [4:0] RS1_ADDR_i,
    input  logic [4:0] RS2_ADDR_i,
    input  logic [4:0] RD_ADDR_i,
    input  logic [31:0] data_i,
    output logic [31:0] RS1_data_o,
    output logic [31:0] RS2_data_o
);

logic [31:0] registers[0:31];

assign RS1_data_o = (wr_en_i && (RD_ADDR_i == RS1_ADDR_i) && (|RD_ADDR_i))
                   ? data_i
                   : registers[RS1_ADDR_i];

assign RS2_data_o = (wr_en_i && (RD_ADDR_i == RS2_ADDR_i) && (|RD_ADDR_i))
                   ? data_i
                   : registers[RS2_ADDR_i];


always @(posedge clk ) begin
    if (wr_en_i) begin
        registers[RD_ADDR_i] <= data_i;
    end
    
    registers[0] <= 32'h00000000;
end

endmodule
