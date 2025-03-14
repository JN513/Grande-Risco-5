`ifndef OPCODES_PKG
`define OPCODES_PKG
package opcodes_pkg;

    // Instrução NOP (No Operation)
    localparam logic [31:0] NOP = 32'h00000033; // add x0, x0, x0

    // OpCodes de Instruções
    localparam logic [6:0] LW_OPCODE        = 7'b0000011;
    localparam logic [6:0] SW_OPCODE        = 7'b0100011;
    localparam logic [6:0] JAL_OPCODE       = 7'b1101111;
    localparam logic [6:0] LUI_OPCODE       = 7'b0110111;
    localparam logic [6:0] CSR_OPCODE       = 7'b1110011;
    localparam logic [6:0] JALR_OPCODE      = 7'b1100111;
    localparam logic [6:0] AUIPC_OPCODE     = 7'b0010111;
    localparam logic [6:0] BRANCH_OPCODE    = 7'b1100011;
    localparam logic [6:0] IMMEDIATE_OPCODE = 7'b0010011;
    localparam logic [6:0] RTYPE_OPCODE     = 7'b0110011;
    localparam logic [6:0] ATOMIC_OPCODE    = 7'b0101111;
    localparam logic [6:0] FENCE_OPCODE     = 7'b0001111;

endpackage
`endif