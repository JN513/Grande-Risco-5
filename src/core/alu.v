module Alu (
    input wire [3:0] operation,
    input wire [31:0] ALU_in_X,
    input wire [31:0] ALU_in_Y,
    output reg [31:0] ALU_out_S,
    output wire ZR
);

localparam AND             = 4'b0000;
localparam OR              = 4'b0001;
localparam SUM             = 4'b0010;    // bit 3: 0
localparam SUB             = 4'b1010;    // bit 3: 1
localparam GREATER_EQUAL   = 4'b1100;    // bit 3: 1
localparam GREATER_EQUAL_U = 4'b1101;    // bit 3: 1, 1 bit de diferença de GREATER_EQUAL
localparam SLT             = 4'b1110;    // bit 3: 1
localparam SLT_U           = 4'b1111;    // bit 3: 1, 1 bit de diferença de SLT
localparam SHIFT_LEFT      = 4'b0100;    // SHIFT_LEFT difere um bit de SHIFT_RIGHT
localparam SHIFT_RIGHT     = 4'b0101;    // SHIFT_RIGHT difere um bit de SHIFT_RIGHT_A e SHIFT_LEFT
localparam SHIFT_RIGHT_A   = 4'b0111;    // SHIFT_RIGHT_A difere um bit de SHIFT_RIGHT
localparam XOR             = 4'b1000;
localparam NOR             = 4'b1001;
localparam EQUAL           = 4'b0011;

assign ZR = ~( |ALU_out_S ) && operation[3:2] != 2'b01; // ZR = 1 se ALU_out_S == 0

always @(*) begin
    case(operation)
        AND: // AND
            ALU_out_S = ALU_in_X & ALU_in_Y; 
        OR: // OR
            ALU_out_S = ALU_in_X | ALU_in_Y;
        SUM: // Adição
            ALU_out_S = ALU_in_X + ALU_in_Y;
        SUB: // Subtração
            ALU_out_S = ALU_in_X - ALU_in_Y;
        SLT: // SLT
            ALU_out_S = (ALU_in_X < ALU_in_Y) ? 32'h1 : 32'h0;
        SLT_U: // SLT
            ALU_out_S = ($unsigned(ALU_in_X) < $unsigned(ALU_in_Y)) ? 32'h1 : 32'h0;
        NOR: // NOR
            ALU_out_S = ~(ALU_in_X | ALU_in_Y);
        XOR: // XOR (OU exclusivo)
            ALU_out_S = ALU_in_X ^ ALU_in_Y;
        EQUAL: // Igualdade
            ALU_out_S = ALU_in_X == ALU_in_Y;
        SHIFT_LEFT: // Shift Left (deslocamento à esquerda)
            ALU_out_S = ALU_in_X << ALU_in_Y[4:0];
        SHIFT_RIGHT: // Shift Right (deslocamento à direita)
            ALU_out_S = ALU_in_X >> ALU_in_Y[4:0];
        SHIFT_RIGHT_A: // Shift Right Arithmetic (deslocamento à direita)
            ALU_out_S = ALU_in_X >>> ALU_in_Y[4:0];
        GREATER_EQUAL: // Maior igual
            ALU_out_S = (ALU_in_X >= ALU_in_Y) ? 32'h1 : 32'h0;
        GREATER_EQUAL_U: // Maior igual
            ALU_out_S = ($unsigned(ALU_in_X) >= $unsigned(ALU_in_Y)) ? 32'h1 : 32'h0;
        default: ALU_out_S = ALU_in_X ; // Operação padrão
    endcase
end
    
endmodule
