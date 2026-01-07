module Alu (
    input  logic [3:0]  ALU_OP_i,
    input  logic [31:0] ALU_RS1_i,
    input  logic [31:0] ALU_RS2_i,
    output logic [31:0] ALU_RD_o,
    output logic ALU_ZR_o
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

// Define ALU_ZR_o como 1 se ALU_RD_o, for 0 (exceto para shifts)
assign ALU_ZR_o = ~( |ALU_RD_o) && ALU_OP_i[3:2] != 2'b01;

always_comb begin : ALU_LOGIC
    unique case (ALU_OP_i)
        AND:   ALU_RD_o = ALU_RS1_i & ALU_RS2_i;
        OR:    ALU_RD_o = ALU_RS1_i | ALU_RS2_i;
        SUM:   ALU_RD_o = ALU_RS1_i + ALU_RS2_i;
        SUB:   ALU_RD_o = ALU_RS1_i - ALU_RS2_i;
        XOR:   ALU_RD_o = ALU_RS1_i ^ ALU_RS2_i;
        NOR:   ALU_RD_o = ~(ALU_RS1_i | ALU_RS2_i);
        EQUAL: ALU_RD_o = (ALU_RS1_i == ALU_RS2_i) ? 32'h1 : 32'h0;
        
        // Comparações
        SLT:             ALU_RD_o = ($signed(ALU_RS1_i) < $signed(ALU_RS2_i)) ? 32'h1 : 32'h0;
        SLT_U:           ALU_RD_o = ($unsigned(ALU_RS1_i) < $unsigned(ALU_RS2_i)) ? 32'h1 : 32'h0;
        GREATER_EQUAL:   ALU_RD_o = ($signed(ALU_RS1_i) >= $signed(ALU_RS2_i)) ? 32'h1 : 32'h0;
        GREATER_EQUAL_U: ALU_RD_o = ($unsigned(ALU_RS1_i) >= $unsigned(ALU_RS2_i)) ? 32'h1 : 32'h0;
        
        // Shifts
        SHIFT_LEFT:    ALU_RD_o = ALU_RS1_i << ALU_RS2_i[4:0];
        SHIFT_RIGHT:   ALU_RD_o = ALU_RS1_i >> ALU_RS2_i[4:0];
        SHIFT_RIGHT_A: ALU_RD_o = $signed(ALU_RS1_i) >>> ALU_RS2_i[4:0];

        default: ALU_RD_o = ALU_RS1_i; // Operação padrão
    endcase
end

endmodule
