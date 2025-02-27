module Immediate_Generator (
    input  logic [31:0] instr_i,  // Entrada: Instrução
    output logic [31:0] imm_o     // Saída: Imediato extraído da instrução
);


localparam LW_OPCODE        = 7'b0000011;
localparam SW_OPCODE        = 7'b0100011;
localparam JAL_OPCODE       = 7'b1101111;
localparam LUI_OPCODE       = 7'b0110111;
localparam CSR_OPCODE       = 7'b1110011;
localparam JALR_OPCODE      = 7'b1100111;
localparam AUIPC_OPCODE     = 7'b0010111;
localparam BRANCH_OPCODE    = 7'b1100011;
localparam IMMEDIATE_OPCODE = 7'b0010011;

logic [6:0] instr_opcode;
logic [2:0] instr_func3;

always_comb begin : imm_o_GENERATOR
    case (instr_opcode)
        BRANCH_OPCODE: // SB type
            imm_o = {{19{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
        JAL_OPCODE: // UJ type JAL
            imm_o = {{11{instr_i[31]}}, instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
        AUIPC_OPCODE: // AUIPC U type
            imm_o = {instr_i[31:12], 12'h000};
        LUI_OPCODE: // LUI U type
            imm_o = {instr_i[31:12], 12'h000};
        LW_OPCODE: // lw instr_i 
            imm_o = {{20{instr_i[31]}}, instr_i[31:20]};
        IMMEDIATE_OPCODE: // I type instr_i
            case (instr_func3)
                3'b001: imm_o = {{27{instr_i[24]}}, instr_i[24:20]};
                3'b011: imm_o = {20'h00000, instr_i[31:20]};
                3'b101: imm_o = {{27'h0000000}, instr_i[24:20]};
                default: imm_o = {{20{instr_i[31]}}, instr_i[31:20]};
            endcase
        JALR_OPCODE: // I type instr_i JALR
            imm_o = {{20{instr_i[31]}}, instr_i[31:20]};
        CSR_OPCODE: // I type instr_i  CSR
            imm_o = {20'h00000, instr_i[31:20]};
        SW_OPCODE: // sw instr_i  (S type)
            imm_o = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
        default: imm_o = 32'h00000000;
    endcase
end

assign instr_opcode = instr_i[6:0];
assign instr_func3  = instr_i[14:12];
    
endmodule
