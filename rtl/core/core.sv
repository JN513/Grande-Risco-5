`include "defines.vh"
`include "grande_risco5_types.sv"

module Core #(
    parameter BOOT_ADDRESS = 32'h00000000
) (
    // Control signal
    input logic clk,
    input logic rst_n,

    // Instruction BUS

    output logic flush_bus,
    output logic instruction_request,
    input  logic instruction_response,
    input  logic [31:0] instruction_data,
    output logic [31:0] instruction_address,

    // Data BUS
    input  logic data_memory_response,
    output logic data_memory_read,
    output logic data_memory_write,
    input  logic [31:0] read_data,
    output logic [31:0] data_address,
    output logic [31:0] write_data
);

IFID #(
    .BOOT_ADDRESS (BOOT_ADDRESS)
) First_Stage (
    .clk                    (clk),
    .rst_n                  (rst_n),

    .is_jalr_i              (),
    .takebranch_i           (),
    .memory_stall_i         (),
    .execute_stall_i        (),
    .INSTRUCTION_i          (),
    .BRANCH_ADDRESS_i       (),
    .IMMEDIATE_i            (),
    .IMMEDIATE_REG_i        (),
    .forward_out_a_i        (),

    .is_jal_o               (),
    .IFID_PC_o              (),
    .IFID_IR_o              (),

    .flush_bus_o            (),
    .instruction_request_o  (),
    .instruction_response_i (),
    .instruction_data_i     (),
    .instruction_addr_o     (),
);

IDEX Second_Stage (
    .clk                               (clk),
    .rst_n                             (rst_n),

    .is_jal_i                          (is_jal_i),
    .branch_flush_i                    (branch_flush_i),
    .memory_stall_i                    (memory_stall_i),
    .EXMEMop_i                         (EXMEMop_i),
    .IFIDPC_i                          (IFIDPC_i),
    .IFIDIR_i                          (IFIDIR_i),
    .IFID_is_compressed_instruction_i  (IFID_is_compressed_instruction_i),
    .register_data_1_i                 (register_data_1_i),
    .register_data_2_i                 (register_data_2_i),
    .MEMWBValue_i                      (MEMWBValue_i),
    .EXMEMALUOut_i                     (EXMEMALUOut_i),
    .EXMEMrd_i                         (EXMEMrd_i),
    .MEMWBrd_i                         (MEMWBrd_i),
    .IMMEDIATE_REG_i                   (IMMEDIATE_REG_i),

    .forward_out_a_o                   (forward_out_a_o),
    .forward_out_b_o                   (forward_out_b_o),
    .MDU_data_o                        (MDU_data_o),
    .ALU_data_o                        (ALU_data_o),

    .execute_stall_o                   (execute_stall_o),
    .is_jalr_o                         (is_jalr_o),
    .zero_o                            (zero_o),
    .IDEX_is_compressed_instruction_o  (IDEX_is_compressed_instruction_o),
    .takebranch_o                      (takebranch_o),
    .BRANCH_ADDRESS_o                  (BRANCH_ADDRESS_o),

    .IDEXIR_o                          (IDEXIR_o),
    .IDEXPC_o                          (IDEXPC_o),

    `ifdef ENABLE_MDU
    .mdu_operation_o                   (mdu_operation_o),
    `endif

    .is_immediate_o                    (is_immediate_o),
    .immediate_o                       (immediate_o),
    .execute_stall_o                   (execute_stall_o)
);

EXMEM Third_Stage (
    .clk                   (clk),
    .rst_n                 (rst_n),

    .execute_stall_i       (execute_stall_i),
    .immediate_i           (immediate_i),
    .IDEXIR_i              (IDEXIR_i),
    .ALU_data_i            (ALU_data_i),
    .MDU_data_i            (MDU_data_i),
    .mdu_operation_i       (mdu_operation_i),
    .forward_out_b_i       (forward_out_b_i),

    .memory_stall_o        (memory_stall_o),

    `ifdef ENABLE_MDU
    .EXMEMMDUop_o         (EXMEMMDUop_o),
    .EXMEMMDUOut_o        (EXMEMMDUOut_o),
    `endif

    .EXMEMALUOut_o        (EXMEMALUOut_o),
    .EXMEMIR_o            (EXMEMIR_o),
    .Merge_Word_o         (Merge_Word_o),
    .IMMEDIATE_REG_o      (IMMEDIATE_REG_o),
    .Merged_Word_o        (Merged_Word_o),

    // Data BUS
    .data_memory_response (data_memory_response),
    .data_memory_read     (data_memory_read),
    .data_memory_write    (data_memory_write),
    .read_data            (read_data),
    .data_address         (data_address),
    .write_data           (write_data)
);


EXMEM Third_Stage (
    .clk                   (clk),
    .rst_n                 (rst_n),

    .execute_stall_i       (execute_stall_i),
    .immediate_i           (immediate_i),
    .IDEXIR_i              (IDEXIR_i),
    .ALU_data_i            (ALU_data_i),
    .MDU_data_i            (MDU_data_i),
    .mdu_operation_i       (mdu_operation_i),
    .forward_out_b_i       (forward_out_b_i),

    .memory_stall_o        (memory_stall_o),

    `ifdef ENABLE_MDU
    .EXMEMMDUop_o          (EXMEMMDUop_o),
    .EXMEMMDUOut_o         (EXMEMMDUOut_o),
    `endif

    .EXMEMALUOut_o         (EXMEMALUOut_o),
    .EXMEMIR_o             (EXMEMIR_o),
    .Merge_Word_o          (Merge_Word_o),
    .IMMEDIATE_REG_o       (IMMEDIATE_REG_o),
    .Merged_Word_o         (Merged_Word_o),

    // Data BUS
    .data_memory_response  (data_memory_response),
    .data_memory_read      (data_memory_read),
    .data_memory_write     (data_memory_write),
    .read_data             (read_data),
    .data_address          (data_address),
    .write_data            (write_data)
);


endmodule
