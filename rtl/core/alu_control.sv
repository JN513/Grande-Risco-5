module ALU_Control (
    input  logic is_immediate_i,
    input  logic [1:0] ALU_CO_i,
    input  logic [6:0] FUNC7_i,
    input  logic [2:0] FUNC3_i,
    output logic [3:0] ALU_OP_o
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
    unique case (ALU_CO_i)
        2'b00: ALU_OP_o = SUM; // Operações de LOAD/STORE

        2'b01: // Operações de Branch
            unique case (FUNC3_i)
                3'b000: ALU_OP_o = SUB;             // BEQ
                3'b001: ALU_OP_o = EQUAL;           // BNE
                3'b100: ALU_OP_o = GREATER_EQUAL;   // BLT
                3'b101: ALU_OP_o = SLT;             // BGE
                3'b110: ALU_OP_o = GREATER_EQUAL_U; // BLTU
                3'b111: ALU_OP_o = SLT_U;           // BGEU
                default: ALU_OP_o = SUB;            // Default para branches
            endcase

        2'b10: // Operações de ALU
            unique case (FUNC3_i)
                3'b000: ALU_OP_o = (is_immediate_i || !FUNC7_i[5]) ? SUM : SUB; // ADD/SUB
                3'b001: ALU_OP_o = SHIFT_LEFT;   // SLLI / SLL
                3'b010: ALU_OP_o = SLT;          // SLTI / SLT
                3'b011: ALU_OP_o = SLT_U;        // SLTIU / SLTU
                3'b100: ALU_OP_o = XOR;          // XORI / XOR
                3'b101: ALU_OP_o = (FUNC7_i[5]) ? SHIFT_RIGHT_A : SHIFT_RIGHT; // SRAI/SRLI/SRA/SRL
                3'b110: ALU_OP_o = OR;           // ORI / OR
                3'b111: ALU_OP_o = AND;          // ANDI / AND
                default: ALU_OP_o = SUM;         // Default para operações ALU
            endcase

        default: ALU_OP_o = SUM; // Default
    endcase
end

endmodule
