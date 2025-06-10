`include "defines.vh"

module IFID #(
    parameter BOOT_ADDRESS           = 32'h00000000,
    parameter BRANCH_PREDICTION_SIZE = 512
) (
    input  logic clk,
    input  logic rst_n,

    input  logic take_jalr_i,
    input  logic is_branch_i,
    input  logic is_jalr_i,
    input  logic takebranch_i,

    input  logic memory_stall_i,
    input  logic execute_stall_i,
    input  logic trap_flush_i,

    input  logic [31:0] trap_pc_i,
    input  logic [31:0] BRANCH_ADDRESS_i,
    input  logic [31:0] NON_BRANCH_ADDRESS_i,

    input  logic [31:0] IMMEDIATE_i,
    input  logic [31:0] IMMEDIATE_REG_i,
    input  logic [31:0] forward_out_a_i,

    input  logic [31:0] IDEX_PC_i,
    input  logic [31:0] EXMEM_PC_i,

    output logic take_jal_o,
    output logic branch_flush_o,
    output logic illegal_compressed_instruction_o,
    output logic illegal_decode_instruction_o,
    output logic is_jal_o,
    output logic IFID_is_compressed_instruction_o,

    output logic [31:0] IFID_PC_o,
    output logic [31:0] IFID_IR_o,

    // Instruction BUS
    output logic flush_bus_o,
    output logic instruction_request_o,

    input  logic instruction_response_i,

    input  logic [31:0] instruction_data_i,
    output logic [31:0] instruction_addr_o,

    input  logic jtag_reset_flag_i
);

// Importando os opcodes do pacote
import opcodes_pkg::*;

logic [2:0] IFIDfunc3;
logic [4:0] IFIDrs1, IFIDrs2, IFIDrd;
logic [4:0] IFIDfunc5;
logic [6:0] IFIDop;

logic [31:0] PC;

logic prediction_taken;
logic jump_is_predicted;

logic is_different_branch_address, pc_is_unaligned, finish_unaligned_pc, is_different_no_branch_address;
logic illegal_predicted_instruction;

assign illegal_predicted_instruction = (is_different_no_branch_address & !takebranch_i & is_branch_i) && !execute_stall_i;
assign branch_flush_o = (is_different_branch_address & takebranch_i) || illegal_predicted_instruction;

// Unaligned instruction
logic [31:0] temp_instruction, temp_pc;
logic [31:0] unaligned_instruction;
logic [31:0] prediction_address;

assign unaligned_instruction = {instruction_data_i[15:0], temp_instruction[15:0]};

// Desconpressed instruction
logic [31:0] instr_d_o, instr_c_i;
logic is_compressed_instruction;

assign instr_c_i = (finish_unaligned_pc) ? unaligned_instruction : instruction_data_i;

logic [31:0] JAL_PC, JALR_PC;

assign is_different_branch_address    = PC != (IDEX_PC_i + IMMEDIATE_REG_i);
assign is_different_no_branch_address = PC != (IDEX_PC_i + 'd4);

logic is_no_compressed_instr;

assign is_no_compressed_instr = &instruction_data_i[17:16];

always_ff @(posedge clk ) begin // IF/ID
    instruction_request_o <= 1'b1;
    flush_bus_o           <= 1'b0;
    jump_is_predicted     <= 1'b0;

    is_jal_o   <= (IFIDop == JAL_OPCODE) && (!execute_stall_i) && (!memory_stall_i);
    take_jal_o <= (IFIDop == JAL_OPCODE) && (!execute_stall_i) && (!memory_stall_i) && (PC != IFID_PC_o + IMMEDIATE_i) && (!branch_flush_o);

    JAL_PC  <= IFID_PC_o + IMMEDIATE_i;
    JALR_PC <= forward_out_a_i + IMMEDIATE_REG_i;

    //is_different_branch_address    <= PC != (IFID_PC_o + IMMEDIATE_i);
    //is_different_no_branch_address <= PC != (IDEX_PC_i + 'd8);

    IFID_is_compressed_instruction_o <= 1'b0;

    if(!rst_n || jtag_reset_flag_i) begin
        pc_is_unaligned     <= 1'b0;
        PC                  <= BOOT_ADDRESS;
        IFID_IR_o           <= NOP;
        flush_bus_o         <= 1'b0;
        finish_unaligned_pc <= 1'b0;
    end else begin
        if(flush_bus_o) begin
            instruction_request_o <= 1'b1;
        end
        
        if(trap_flush_i) begin
            IFID_IR_o           <= NOP;
            PC                  <= trap_pc_i;
            IFID_PC_o           <= BOOT_ADDRESS;
            pc_is_unaligned     <= trap_pc_i[1];
            finish_unaligned_pc <= 1'b0;
        end else if(take_jal_o) begin
            IFID_IR_o       <= NOP;
            PC              <= JAL_PC; // imediato
            IFID_PC_o       <= BOOT_ADDRESS;
            pc_is_unaligned <= JAL_PC[1];
            if(!instruction_response_i) begin
                flush_bus_o <= 1'b1;
            end

            finish_unaligned_pc <= 1'b0;
        end else if (take_jalr_i) begin 
            IFID_IR_o       <= NOP;
            PC              <= JALR_PC; // imediato
            IFID_PC_o       <= BOOT_ADDRESS;
            pc_is_unaligned <= JALR_PC[1];

            if(!instruction_response_i) begin
                flush_bus_o <= 1'b1;
            end

            finish_unaligned_pc <= 1'b0;
        end else if(branch_flush_o) begin
            IFID_IR_o       <= NOP;
            PC              <= (illegal_predicted_instruction) ? NON_BRANCH_ADDRESS_i : BRANCH_ADDRESS_i; // imediato
            IFID_PC_o       <= BOOT_ADDRESS;
            pc_is_unaligned <= (illegal_predicted_instruction) ? (NON_BRANCH_ADDRESS_i[1]) : (BRANCH_ADDRESS_i[1]);

            if(!instruction_response_i) begin
                flush_bus_o <= 1'b1;
            end

            finish_unaligned_pc <= 1'b0;
        end else begin

            if((!instruction_response_i && !memory_stall_i )) begin //instruction_response_i == 1'b0
                IFID_IR_o <= NOP;
            end else if (!memory_stall_i && !execute_stall_i && !flush_bus_o) begin
                if(finish_unaligned_pc) begin
                    finish_unaligned_pc <= 1'b0;
                    IFID_IR_o <= instr_d_o;
                    IFID_PC_o <= temp_pc;

                    if(illegal_compressed_instruction_o) begin
                        IFID_IR_o <= NOP;
                        IFID_PC_o <= BOOT_ADDRESS;
                    end
                end else if(pc_is_unaligned) begin
                    temp_instruction <= {16'h0, instruction_data_i[31:16]};
                    IFID_IR_o <= NOP;
                    finish_unaligned_pc <= 1'b1;
                    temp_pc <= PC;
                    
                    if(is_no_compressed_instr) begin
                        PC              <= PC + 'd4;
                        pc_is_unaligned <= 1'b1;
                    end else begin
                        PC              <= PC + 'd2;
                        pc_is_unaligned <= 1'b0;
                    end
                end else begin
                    IFID_IR_o                        <= instr_d_o;
                    IFID_is_compressed_instruction_o <= is_compressed_instruction;
                    if(prediction_taken) begin
                        PC                <= prediction_address;
                        pc_is_unaligned   <= prediction_address[1];
                        jump_is_predicted <= 1'b1;
                    end else begin 
                        PC <= PC + ('d4 >> is_compressed_instruction);
                        pc_is_unaligned <= PC[1] ^ is_compressed_instruction;
                    end

                    IFID_PC_o <= PC;
                    
                    if(illegal_compressed_instruction_o) begin
                        IFID_IR_o <= NOP;
                        IFID_PC_o <= BOOT_ADDRESS;
                    end
                end
            end
        end
    end  
end

IR_Decompression IR_Decompression (
    .instr_c_i       (instr_c_i),
    .instr_is_c_o    (is_compressed_instruction),
    .instr_d_o       (instr_d_o),
    .instr_illegal_o (illegal_compressed_instruction_o)
);

logic is_jump;

always_comb begin : IS_JUMP_CHECK
    unique case(instr_d_o[6:0])
        JAL_OPCODE, JALR_OPCODE, BRANCH_OPCODE: is_jump = 1'b1;
        default: is_jump = 1'b0;
    endcase
end

Branch_Prediction #(
    .BRANCH_PREDICTION_SIZE (BRANCH_PREDICTION_SIZE)
) Branch_Prediction (
    .clk                   (clk),
    .rst_n                 (rst_n),

    .PC_i                  (PC),
    .is_jump               (is_jump),

    .branch_address_i      (IDEX_PC_i),
    .branch_taken_i        (takebranch_i),
    .is_branch_i           (is_branch_i),
    .address_to_branch_i   (BRANCH_ADDRESS_i),

    .jal_address_i         (IDEX_PC_i),
    .jalr_address_i        (EXMEM_PC_i),
    .is_jal_i              (is_jal_o),
    .is_jalr_i             (is_jalr_i),
    .address_to_jal_i      (JAL_PC),
    .address_to_jalr_i     (JALR_PC),

    .prediction_taken_o    (prediction_taken),
    .address_o             (prediction_address)
);

Invalid_IR_Check Invalid_IR_Check (
    .instruction            (IFID_IR_o),
    .invalid_instruction_o  (illegal_decode_instruction_o)
);

assign IFIDop    = IFID_IR_o[6:0];
assign IFIDrs1   = IFID_IR_o[19:15];
assign IFIDrs2   = IFID_IR_o[24:20];
assign IFIDfunc3 = IFID_IR_o[14:12];
assign IFIDfunc5 = IFID_IR_o[31:27];
    
assign instruction_addr_o = PC;

endmodule
