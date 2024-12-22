module MDU (
    input wire clk,
    input wire reset,
    input wire start,
    output wire done,
    input wire [2:0] operation,
    input wire [31:0] MDU_in_X,
    input wire [31:0] MDU_in_Y,
    output wire [31:0] MDU_out_S
);

// Operation codes

localparam MUL    = 3'b000; // rd = rs1 * rs2
localparam MULH   = 3'b001; // rd = (rs1 * rs2)[63:32]
localparam MULHSU = 3'b010; // rd = (rs1 * rs2)[63:32]
localparam MULHU  = 3'b011; // rd = (rs1 * rs2)[63:32]
localparam DIV    = 3'b100; // rd = rs1 / rs2
localparam DIVU   = 3'b101; // rd = rs1 / rs2
localparam REM    = 3'b110; // rd = rs1 % rs2
localparam REMU   = 3'b111; // rd = rs1 % rs2

// State machine states

localparam IDLE = 2'b00;
localparam EXEC = 2'b01;
localparam DONE = 2'b10;

// Names of the registers
//
// multiplier = rs1
// multiplicand = rs2
// product = rd
//
// dividend = rs1
// divisor = rs2
// quotient = rd
//
// dividend = rs1
// divisor = rs2
// remainder = rd
//
// MDU_in_X = rs1
// MDU_in_Y = rs2
// MDU_out_S = rd

// Internal registers
reg [63:0] product;


always @(posedge clk) begin

end

endmodule
