`include "defines.vh"

module MEMWB (
    input logic clk,
    input logic rst_n,

    // EXEMEM_INPUT
    input logic [31:0] EXMEMALUOut_i,
    input logic [31:0] EXMEM_IR_i,
    input logic [31:0] EXMEM_PC_i,
    input logic [31:0] read_data_i,
    input logic [31:0] Merged_word_i,
    input logic memory_operation_i,

    input logic memory_stall_i,

    output logic instruction_finished_o,
    output logic reg_wr_en_o,
    output logic [4:0] MEMWB_RD_ADDR_o,
    output logic [31:0] MEMWB_RD_o,
    output logic [31:0] MEMWB_PC_o
);

// Importando os opcodes do pacote
import opcodes_pkg::*;

logic mem_to_reg;
logic [4:0] EXMEMrd;
logic [6:0] MEMWBop, EXMEMop;
logic [31:0] MEMWB_mem_read_data, MEMWBALUOut, MEMWB_IR;
logic is_unaligned_address;

logic [2:0] MEMWB_func3, EXMEM_func3;
logic [31:0] read_data_normalized;

always_ff @(posedge clk ) begin : MEMWB_STAGE
    reg_wr_en_o            <= 1'b0;
    mem_to_reg             <= 1'b0;
    instruction_finished_o <= 1'b0;

    if(!rst_n || memory_stall_i) begin
        MEMWB_IR <= NOP;
    end else begin // memory_stall
        instruction_finished_o <= 1'b1;
        MEMWB_IR               <= EXMEM_IR_i;
        MEMWB_PC_o             <= EXMEM_PC_i;
        MEMWB_mem_read_data    <= (is_unaligned_address) ? Merged_word_i : read_data_normalized;
        
        MEMWBALUOut <= EXMEMALUOut_i;

        // wb stage - five stage

        if ((EXMEMop == RTYPE_OPCODE                 || 
            EXMEMop == IMMEDIATE_OPCODE              || 
            EXMEMop == AUIPC_OPCODE                  || 
            (EXMEMop == CSR_OPCODE && ~|EXMEM_func3) || 
            EXMEMop == LUI_OPCODE                    || 
            EXMEMop == LW_OPCODE                     ||
            EXMEMop == JAL_OPCODE                    ||
            EXMEMop == JALR_OPCODE ) && (|EXMEMrd)) 
        begin
            // verifica se tem wb
            reg_wr_en_o <= 1'b1;
        end

        if(EXMEMop == LW_OPCODE) begin 
            mem_to_reg <= 1'b1;
        end
    end 
end

always_comb begin : NORMALIZE_WORLD
    unique case (EXMEM_func3)
        3'b000: read_data_normalized = {{24{read_data_i[7]}}, read_data_i[7:0]};
        3'b001: read_data_normalized = {{16{read_data_i[15]}}, read_data_i[15:0]};
        3'b010: read_data_normalized = read_data_i;
        3'b100: read_data_normalized = {24'h0, read_data_i[7:0]};
        3'b101: read_data_normalized = {16'h0, read_data_i[15:0]};
        default: read_data_normalized = read_data_i; 
    endcase
end

assign MEMWB_func3          = MEMWB_IR[14:12];
assign EXMEM_func3          = EXMEM_IR_i[14:12];
assign EXMEMop              = EXMEM_IR_i[6:0];
assign EXMEMrd              = EXMEM_IR_i[11:7];
assign MEMWBop              = MEMWB_IR[6:0];
assign MEMWB_RD_ADDR_o      = MEMWB_IR[11:7];
assign MEMWB_RD_o           = (mem_to_reg) ? MEMWB_mem_read_data : MEMWBALUOut;
assign is_unaligned_address = (memory_operation_i && EXMEMALUOut_i[1:0] != 2'b00);


endmodule