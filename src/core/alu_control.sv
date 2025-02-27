module ALU_Control (
    input  logic is_immediate,
    input  logic [1:0] aluop_in,
    input  logic [6:0] func7,
    input  logic [2:0] func3,
    output logic [3:0] aluop_out
);

// Definição dos códigos de operação
localparam AND             = 4'b0000;
localparam OR              = 4'b0001;
localparam SUM             = 4'b0010;
localparam EQUAL           = 4'b0011;
localparam SHIFT_LEFT      = 4'b0100;
localparam SHIFT_RIGHT     = 4'b0101;
localparam SHIFT_RIGHT_A   = 4'b0111;
localparam XOR             = 4'b1000;
localparam NOR             = 4'b1001;
localparam SUB             = 4'b1010;
localparam GREATER_EQUAL   = 4'b1100;
localparam GREATER_EQUAL_U = 4'b1101;
localparam SLT             = 4'b1110;
localparam SLT_U           = 4'b1111;

always_comb begin : ALU_CONTROL
    aluop_out = SUM; // Valor padrão

    unique case (aluop_in)
        2'b00: aluop_out = SUM; // Operações de LOAD/STORE

        2'b01: // Operações de Branch
            unique case (func3)
                3'b000: aluop_out = SUB;             // BEQ
                3'b001: aluop_out = EQUAL;           // BNE
                3'b100: aluop_out = GREATER_EQUAL;   // BLT
                3'b101: aluop_out = SLT;             // BGE
                3'b110: aluop_out = GREATER_EQUAL_U; // BLTU
                3'b111: aluop_out = SLT_U;           // BGEU
                default: aluop_out = SUB;            // Default para branches
            endcase

        2'b10: // Operações de ALU
            unique case (func3)
                3'b000: aluop_out = (is_immediate || !func7[5]) ? SUM : SUB; // ADD/SUB
                3'b001: aluop_out = SHIFT_LEFT;   // SLLI / SLL
                3'b010: aluop_out = SLT;          // SLTI / SLT
                3'b011: aluop_out = SLT_U;        // SLTIU / SLTU
                3'b100: aluop_out = XOR;          // XORI / XOR
                3'b101: aluop_out = (func7[5]) ? SHIFT_RIGHT_A : SHIFT_RIGHT; // SRAI/SRLI/SRA/SRL
                3'b110: aluop_out = OR;           // ORI / OR
                3'b111: aluop_out = AND;          // ANDI / AND
                default: aluop_out = SUM;         // Default para operações ALU
            endcase
    endcase
end

endmodule
