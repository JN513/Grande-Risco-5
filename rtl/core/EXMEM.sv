`include "defines.vh"

module EXMEM (
    input logic clk,
    input logic rst_n,

    input logic trap_flush_i,

    input logic execute_stall_i,
    input logic [31:0] immediate_i,
    input logic [31:0] IDEXIR_i,
    input logic [31:0] IDEXPC_i,
    input logic [31:0] CSR_data_i,
    input logic [31:0] ALU_data_i,
    input logic [31:0] MDU_data_i,
    `ifdef ENABLE_MDU
    input logic mdu_operation_i,
    `endif
    input logic [31:0] forward_out_b_i,

    output logic memory_stall_o,

    output logic [31:0] EXMEMALUOut_o,
    output logic [31:0] EXMEMIR_o,
    output logic [31:0] EXMEMPC_o,
    output logic [31:0] IMMEDIATE_REG_o,
    output logic [31:0] Merged_Word_o,
    output logic memory_operation_o,
    output logic [6:0] EXMEMop_o,
    output logic [4:0] EXMEMrd_o,

    // Data BUS

    input  logic data_memory_response,
    output logic data_memory_read,
    output logic data_memory_write,
    input  logic [31:0] read_data,
    output logic [31:0] data_address,
    output logic [31:0] write_data
);

// Importando os opcodes do pacote
import opcodes_pkg::*;

logic memory_read, memory_write;
logic [2:0] EXMEMfunc3;
logic [4:0] EXMEMfunc5;
logic [4:0] EXMEMrd;
logic [6:0] EXMEMop, IDEXop;
logic [31:0] EXMEM_mem_data_value;

// Unaligned logic

logic unaligned_access_in_progress;
assign memory_stall_o = (memory_operation_o & ~data_memory_response) | unaligned_access_in_progress;


logic is_unaligned_address;

assign is_unaligned_address = (memory_operation_o && EXMEMALUOut_o[1:0] != 2'b00);

typedef enum logic [3:0] { 
    IDLE                      = 4'b0000,
    READ_FIRST_WORD           = 4'b0001,
    READ_SECOND_WORD          = 4'b0010,
    MERGE_WORDS               = 4'b0011,
    READ_FIRST_WORD_TO_WRITE  = 4'b0100,
    MODIFY_FIRST_WORD         = 4'b0101,
    WRITE_FIRST_WORD          = 4'b0110,
    READ_SECOND_WORD_TO_WRITE = 4'b0111,
    MODIFY_SECOND_WORD        = 4'b1000,
    WRITE_SECOND_WORD         = 4'b1001,
    CUT_WORDS                 = 4'b1010
} unaligned_acess_state_t;

unaligned_acess_state_t unaligned_access_state;
logic [31:0] First_Word, Second_Word, Data_Address;

always_ff @(posedge clk ) begin : EXMEM_STAGE
    memory_write <= 1'b0;
    memory_read  <= 1'b0;

    if(!rst_n || trap_flush_i) begin
        unaligned_access_in_progress <= 1'b0;
        unaligned_access_state       <= IDLE;
        EXMEMIR_o                    <= NOP;
        EXMEMPC_o                    <= 'd0;
    end else if(unaligned_access_in_progress) begin 
        case (unaligned_access_state)
            IDLE: begin
                memory_operation_o <= 1'b0;
                if(EXMEMop == LW_OPCODE) begin
                    unaligned_access_state <= READ_FIRST_WORD;
                end else if(EXMEMop == SW_OPCODE) begin
                    unaligned_access_state <= READ_FIRST_WORD_TO_WRITE;
                end
                memory_read  <= 1'b1;
                memory_write <= 1'b0;
            end
            READ_FIRST_WORD: begin
                memory_read <= 1'b1;
                if(data_memory_response) begin
                    unaligned_access_state <= READ_SECOND_WORD;
                    First_Word <= read_data;
                    unaligned_access_state <= READ_SECOND_WORD;
                    Data_Address <= Data_Address + 'd4;
                end
            end
            READ_SECOND_WORD: begin
                memory_read <= 1'b1;
                if(data_memory_response) begin
                    unaligned_access_state <= MERGE_WORDS;
                    Second_Word <= read_data;
                end
            end
            MERGE_WORDS: begin
                if(data_address[1:0] == 2'b01) begin
                    Merged_Word_o <= {Second_Word[7:0], First_Word[31:8]};
                end else if(data_address[1:0] == 2'b10) begin
                    Merged_Word_o <= {Second_Word[15:0], First_Word[31:16]};
                end else if(data_address[1:0] == 2'b11) begin
                    Merged_Word_o <= {Second_Word[23:0], First_Word[31:24]};
                end
                unaligned_access_state <= CUT_WORDS;
            end
            CUT_WORDS: begin
                case (EXMEMfunc3)
                    3'b000: Merged_Word_o <= {{24{Merged_Word_o[7]}}, Merged_Word_o[7:0]};
                    3'b001: Merged_Word_o <= {{16{Merged_Word_o[15]}}, Merged_Word_o[15:0]};
                    3'b100: Merged_Word_o <= {24'h0, Merged_Word_o[7:0]};
                    3'b101: Merged_Word_o <= {16'h0, Merged_Word_o[15:0]};
                    default: Merged_Word_o <= Merged_Word_o;
                endcase

                unaligned_access_state <= IDLE;
                unaligned_access_in_progress <= 1'b0;
            end
            READ_FIRST_WORD_TO_WRITE: begin
                memory_read  <= 1'b1;
                if(data_memory_response) begin
                    unaligned_access_state <= MODIFY_FIRST_WORD;
                    First_Word <= read_data;
                    memory_read <= 1'b0;
                end
            end
            MODIFY_FIRST_WORD: begin
                First_Word <= EXMEM_mem_data_value;
                if(Data_Address[1:0] == 2'b01) begin
                    EXMEM_mem_data_value <= {EXMEM_mem_data_value[23:0], First_Word[7:0]};
                end else if(Data_Address[1:0] == 2'b10) begin
                    EXMEM_mem_data_value <= {EXMEM_mem_data_value[15:0], First_Word[15:0]};
                end else if(Data_Address[1:0] == 2'b11) begin
                    EXMEM_mem_data_value <= {EXMEM_mem_data_value[7:0], First_Word[23:0]};
                end
                memory_write <= 1'b1;
                unaligned_access_state <= WRITE_FIRST_WORD;
            end
            WRITE_FIRST_WORD: begin
                if(data_memory_response) begin
                    unaligned_access_state <= READ_SECOND_WORD_TO_WRITE;
                    Data_Address <= Data_Address + 'd4;
                    memory_read  <= 1'b1;
                end
            end
            READ_SECOND_WORD_TO_WRITE: begin
                memory_read <= 1'b1;
                if(data_memory_response) begin
                    unaligned_access_state <= MODIFY_SECOND_WORD;
                    Second_Word <= read_data;
                    memory_read <= 1'b0;
                end
            end
            MODIFY_SECOND_WORD: begin
                memory_write <= 1'b1;
                if(Data_Address[1:0] == 2'b10) begin
                    EXMEM_mem_data_value <= {Second_Word[31:8], First_Word[31:24]};
                end else if(Data_Address[1:0] == 2'b10) begin
                    EXMEM_mem_data_value <= {Second_Word[31:16], First_Word[31:16]};
                end else if(Data_Address[1:0] == 2'b11) begin
                    EXMEM_mem_data_value <= {Second_Word[31:24], First_Word[31:8]};
                end
                unaligned_access_state <= WRITE_SECOND_WORD;
            end
            WRITE_SECOND_WORD: begin
                if(data_memory_response) begin
                    unaligned_access_state <= IDLE;
                    unaligned_access_in_progress <= 1'b0;
                    memory_write <= 1'b0;
                end
            end
            default: unaligned_access_state <= IDLE;
        endcase
    end else if((execute_stall_i & ~memory_stall_o)) begin
        EXMEMIR_o <= NOP;
        EXMEMPC_o <= 32'd0;
    end else begin
        if(!execute_stall_i && !memory_stall_o)
            IMMEDIATE_REG_o <= immediate_i;
        
        if(!memory_stall_o) begin
            memory_operation_o <= (IDEXop == LW_OPCODE || IDEXop == SW_OPCODE);
            unaligned_access_in_progress <= |ALU_data_i[1:0] && (IDEXop == LW_OPCODE || IDEXop == SW_OPCODE);

            EXMEMIR_o <= IDEXIR_i;
            EXMEMPC_o <= IDEXPC_i;

            Data_Address <= ALU_data_i;


            `ifdef ENABLE_MDU
                EXMEMALUOut_o  <= (IDEXop == CSR_OPCODE) ? CSR_data_i : (mdu_operation_i) ? MDU_data_i : ALU_data_i;
            `else
                EXMEMALUOut_o  <= (IDEXop == CSR_OPCODE) ? CSR_data_i : ALU_data_i;
            `endif

            if(IDEXop == LW_OPCODE) begin
                memory_read <= 1'b1;
            end
            if(IDEXop == SW_OPCODE && ~|ALU_data_i[1:0]) begin // verifica se tem mem
                memory_write <= 1'b1;
            end

            EXMEM_mem_data_value <= forward_out_b_i; 
        end else begin
            memory_operation_o <= (EXMEMop == LW_OPCODE || EXMEMop == SW_OPCODE);

            if(EXMEMop == LW_OPCODE) begin
                memory_read <= 1'b1;
            end
        end
    end   
end

assign IDEXop     = IDEXIR_i[6:0];
assign EXMEMop    = EXMEMIR_o[6:0];
assign EXMEMrd    = EXMEMIR_o[11:7];
assign EXMEMfunc3 = EXMEMIR_o[14:12];
assign EXMEMfunc5 = EXMEMIR_o[31:27];
assign EXMEMop_o  = EXMEMop;
assign EXMEMrd_o  = EXMEMrd;

assign write_data        = EXMEM_mem_data_value;
assign data_address      = Data_Address;
assign data_memory_read  = memory_read;
assign data_memory_write = memory_write;
    
endmodule