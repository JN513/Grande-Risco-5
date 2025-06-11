`include "defines.vh"

module Core #(
    parameter BOOT_ADDRESS           = 32'h00000000,
    parameter BRANCH_PREDICTION_SIZE = 512,
    parameter CLK_FREQ               = 100_000_000
) (
    // Control signal
    input  logic clk,
    input  logic halt,
    input  logic rst_n,

    // Instruction BUS
    output logic instr_flush_o,
    output logic instr_req_o,
    input  logic instr_rsp_i,
    input  logic [31:0] instr_data_i,
    output logic [31:0] instr_addr_o,

    // Data BUS
    input  logic data_mem_rsp_i,
    output logic data_mem_rd_o,
    output logic data_mem_wr_o,
    input  logic [31:0] data_read_i,
    output logic [31:0] data_addr_o,
    output logic [31:0] data_write_o,

    input  logic external_interruption_i,

    // Jtag interface
    input  logic        jtag_we_en_i,
    input  logic [4:0]  jtag_addr_i,
    input  logic [31:0] jtag_data_i,
    output logic [31:0] jtag_data_o,

    input  logic jtag_halt_flag_i,
    input  logic jtag_reset_flag_i  
);

logic halted, halted_clk;
assign halted = halt || jtag_halt_flag_i;
assign halted_clk = ~halted && clk;

// Importando os opcodes do pacote
import opcodes_pkg::*;

// Fios intermediários
logic is_jal;
logic takebranch;
logic execute_stall;
logic memory_stall;
logic [31:0] IFID_PC;
logic [31:0] IFID_IR;
logic [31:0] BRANCH_ADDRESS;
logic [31:0] NON_BRANCH_ADDRESS;
logic [31:0] IDEX_PC;
logic [31:0] IDEX_IR;
logic [31:0] CSR_data;
logic [31:0] ALU_data;
logic [31:0] MDU_data;
logic [31:0] EXMEM_ALUOut;
logic [31:0] EXMEM_IR;
logic [31:0] EXMEM_PC;
logic [31:0] Merged_Word;
logic [31:0] forward_out_a;
logic [31:0] forward_out_b;
logic [31:0] MEMWB_RD;
logic [31:0] MEMWB_PC;
logic [4:0] MEMWB_RD_ADDR;
logic reg_wr_en;
logic [31:0] register_data_1;
logic [31:0] register_data_2;
logic [31:0] immediate_reg;
logic [31:0] immediate;
logic is_immediate;
logic take_jalr;
logic take_jal;
logic zero;
logic invalid_fetch_instruction;
logic invalid_decode_instruction;
logic is_branch;
logic is_jalr;
logic is_compressed;
logic memory_operation;
logic instruction_finished;
logic branch_flush;
logic [6:0] EXMEMop;
logic [4:0] EXMEM_RD;
logic [4:0] IFIDrs1, IFIDrs2, IFIDrd;
logic [4:0] MEMWBrd;
logic [2:0] IFIDfunc3;

logic IFID_trap_flush;
logic [31:0] trap_pc;
logic IDEX_trap_flush;
logic EXMEM_trap_flush;
logic software_interruption;
logic unaligned_access;
logic exmem_sw_opcode;
logic memwb_sw_opcode;

`ifdef ENABLE_MDU
logic mdu_operation;
`endif

logic [6:0] IFIDop, IDEXop;

// Estágio IF/ID
IFID #(
    .BOOT_ADDRESS           (BOOT_ADDRESS),
    .BRANCH_PREDICTION_SIZE (BRANCH_PREDICTION_SIZE)
) IFID_Stage (
    .clk                              (clk),
    .rst_n                            (rst_n),

    .take_jalr_i                      (take_jalr),
    .is_branch_i                      (is_branch),
    .is_jalr_i                        (is_jalr),
    .takebranch_i                     (takebranch),
    .memory_stall_i                   (memory_stall),
    .execute_stall_i                  (execute_stall),

    .trap_flush_i                     (IFID_trap_flush),
    .trap_pc_i                        (trap_pc),

    .BRANCH_ADDRESS_i                 (BRANCH_ADDRESS),
    .NON_BRANCH_ADDRESS_i             (NON_BRANCH_ADDRESS),
    .IMMEDIATE_i                      (immediate),
    .IMMEDIATE_REG_i                  (immediate_reg),
    .forward_out_a_i                  (forward_out_a),
    .IFID_is_compressed_instruction_o (is_compressed),
    .IDEX_PC_i                        (IDEX_PC),
    .EXMEM_PC_i                       (EXMEM_PC),
    .branch_flush_o                   (branch_flush),

    .take_jal_o                       (take_jal),
    .illegal_compressed_instruction_o (invalid_fetch_instruction),
    .illegal_decode_instruction_o     (invalid_decode_instruction),
    .is_jal_o                         (is_jal),
    .IFID_PC_o                        (IFID_PC),
    .IFID_IR_o                        (IFID_IR),

    .flush_bus_o                      (instr_flush_o),
    .instruction_request_o            (instr_req_o),
    .instruction_response_i           (instr_rsp_i),
    .instruction_data_i               (instr_data_i),
    .instruction_addr_o               (instr_addr_o),

    .jtag_reset_flag_i                (jtag_reset_flag_i)
);

// Estágio ID/EX
IDEX IDEX_Stage (
    .clk                               (clk),
    .rst_n                             (rst_n),

    .PC_i                              (instr_addr_o),

    .trap_flush_i                      (IDEX_trap_flush),

    .take_jal_i                        (take_jal),
    .is_branch_o                       (is_branch),
    .is_jal_i                          (is_jal),
    .branch_flush_i                    (branch_flush),
    .memory_stall_i                    (memory_stall),
    .EXMEMop_i                         (EXMEMop),
    .IFIDPC_i                          (IFID_PC),
    .IFIDIR_i                          (IFID_IR),
    .IFID_is_compressed_instruction_i  (is_compressed),
    .register_data_1_i                 (register_data_1),
    .register_data_2_i                 (register_data_2),
    .MEMWBValue_i                      (MEMWB_RD),
    .EXMEMALUOut_i                     (EXMEM_ALUOut),
    .EXMEMrd_i                         (EXMEM_RD),
    .MEMWBrd_i                         (MEMWB_RD_ADDR),
    .IMMEDIATE_REG_i                   (immediate_reg),

    .forward_out_a_o                   (forward_out_a),
    .forward_out_b_o                   (forward_out_b),
    .MDU_data_o                        (MDU_data),
    .ALU_data_o                        (ALU_data),

    .take_jalr_o                       (take_jalr),
    .execute_stall_o                   (execute_stall),
    .is_jalr_o                         (is_jalr),
    .zero_o                            (zero),
    .IDEX_is_compressed_instruction_o  (),
    .takebranch_o                      (takebranch),
    .BRANCH_ADDRESS_o                  (BRANCH_ADDRESS),
    .NON_BRANCH_ADDRESS_o              (NON_BRANCH_ADDRESS),
    .exmem_sw_opcode_i                 (exmem_sw_opcode),
    .memwb_sw_opcode_i                 (memwb_sw_opcode),

    .IDEXIR_o                          (IDEX_IR),
    .IDEXPC_o                          (IDEX_PC),

    `ifdef ENABLE_MDU
    .mdu_operation_o                   (mdu_operation),
    `endif

    .is_immediate_o                    (is_immediate),
    .immediate_o                       (immediate)
);

// Estágio EX/MEM
EXMEM EXMEM_Stage (
    .clk                   (clk),
    .rst_n                 (rst_n),

    .trap_flush_i          (EXMEM_trap_flush),

    .execute_stall_i       (execute_stall),
    .immediate_i           (immediate),
    .IDEXIR_i              (IDEX_IR),
    .IDEXPC_i              (IDEX_PC),
    .CSR_data_i            (CSR_data),
    .ALU_data_i            (ALU_data),
    .MDU_data_i            (MDU_data),
    `ifdef ENABLE_MDU
    .mdu_operation_i       (mdu_operation),
    `endif
    .forward_out_b_i       (forward_out_b),

    .memory_stall_o        (memory_stall),

    .EXMEMALUOut_o         (EXMEM_ALUOut),
    .EXMEMIR_o             (EXMEM_IR),
    .EXMEMPC_o             (EXMEM_PC),
    .IMMEDIATE_REG_o       (immediate_reg),
    .Merged_Word_o         (Merged_Word),
    .memory_operation_o    (memory_operation),
    .EXMEMop_o             (EXMEMop),
    .EXMEMrd_o             (EXMEM_RD),
    .unaligned_access_o    (unaligned_access),
    .exmem_sw_opcode_o     (exmem_sw_opcode),

    // Data BUS
    .data_memory_response  (data_mem_rsp_i),
    .data_memory_read      (data_mem_rd_o),
    .data_memory_write     (data_mem_wr_o),
    .read_data             (data_read_i),
    .data_address          (data_addr_o),
    .write_data            (data_write_o)
);

// Estágio MEM/WB
MEMWB MEMWB_Stage (
    .clk                    (clk),
    .rst_n                  (rst_n),

    .EXMEMALUOut_i          (EXMEM_ALUOut),
    .EXMEM_IR_i             (EXMEM_IR),
    .EXMEM_PC_i             (EXMEM_PC),
    .read_data_i            (data_read_i),
    .Merged_word_i          (Merged_Word),
    .memory_operation_i     (memory_operation),
    .unaligned_access_i     (unaligned_access),

    .memory_stall_i         (memory_stall),
    .memwb_sw_opcode_o      (memwb_sw_opcode),

    .instruction_finished_o (instruction_finished),
    .reg_wr_en_o            (reg_wr_en),
    .MEMWB_RD_ADDR_o        (MEMWB_RD_ADDR),
    .MEMWB_RD_o             (MEMWB_RD),
    .MEMWB_PC_o             (MEMWB_PC)
);

Registers RegisterBank(
    .clk        (clk),
    .wr_en_i    (reg_wr_en),
    .RS1_ADDR_i (IFIDrs1),
    .RS2_ADDR_i (IFIDrs2),
    .RD_ADDR_i  (MEMWB_RD_ADDR),
    .data_i     (MEMWB_RD),
    .RS1_data_o (register_data_1),
    .RS2_data_o (register_data_2),

    // JTAG interface
    .jtag_we_en_i (jtag_we_en_i), // JTAG write enable
    .jtag_addr_i  (jtag_addr_i),  // JTAG address
    .jtag_data_i  (jtag_data_i),  // JTAG data input
    .jtag_data_o  (jtag_data_o)   // JTAG data output
);


CSR_Unit #(
    .CLK_FREQ                   (CLK_FREQ)
) CSR(
    .clk                        (clk),
    .rst_n                      (rst_n),

    .csr_wr_en                  (IDEXop == CSR_OPCODE),
    
    .func3_i                    (IDEX_IR[14:12]),
    .csr_imm_i                  (IDEX_IR[19:15]),
    .csr_addr_i                 (IDEX_IR[31:20]),

    .csr_data_in                (forward_out_a),
    .csr_data_out               (CSR_data),

    .invalid_fetch_instruction  (invalid_fetch_instruction),
    .invalid_decode_instruction (invalid_decode_instruction),
    .instruction_finished       (instruction_finished),
    
    .fetch_pc                   (instr_addr_o),
    .decode_pc                  (IFID_PC),
    .execute_pc                 (IDEX_PC),
    .memory_pc                  (EXMEM_PC),
    .writeback_pc               (MEMWB_PC),

    .IDEX_trap_flush_o          (IDEX_trap_flush),
    .EXMEM_trap_flush_o         (EXMEM_trap_flush),
    .IFID_trap_flush_o          (IFID_trap_flush),
    .trap_pc_o                  (trap_pc),

    .external_interruption_i    (external_interruption_i),
    .software_interruption_i    (software_interruption)
);

// Software Interruption logic, causes by ecalls and mret
always_ff @(posedge clk) begin
    software_interruption <= (IFIDop == CSR_OPCODE) && ~|IFIDfunc3;
end

assign IFIDfunc3 = IFID_IR[14:12];
assign IFIDop    = IFID_IR[6:0];
assign IFIDrs1   = IFID_IR[19:15];
assign IFIDrs2   = IFID_IR[24:20];
assign IFIDrd    = IFID_IR[11:7];
assign IDEXop    = IDEX_IR[6:0];

endmodule
