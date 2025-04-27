// This module is based in ibex implementation, available in: https://github.com/lowRISC/ibex/blob/master/rtl/ibex_compressed_decoder.sv

module IR_Decompression ( // Convert compressed instruction to decompressed instruction
    input  logic [31:0] instr_c_i,      // Compressed instruction (abreviado para 'instr_c')
    output logic        instr_is_c_o,   // Flag indicando se a instrução é comprimida
    output logic [31:0] instr_d_o,      // Decompressed instruction (abreviado para 'instr_d')
    output logic        instr_illegal_o // Indica instrução ilegal
);


// Importando os opcodes do pacote
import opcodes_pkg::*;

always_comb begin : DECOMPRESS
    // By default, forward incoming instruction, mark it as legal.
    instr_d_o = instr_c_i;
    instr_illegal_o = 1'b0;

    // Check if incoming instruction is compressed.
    case (instr_c_i[1:0])
        // C0
        2'b00: begin
            case (instr_c_i[15:13])
                3'b000: begin
                    // c.addi4spn -> addi rd', x2, imm
                    instr_d_o = {2'b0, instr_c_i[10:7], instr_c_i[12:11], 
                            instr_c_i[5], instr_c_i[6], 2'b00, 5'h02, 3'b000, 2'b01, 
                            instr_c_i[4:2], {IMMEDIATE_OPCODE}};
                    if (instr_c_i[12:5] == 8'b0)  instr_illegal_o = 1'b1;
                end

                3'b010: begin
                    // c.lw -> lw rd', imm(rs1')
                    instr_d_o = {5'b0, instr_c_i[5], instr_c_i[12:10], instr_c_i[6],
                            2'b00, 2'b01, instr_c_i[9:7], 3'b010, 2'b01, instr_c_i[4:2], {LW_OPCODE}};
                end

                3'b110: begin
                    // c.sw -> sw rs2', imm(rs1')
                    instr_d_o = {5'b0, instr_c_i[5], instr_c_i[12], 2'b01, instr_c_i[4:2],
                            2'b01, instr_c_i[9:7], 3'b010, instr_c_i[11:10], instr_c_i[6],
                            2'b00, {SW_OPCODE}};
                end

                3'b001,
                3'b011,
                3'b100,
                3'b101,
                3'b111: begin
                    instr_illegal_o = 1'b1;
                end

                default: begin
                    instr_illegal_o = 1'b1;
                end
            endcase
        end

        // C1
        //
        // Register address checks for RV32E are performed in the regular instruction decoder.
        // If this check fails, an illegal instruction exception is triggered and the controller
        // writes the actual faulting instruction to mtval.
        2'b01: begin
            case (instr_c_i[15:13])
                3'b000: begin
                    // c.addi -> addi rd, rd, nzimm
                    // c.nop
                    instr_d_o = {{6 {instr_c_i[12]}}, instr_c_i[12], instr_c_i[6:2],
                            instr_c_i[11:7], 3'b0, instr_c_i[11:7], {IMMEDIATE_OPCODE}};
                end

                3'b001, 3'b101: begin
                    // 001: c.jal -> jal x1, imm
                    // 101: c.j   -> jal x0, imm
                    instr_d_o = {instr_c_i[12], instr_c_i[8], instr_c_i[10:9], instr_c_i[6],
                            instr_c_i[7], instr_c_i[2], instr_c_i[11], instr_c_i[5:3],
                            {9 {instr_c_i[12]}}, 4'b0, ~instr_c_i[15], {JAL_OPCODE}};
                end

                3'b010: begin
                    // c.li -> addi rd, x0, nzimm
                    // (c.li hints are translated into an addi hint)
                    instr_d_o = {{6 {instr_c_i[12]}}, instr_c_i[12], instr_c_i[6:2], 5'b0,
                            3'b0, instr_c_i[11:7], {IMMEDIATE_OPCODE}};
                end

                3'b011: begin
                    // c.lui -> lui rd, imm
                    // (c.lui hints are translated into a lui hint)
                    instr_d_o = {{15 {instr_c_i[12]}}, instr_c_i[6:2], instr_c_i[11:7], {LUI_OPCODE}};

                    if (instr_c_i[11:7] == 5'h02) begin
                    // c.addi16sp -> addi x2, x2, nzimm
                    instr_d_o = {{3 {instr_c_i[12]}}, instr_c_i[4:3], instr_c_i[5], instr_c_i[2],
                                instr_c_i[6], 4'b0, 5'h02, 3'b000, 5'h02, {IMMEDIATE_OPCODE}};
                    end

                    if ({instr_c_i[12], instr_c_i[6:2]} == 6'b0) instr_illegal_o = 1'b1;
                end

                3'b100: begin
                    case (instr_c_i[11:10])
                        2'b00,
                        2'b01: begin
                            // 00: c.srli -> srli rd, rd, shamt
                            // 01: c.srai -> srai rd, rd, shamt
                            // (c.srli/c.srai hints are translated into a srli/srai hint)
                            instr_d_o = {1'b0, instr_c_i[10], 5'b0, instr_c_i[6:2], 2'b01, instr_c_i[9:7],
                                    3'b101, 2'b01, instr_c_i[9:7], {IMMEDIATE_OPCODE}};
                            if (instr_c_i[12] == 1'b1)  instr_illegal_o = 1'b1;
                        end

                        2'b10: begin
                            // c.andi -> andi rd, rd, imm
                            instr_d_o = {{6 {instr_c_i[12]}}, instr_c_i[12], instr_c_i[6:2], 2'b01, instr_c_i[9:7],
                                    3'b111, 2'b01, instr_c_i[9:7], {IMMEDIATE_OPCODE}};
                        end

                        2'b11: begin
                            case ({instr_c_i[12], instr_c_i[6:5]})
                                3'b000: begin
                                    // c.sub -> sub rd', rd', rs2'
                                    instr_d_o = {2'b01, 5'b0, 2'b01, instr_c_i[4:2], 2'b01, instr_c_i[9:7],
                                            3'b000, 2'b01, instr_c_i[9:7], {RTYPE_OPCODE}};
                                end

                                3'b001: begin
                                    // c.xor -> xor rd', rd', rs2'
                                    instr_d_o = {7'b0, 2'b01, instr_c_i[4:2], 2'b01, instr_c_i[9:7], 3'b100,
                                            2'b01, instr_c_i[9:7], {RTYPE_OPCODE}};
                                end

                                3'b010: begin
                                    // c.or  -> or  rd', rd', rs2'
                                    instr_d_o = {7'b0, 2'b01, instr_c_i[4:2], 2'b01, instr_c_i[9:7], 3'b110,
                                            2'b01, instr_c_i[9:7], {RTYPE_OPCODE}};
                                end

                                3'b011: begin
                                    // c.and -> and rd', rd', rs2'
                                    instr_d_o = {7'b0, 2'b01, instr_c_i[4:2], 2'b01, instr_c_i[9:7], 3'b111,
                                            2'b01, instr_c_i[9:7], {RTYPE_OPCODE}};
                                end

                                3'b100,
                                3'b101,
                                3'b110,
                                3'b111: begin
                                    // 100: c.subw
                                    // 101: c.addw
                                    instr_illegal_o = 1'b1;
                            end

                            default: begin
                                instr_illegal_o = 1'b1;
                            end
                        endcase
                    end

                    default: begin
                        instr_illegal_o = 1'b1;
                    end
                endcase
            end

            3'b110, 3'b111: begin
                // 0: c.beqz -> beq rs1', x0, imm
                // 1: c.bnez -> bne rs1', x0, imm
                instr_d_o = {{4 {instr_c_i[12]}}, instr_c_i[6:5], instr_c_i[2], 5'b0, 2'b01,
                        instr_c_i[9:7], 2'b00, instr_c_i[13], instr_c_i[11:10], instr_c_i[4:3],
                        instr_c_i[12], {BRANCH_OPCODE}};
            end

            default: begin
                instr_illegal_o = 1'b1;
            end
            endcase
        end

        // C2
        //
        // Register address checks for RV32E are performed in the regular instruction decoder.
        // If this check fails, an illegal instruction exception is triggered and the controller
        // writes the actual faulting instruction to mtval.
        2'b10: begin
            case (instr_c_i[15:13])
                3'b000: begin
                    // c.slli -> slli rd, rd, shamt
                    // (c.ssli hints are translated into a slli hint)
                    instr_d_o = {7'b0, instr_c_i[6:2], instr_c_i[11:7], 3'b001, instr_c_i[11:7], {IMMEDIATE_OPCODE}};
                    if (instr_c_i[12] == 1'b1)  instr_illegal_o = 1'b1; // reserved for custom extensions
                end

                3'b010: begin
                    // c.lwsp -> lw rd, imm(x2)
                    instr_d_o = {4'b0, instr_c_i[3:2], instr_c_i[12], instr_c_i[6:4], 2'b00, 5'h02,
                            3'b010, instr_c_i[11:7], LW_OPCODE};
                    if (instr_c_i[11:7] == 5'b0)  instr_illegal_o = 1'b1;
                end

                3'b100: begin
                    if (instr_c_i[12] == 1'b0) begin
                        if (instr_c_i[6:2] != 5'b0) begin
                            // c.mv -> add rd/rs1, x0, rs2
                            // (c.mv hints are translated into an add hint)
                            instr_d_o = {7'b0, instr_c_i[6:2], 5'b0, 3'b0, instr_c_i[11:7], {RTYPE_OPCODE}};
                        end else begin
                            // c.jr -> jalr x0, rd/rs1, 0
                            instr_d_o = {12'b0, instr_c_i[11:7], 3'b0, 5'b0, {JALR_OPCODE}};
                            if (instr_c_i[11:7] == 5'b0) instr_illegal_o = 1'b1;
                        end
                    end else begin
                        if (instr_c_i[6:2] != 5'b0) begin
                            // c.add -> add rd, rd, rs2
                            // (c.add hints are translated into an add hint)
                            instr_d_o = {7'b0, instr_c_i[6:2], instr_c_i[11:7], 3'b0, instr_c_i[11:7], {RTYPE_OPCODE}};
                        end else begin
                            if (instr_c_i[11:7] == 5'b0) begin
                                // c.ebreak -> ebreak
                                instr_d_o = {32'h00_10_00_73};
                            end else begin
                                // c.jalr -> jalr x1, rs1, 0
                                instr_d_o = {12'b0, instr_c_i[11:7], 3'b000, 5'b00001, {JALR_OPCODE}};
                            end
                        end
                    end
                end

                3'b110: begin
                    // c.swsp -> sw rs2, imm(x2)
                    instr_d_o = {4'b0, instr_c_i[8:7], instr_c_i[12], instr_c_i[6:2], 5'h02, 3'b010,
                            instr_c_i[11:9], 2'b00, {SW_OPCODE}};
                end

                3'b001,
                3'b011,
                3'b101,
                3'b111: begin
                    instr_illegal_o = 1'b1;
                end

                default: begin
                    instr_illegal_o = 1'b1;
                end
            endcase
        end

        // Incoming instruction is not compressed.
        2'b11:;

        default: begin
            instr_illegal_o = 1'b1;
        end
    endcase
end

assign instr_is_c_o = (instr_c_i[1:0] != 2'b11);
wire second_instr_is_c = (instr_c_i[17:16] != 2'b11);

endmodule