// This module is based in ibex implementation, available in: https://github.com/lowRISC/ibex/blob/master/rtl/ibex_compressed_decoder.sv

module IR_Decompression ( // Convert compressed instruction to decompressed instruction
    input  logic [31:0] compressed_instruction,
    output logic is_compressed_instruction,
    output logic [31:0] decompressed_instruction,
    output logic illegal_instruction
);

localparam OPCODE_LOAD     = 7'h03;
localparam OPCODE_MISC_MEM = 7'h0f;
localparam OPCODE_OP_IMM   = 7'h13;
localparam OPCODE_AUIPC    = 7'h17;
localparam OPCODE_STORE    = 7'h23;
localparam OPCODE_OP       = 7'h33;
localparam OPCODE_LUI      = 7'h37;
localparam OPCODE_BRANCH   = 7'h63;
localparam OPCODE_JALR     = 7'h67;
localparam OPCODE_JAL      = 7'h6f;
localparam OPCODE_SYSTEM   = 7'h73;



always_comb begin : DECOMPRESS
    // By default, forward incoming instruction, mark it as legal.
    decompressed_instruction = compressed_instruction;
    illegal_instruction = 1'b0;

    // Check if incoming instruction is compressed.
    case (compressed_instruction[1:0])
        // C0
        2'b00: begin
            case (compressed_instruction[15:13])
                3'b000: begin
                    // c.addi4spn -> addi rd', x2, imm
                    decompressed_instruction = {2'b0, compressed_instruction[10:7], compressed_instruction[12:11], 
                            compressed_instruction[5], compressed_instruction[6], 2'b00, 5'h02, 3'b000, 2'b01, 
                            compressed_instruction[4:2], {OPCODE_OP_IMM}};
                    if (compressed_instruction[12:5] == 8'b0)  illegal_instruction = 1'b1;
                end

                3'b010: begin
                    // c.lw -> lw rd', imm(rs1')
                    decompressed_instruction = {5'b0, compressed_instruction[5], compressed_instruction[12:10], compressed_instruction[6],
                            2'b00, 2'b01, compressed_instruction[9:7], 3'b010, 2'b01, compressed_instruction[4:2], {OPCODE_LOAD}};
                end

                3'b110: begin
                    // c.sw -> sw rs2', imm(rs1')
                    decompressed_instruction = {5'b0, compressed_instruction[5], compressed_instruction[12], 2'b01, compressed_instruction[4:2],
                            2'b01, compressed_instruction[9:7], 3'b010, compressed_instruction[11:10], compressed_instruction[6],
                            2'b00, {OPCODE_STORE}};
                end

                3'b001,
                3'b011,
                3'b100,
                3'b101,
                3'b111: begin
                    illegal_instruction = 1'b1;
                end

                default: begin
                    illegal_instruction = 1'b1;
                end
            endcase
        end

        // C1
        //
        // Register address checks for RV32E are performed in the regular instruction decoder.
        // If this check fails, an illegal instruction exception is triggered and the controller
        // writes the actual faulting instruction to mtval.
        2'b01: begin
            case (compressed_instruction[15:13])
                3'b000: begin
                    // c.addi -> addi rd, rd, nzimm
                    // c.nop
                    decompressed_instruction = {{6 {compressed_instruction[12]}}, compressed_instruction[12], compressed_instruction[6:2],
                            compressed_instruction[11:7], 3'b0, compressed_instruction[11:7], {OPCODE_OP_IMM}};
                end

                3'b001, 3'b101: begin
                    // 001: c.jal -> jal x1, imm
                    // 101: c.j   -> jal x0, imm
                    decompressed_instruction = {compressed_instruction[12], compressed_instruction[8], compressed_instruction[10:9], compressed_instruction[6],
                            compressed_instruction[7], compressed_instruction[2], compressed_instruction[11], compressed_instruction[5:3],
                            {9 {compressed_instruction[12]}}, 4'b0, ~compressed_instruction[15], {OPCODE_JAL}};
                end

                3'b010: begin
                    // c.li -> addi rd, x0, nzimm
                    // (c.li hints are translated into an addi hint)
                    decompressed_instruction = {{6 {compressed_instruction[12]}}, compressed_instruction[12], compressed_instruction[6:2], 5'b0,
                            3'b0, compressed_instruction[11:7], {OPCODE_OP_IMM}};
                end

                3'b011: begin
                    // c.lui -> lui rd, imm
                    // (c.lui hints are translated into a lui hint)
                    decompressed_instruction = {{15 {compressed_instruction[12]}}, compressed_instruction[6:2], compressed_instruction[11:7], {OPCODE_LUI}};

                    if (compressed_instruction[11:7] == 5'h02) begin
                    // c.addi16sp -> addi x2, x2, nzimm
                    decompressed_instruction = {{3 {compressed_instruction[12]}}, compressed_instruction[4:3], compressed_instruction[5], compressed_instruction[2],
                                compressed_instruction[6], 4'b0, 5'h02, 3'b000, 5'h02, {OPCODE_OP_IMM}};
                    end

                    if ({compressed_instruction[12], compressed_instruction[6:2]} == 6'b0) illegal_instruction = 1'b1;
                end

                3'b100: begin
                    case (compressed_instruction[11:10])
                        2'b00,
                        2'b01: begin
                            // 00: c.srli -> srli rd, rd, shamt
                            // 01: c.srai -> srai rd, rd, shamt
                            // (c.srli/c.srai hints are translated into a srli/srai hint)
                            decompressed_instruction = {1'b0, compressed_instruction[10], 5'b0, compressed_instruction[6:2], 2'b01, compressed_instruction[9:7],
                                    3'b101, 2'b01, compressed_instruction[9:7], {OPCODE_OP_IMM}};
                            if (compressed_instruction[12] == 1'b1)  illegal_instruction = 1'b1;
                        end

                        2'b10: begin
                            // c.andi -> andi rd, rd, imm
                            decompressed_instruction = {{6 {compressed_instruction[12]}}, compressed_instruction[12], compressed_instruction[6:2], 2'b01, compressed_instruction[9:7],
                                    3'b111, 2'b01, compressed_instruction[9:7], {OPCODE_OP_IMM}};
                        end

                        2'b11: begin
                            case ({compressed_instruction[12], compressed_instruction[6:5]})
                                3'b000: begin
                                    // c.sub -> sub rd', rd', rs2'
                                    decompressed_instruction = {2'b01, 5'b0, 2'b01, compressed_instruction[4:2], 2'b01, compressed_instruction[9:7],
                                            3'b000, 2'b01, compressed_instruction[9:7], {OPCODE_OP}};
                                end

                                3'b001: begin
                                    // c.xor -> xor rd', rd', rs2'
                                    decompressed_instruction = {7'b0, 2'b01, compressed_instruction[4:2], 2'b01, compressed_instruction[9:7], 3'b100,
                                            2'b01, compressed_instruction[9:7], {OPCODE_OP}};
                                end

                                3'b010: begin
                                    // c.or  -> or  rd', rd', rs2'
                                    decompressed_instruction = {7'b0, 2'b01, compressed_instruction[4:2], 2'b01, compressed_instruction[9:7], 3'b110,
                                            2'b01, compressed_instruction[9:7], {OPCODE_OP}};
                                end

                                3'b011: begin
                                    // c.and -> and rd', rd', rs2'
                                    decompressed_instruction = {7'b0, 2'b01, compressed_instruction[4:2], 2'b01, compressed_instruction[9:7], 3'b111,
                                            2'b01, compressed_instruction[9:7], {OPCODE_OP}};
                                end

                                3'b100,
                                3'b101,
                                3'b110,
                                3'b111: begin
                                    // 100: c.subw
                                    // 101: c.addw
                                    illegal_instruction = 1'b1;
                            end

                            default: begin
                                illegal_instruction = 1'b1;
                            end
                        endcase
                    end

                    default: begin
                        illegal_instruction = 1'b1;
                    end
                endcase
            end

            3'b110, 3'b111: begin
                // 0: c.beqz -> beq rs1', x0, imm
                // 1: c.bnez -> bne rs1', x0, imm
                decompressed_instruction = {{4 {compressed_instruction[12]}}, compressed_instruction[6:5], compressed_instruction[2], 5'b0, 2'b01,
                        compressed_instruction[9:7], 2'b00, compressed_instruction[13], compressed_instruction[11:10], compressed_instruction[4:3],
                        compressed_instruction[12], {OPCODE_BRANCH}};
            end

            default: begin
                illegal_instruction = 1'b1;
            end
            endcase
        end

        // C2
        //
        // Register address checks for RV32E are performed in the regular instruction decoder.
        // If this check fails, an illegal instruction exception is triggered and the controller
        // writes the actual faulting instruction to mtval.
        2'b10: begin
            case (compressed_instruction[15:13])
                3'b000: begin
                    // c.slli -> slli rd, rd, shamt
                    // (c.ssli hints are translated into a slli hint)
                    decompressed_instruction = {7'b0, compressed_instruction[6:2], compressed_instruction[11:7], 3'b001, compressed_instruction[11:7], {OPCODE_OP_IMM}};
                    if (compressed_instruction[12] == 1'b1)  illegal_instruction = 1'b1; // reserved for custom extensions
                end

                3'b010: begin
                    // c.lwsp -> lw rd, imm(x2)
                    decompressed_instruction = {4'b0, compressed_instruction[3:2], compressed_instruction[12], compressed_instruction[6:4], 2'b00, 5'h02,
                            3'b010, compressed_instruction[11:7], OPCODE_LOAD};
                    if (compressed_instruction[11:7] == 5'b0)  illegal_instruction = 1'b1;
                end

                3'b100: begin
                    if (compressed_instruction[12] == 1'b0) begin
                        if (compressed_instruction[6:2] != 5'b0) begin
                            // c.mv -> add rd/rs1, x0, rs2
                            // (c.mv hints are translated into an add hint)
                            decompressed_instruction = {7'b0, compressed_instruction[6:2], 5'b0, 3'b0, compressed_instruction[11:7], {OPCODE_OP}};
                        end else begin
                            // c.jr -> jalr x0, rd/rs1, 0
                            decompressed_instruction = {12'b0, compressed_instruction[11:7], 3'b0, 5'b0, {OPCODE_JALR}};
                            if (compressed_instruction[11:7] == 5'b0) illegal_instruction = 1'b1;
                        end
                    end else begin
                        if (compressed_instruction[6:2] != 5'b0) begin
                            // c.add -> add rd, rd, rs2
                            // (c.add hints are translated into an add hint)
                            decompressed_instruction = {7'b0, compressed_instruction[6:2], compressed_instruction[11:7], 3'b0, compressed_instruction[11:7], {OPCODE_OP}};
                        end else begin
                            if (compressed_instruction[11:7] == 5'b0) begin
                                // c.ebreak -> ebreak
                                decompressed_instruction = {32'h00_10_00_73};
                            end else begin
                                // c.jalr -> jalr x1, rs1, 0
                                decompressed_instruction = {12'b0, compressed_instruction[11:7], 3'b000, 5'b00001, {OPCODE_JALR}};
                            end
                        end
                    end
                end

                3'b110: begin
                    // c.swsp -> sw rs2, imm(x2)
                    decompressed_instruction = {4'b0, compressed_instruction[8:7], compressed_instruction[12], compressed_instruction[6:2], 5'h02, 3'b010,
                            compressed_instruction[11:9], 2'b00, {OPCODE_STORE}};
                end

                3'b001,
                3'b011,
                3'b101,
                3'b111: begin
                    illegal_instruction = 1'b1;
                end

                default: begin
                    illegal_instruction = 1'b1;
                end
            endcase
        end

        // Incoming instruction is not compressed.
        2'b11:;

        default: begin
            illegal_instruction = 1'b1;
        end
    endcase
end

assign is_compressed_instruction = (compressed_instruction[1:0] != 2'b11);
wire second_is_compressed_instruction = (compressed_instruction[17:16] != 2'b11);

endmodule