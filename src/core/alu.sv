module Alu (
    input  logic [3:0] operation,
    input  logic [31:0] ALU_in_X,
    input  logic [31:0] ALU_in_Y,
    output logic [31:0] ALU_out_S,
    output logic ZR
);

// Definição dos opcodes
localparam AND             = 4'b0000;
localparam OR              = 4'b0001;
localparam SUM             = 4'b0010;
localparam SUB             = 4'b1010;
localparam GREATER_EQUAL   = 4'b1100;
localparam GREATER_EQUAL_U = 4'b1101;
localparam SLT             = 4'b1110;
localparam SLT_U           = 4'b1111;
localparam SHIFT_LEFT      = 4'b0100;
localparam SHIFT_RIGHT     = 4'b0101;
localparam SHIFT_RIGHT_A   = 4'b0111;
localparam XOR             = 4'b1000;
localparam NOR             = 4'b1001;
localparam EQUAL           = 4'b0011;

// Define ZR como 1 se ALU_out_S for 0 (exceto para branches)
assign ZR = ~( |ALU_out_S ) && operation[3:2] != 2'b01;

always_comb begin : ALU_OPERATION
    unique case (operation)
        AND:   ALU_out_S = ALU_in_X & ALU_in_Y;
        OR:    ALU_out_S = ALU_in_X | ALU_in_Y;
        SUM:   ALU_out_S = ALU_in_X + ALU_in_Y;
        SUB:   ALU_out_S = ALU_in_X - ALU_in_Y;
        XOR:   ALU_out_S = ALU_in_X ^ ALU_in_Y;
        NOR:   ALU_out_S = ~(ALU_in_X | ALU_in_Y);
        EQUAL: ALU_out_S = (ALU_in_X == ALU_in_Y);
        
        // Comparações
        SLT:             ALU_out_S = (ALU_in_X < ALU_in_Y) ? 32'h1 : 32'h0;
        SLT_U:           ALU_out_S = ($unsigned(ALU_in_X) < $unsigned(ALU_in_Y)) ? 32'h1 : 32'h0;
        GREATER_EQUAL:   ALU_out_S = (ALU_in_X >= ALU_in_Y) ? 32'h1 : 32'h0;
        GREATER_EQUAL_U: ALU_out_S = ($unsigned(ALU_in_X) >= $unsigned(ALU_in_Y)) ? 32'h1 : 32'h0;
        
        // Shifts
        SHIFT_LEFT:    ALU_out_S = ALU_in_X << ALU_in_Y[4:0];
        SHIFT_RIGHT:   ALU_out_S = ALU_in_X >> ALU_in_Y[4:0];
        SHIFT_RIGHT_A: ALU_out_S = ALU_in_X >>> ALU_in_Y[4:0];

        default: ALU_out_S = ALU_in_X; // Operação padrão
    endcase
end

endmodule
