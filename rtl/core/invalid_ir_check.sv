module Invalid_IR_Check (
    input  logic [31:0] instruction,
    output logic invalid_instruction_o
);

// Importando os opcodes do pacote
import opcodes_pkg::*;

logic func7_lsb;
logic [2:0] func3;
logic [4:0] func5;
logic [6:0] func7;
logic [6:0] opcode;

always_comb begin : IR_INVALID_CHECKER
    unique case (opcode)
        LW_OPCODE: begin
            unique case (func3)
                3'b000, 3'b001, 3'b010, 3'b100, 3'b101: invalid_instruction_o = 1'b0;
                default: invalid_instruction_o = 1'b1;
            endcase
        end
        SW_OPCODE: begin
            unique case (func3)
                3'b000, 3'b001, 3'b010: invalid_instruction_o = 1'b0;
                default: invalid_instruction_o = 1'b1;
            endcase
        end
        JAL_OPCODE: begin
            invalid_instruction_o = 1'b0;
        end
        CSR_OPCODE: begin
            unique case (func3)
                3'b000, 3'b001, 3'b010, 3'b100, 3'b101, 3'b110: invalid_instruction_o = 1'b0;
                default: invalid_instruction_o = 1'b1;
            endcase
        end
        JALR_OPCODE: begin
            invalid_instruction_o = (func3 == 3'b000) ? 1'b0 : 1'b1;
        end
        AUIPC_OPCODE: begin
            invalid_instruction_o = 1'b0;
        end
        BRANCH_OPCODE: begin
            unique case (func3)
                3'b000, 3'b001, 3'b100, 3'b101, 3'b110, 3'b111: invalid_instruction_o = 1'b0;
                default: invalid_instruction_o = 1'b1;
            endcase
        end
        IMMEDIATE_OPCODE: begin
            invalid_instruction_o = 1'b0;
        end
        RTYPE_OPCODE: begin
            invalid_instruction_o = 1'b0;
        end
        ATOMIC_OPCODE: begin
            invalid_instruction_o = 1'b0;
        end
        LUI_OPCODE: begin
            invalid_instruction_o = 1'b0;
        end
        FENCE_OPCODE: begin
            invalid_instruction_o = 1'b0;
        end
        default: invalid_instruction_o = 1'b1;
    endcase
end

assign opcode    = instruction[6:0];
assign func3     = instruction[14:12];
assign func5     = instruction[31:27];
assign func7     = instruction[31:25];
assign func7_lsb = instruction[25];
    
endmodule
