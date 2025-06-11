`include "defines.vh"

module IDEX (
    input logic clk,
    input logic rst_n,

    input logic [31:0] PC_i,

    input logic trap_flush_i,

    input logic take_jal_i,
    input logic is_jal_i,
    input logic branch_flush_i,
    input logic memory_stall_i,
    input logic [6:0] EXMEMop_i,
    input logic [31:0] IFIDPC_i,
    input logic [31:0] IFIDIR_i,
    input logic IFID_is_compressed_instruction_i,
    input logic [31:0] register_data_1_i,
    input logic [31:0] register_data_2_i,
    input logic [31:0] MEMWBValue_i,
    input logic [31:0] EXMEMALUOut_i,
    input logic [4:0]  EXMEMrd_i,
    input logic [4:0]  MEMWBrd_i,
    input logic [31:0] IMMEDIATE_REG_i,

    output logic [31:0] forward_out_a_o,
    output logic [31:0] forward_out_b_o,
    output logic [31:0] MDU_data_o,
    output logic [31:0] ALU_data_o,

    output logic take_jalr_o,
    output logic is_branch_o,
    output logic execute_stall_o,
    output logic is_jalr_o,
    output logic zero_o,
    output logic IDEX_is_compressed_instruction_o,
    output logic takebranch_o,
    output logic [31:0] BRANCH_ADDRESS_o,
    output logic [31:0] NON_BRANCH_ADDRESS_o,

    output logic [31:0] IDEXIR_o,
    output logic [31:0] IDEXPC_o,

    `ifdef ENABLE_MDU
    output logic mdu_operation_o,
    `endif
    output logic is_immediate_o,
    output logic [31:0] immediate_o
);

// Importando os opcodes do pacote
import opcodes_pkg::*;

logic zero;
logic mdu_start;
logic func7_lsb, mdu_done, is_immediate_reg_not;
logic [1:0] aluop, op_rs1, op_rs2;
logic [2:0] IDEXfunc3;
logic [3:0] alu_op_o;
logic [3:0] aluop_out;
logic [4:0] IDEXrd, IDEXrs1, IDEXrs2, IDEXfunc5;
logic [6:0] IDEXop, IFIDop;
logic previous_instruction_is_lw;
logic [31:0] IDEXA;
logic [31:0] IDEXB;

assign execute_stall_o = (&op_rs1 || (&op_rs2 && is_immediate_reg_not)
`ifdef ENABLE_MDU
    || (!mdu_done && mdu_operation_o)
`endif
);


always_ff @(posedge clk ) begin : IDEX_STAGE
    is_immediate_reg_not <= ~is_immediate_o;
    is_jalr_o   <= (IDEXop == JALR_OPCODE) && (~execute_stall_o);
    take_jalr_o <= (IDEXop == JALR_OPCODE) && (~execute_stall_o) && (IFIDPC_i != forward_out_a_o + IMMEDIATE_REG_i);
`ifdef ENABLE_MDU
    mdu_start <= 1'b0;
`endif
    //BRANCH_ADDRESS_o     <= IFIDPC_i + immediate_o;
    //NON_BRANCH_ADDRESS_o <= IDEXPC_o + 'd4;
    //is_branch_o          <= (IFIDop == BRANCH_OPCODE);
    IDEX_is_compressed_instruction_o <= IFID_is_compressed_instruction_i;

    if(!rst_n || branch_flush_i || (take_jal_i && ~execute_stall_o)
        || (take_jalr_o && ~execute_stall_o) || trap_flush_i) begin
        IDEXPC_o <= 32'h0;
        IDEXIR_o <= NOP;
        previous_instruction_is_lw <= 1'b0;
        take_jalr_o <= 0;
`ifdef ENABLE_MDU
        mdu_operation_o <= 1'b0;
`endif
    end else begin
        if(!memory_stall_i && !execute_stall_o) begin
            previous_instruction_is_lw <= (IDEXop == LW_OPCODE);
            IDEXIR_o <= IFIDIR_i;
            IDEXPC_o <= IFIDPC_i;
            IDEXA  <= register_data_1_i; 
            IDEXB  <= register_data_2_i;
            alu_op_o <= aluop_out;
            `ifdef ENABLE_MDU
            if(IFIDop == RTYPE_OPCODE && func7_lsb ) begin
                mdu_start <= 1'b1;
                mdu_operation_o <= 1'b1;
            end else
                mdu_operation_o <= 1'b0;
            `endif
        end else begin
            previous_instruction_is_lw <= (EXMEMop_i == LW_OPCODE);
            IDEXA <= forward_out_a_o;
            IDEXB <= forward_out_b_o; // Verificar isso em mais casos tipo um stall antes disso sem forwarding
        end
    end
end


always_comb begin
    case (IFIDop)
        BRANCH_OPCODE: aluop = 2'b01;
        IMMEDIATE_OPCODE, CSR_OPCODE, JALR_OPCODE, RTYPE_OPCODE: 
        aluop = 2'b10;
        default: aluop = 2'b00; // Outros
    endcase

    case (IFIDop)
        IMMEDIATE_OPCODE, LW_OPCODE, SW_OPCODE, AUIPC_OPCODE, LUI_OPCODE: 
        is_immediate_o = 1'b1; // Tipo I: instruções com imediato (e.g., ADDI, SLTI)
        default: is_immediate_o = 1'b0; // Instruções que não usam imediato
    endcase
end

logic [31:0] alu_input_a, alu_input_b;

always_comb begin
    case (IDEXop)
        JAL_OPCODE, JALR_OPCODE, AUIPC_OPCODE: alu_input_a = IDEXPC_o;
        LUI_OPCODE: alu_input_a = 32'h00000000;
        default: alu_input_a = forward_out_a_o;
    endcase

    case (IDEXop)
        JAL_OPCODE, JALR_OPCODE: alu_input_b = (IDEX_is_compressed_instruction_o) ? 32'h2 : 32'h4;
        AUIPC_OPCODE, LUI_OPCODE, SW_OPCODE, IMMEDIATE_OPCODE, LW_OPCODE: 
        alu_input_b = IMMEDIATE_REG_i;
        default: alu_input_b = forward_out_b_o;
    endcase
end


ALU_Control ALU_Control(
    .is_immediate_i (is_immediate_o),
    .ALU_CO_i       (aluop),
    .FUNC7_i        (IFIDIR_i[31:25]),
    .FUNC3_i        (IFIDIR_i[14:12]),
    .ALU_OP_o       (aluop_out)
);

Alu Alu(
    .ALU_OP_i  (alu_op_o),
    .ALU_RS1_i (alu_input_a),
    .ALU_RS2_i (alu_input_b),
    .ALU_RD_o  (ALU_data_o),
    .ALU_ZR_o  (zero)
);

Immediate_Generator Immediate_Generator(
    .instr_i (IFIDIR_i),
    .imm_o   (immediate_o)
);

Forwarding_Unit Forwarding_Unit(
    .rs1_i              (IDEXrs1),
    .rs2_i              (IDEXrs2),
    .ex_mem_rd_i        (EXMEMrd_i),
    .mem_wb_rd_i        (MEMWBrd_i),
    .prev_instr_is_lw_i (previous_instruction_is_lw),
    .fwd_rs1_o          (op_rs1),
    .fwd_rs2_o          (op_rs2)
);

MUX ForwardAMUX(
    .op_i (op_rs1),
    .A_i  (IDEXA),
    .B_i  (MEMWBValue_i),
    .C_i  (EXMEMALUOut_i),
    .D_i  (0),
    .S_o  (forward_out_a_o)
);

MUX ForwardBMUX(
    .op_i (op_rs2),
    .A_i  (IDEXB),
    .B_i  (MEMWBValue_i),
    .C_i  (EXMEMALUOut_i),
    .D_i  (0),
    .S_o  (forward_out_b_o)
);

`ifdef ENABLE_MDU

MDU Mdu(
    .clk       (clk),
    .rst_n     (rst_n),
    .valid_i   (mdu_start),
    .MDU_op_i  (IDEXfunc3),
    .MDU_RS1_i (forward_out_a_o),
    .MDU_RS2_i (forward_out_b_o),
    .ready_o   (mdu_done),
    .MDU_RD_o  (MDU_data_o)
);

`endif

assign is_branch_o  = (IDEXop == BRANCH_OPCODE);
assign zero_o       = zero;
assign takebranch_o = (zero && is_branch_o);
assign IFIDop       = IFIDIR_i[6:0];
assign IDEXop       = IDEXIR_o[6:0];
assign IDEXrd       = IDEXIR_o[11:7];
assign IDEXrs1      = IDEXIR_o[19:15];
assign IDEXrs2      = IDEXIR_o[24:20];
assign IDEXfunc3    = IDEXIR_o[14:12];
assign IDEXfunc5    = IDEXIR_o[31:27];
`ifdef ENABLE_MDU
assign func7_lsb    = IFIDIR_i[25];
`endif

assign NON_BRANCH_ADDRESS_o = IDEXPC_o + 'd4;
assign BRANCH_ADDRESS_o     = IDEXPC_o + IMMEDIATE_REG_i;
endmodule
