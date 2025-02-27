module IFID (
    input logic clk,
    input logic rst_n,

    input logic is_jal_i,
    input logic is_jalr_i,

    input logic memory_stall_i,
    input logic execute_stall_i,

    input logic [31:0] INSTRUCTION_i,

    input logic [31:0] BRANCH_ADDRESS_i,
    input logic [31:0] JAL_PC_i,
    input logic [31:0] JALR_PC_i,

    input logic [31:0] IMMEDIATE_i,

    output logic [31:0] IFID_PC_o,
    output logic [31:0] IFID_IR_o,

    output logic instruction_request_o,
    output logic flush_bus_o,

    input logic instruction_response_i,

    input logic  [31:0] instruction_data_i,
    output logic [31:0] instruction_addr_o
);

localparam NOP              = 32'h00000033; // add x0, x0, x0
localparam LW_OPCODE        = 7'b0000011;
localparam SW_OPCODE        = 7'b0100011;
localparam JAL_OPCODE       = 7'b1101111;
localparam LUI_OPCODE       = 7'b0110111;
localparam CSR_OPCODE       = 7'b1110011;
localparam JALR_OPCODE      = 7'b1100111;
localparam AUIPC_OPCODE     = 7'b0010111;
localparam BRANCH_OPCODE    = 7'b1100011;
localparam IMMEDIATE_OPCODE = 7'b0010011;
localparam RTYPE_OPCODE     = 7'b0110011;
localparam ATOMIC_OPCODE    = 7'b0101111;

logic [2:0] IFIDfunc3;
logic [4:0] IFIDrs1, IFIDrs2, IFIDrd;
logic [4:0] IFIDfunc5;

logic [31:0] PC;

wire branch_flush;
wire zero, execute_stall, takebranch, flush;

reg is_different_branch_address, pc_is_unaligned, finish_unaligned_pc;

assign flush = branch_flush | is_jal;

assign branch_flush = (is_different_branch_address & takebranch);

// Unaligned instruction
reg [31:0] temp_instruction, temp_pc;
wire [31:0] unaligned_instruction;

assign unaligned_instruction = {instruction_data_i[15:0], temp_instruction[15:0]};

// Desconpressed instruction
wire [31:0] instr_d_o, instr_c_i;
wire is_compressed_instruction, illegal_instruction;

assign instr_c_i = (finish_unaligned_pc) ? unaligned_instruction : instruction_data_i;



always @(posedge clk ) begin // IF/ID
    instruction_request_o <= 1'b1;
    flush_bus_o           <= 1'b0;

    is_jal  <= (IFIDop == JAL_OPCODE) && (~execute_stall);
    is_jalr <= (IDEXop == JALR_OPCODE) && (~execute_stall);

    is_different_branch_address <= PC != (IFID_PC_oimmediate);
    IFID_is_compressed_instruction <= 1'b0;

    if(!rst_n) begin
        pc_is_unaligned     <= 1'b0;
        PC                  <= BOOT_ADDRESS;
        IFID_IR_o           <= NOP;
        flush_bus_o           <= 1'b0;
        finish_unaligned_pc <= 1'b0;
    end else begin
        if(flush_bus_o) begin
            instruction_request_o <= 1'b1;
        end
        
        if(is_jal) begin
            IFID_IR_o          <= NOP;
            PC              <= JAL_PC; // imediato
            IFID_PC_o       <= BOOT_ADDRESS;
            pc_is_unaligned <= (JAL_PC[1] == 1'b1);
            if(~instruction_response_i) begin
                flush_bus_o <= 1'b1;
            end

            finish_unaligned_pc <= 1'b0;
        end else if (is_jalr) begin 
            IFID_IR_o          <= NOP;
            PC              <= JALR_PC; // imediato
            IFID_PC_o       <= BOOT_ADDRESS;
            pc_is_unaligned <= (JALR_PC[1] == 1'b1);

            if(!instruction_response_i) begin
                flush_bus_o <= 1'b1;
            end

            finish_unaligned_pc <= 1'b0;
        end else if(branch_flush) begin
            IFID_IR_o          <= NOP;
            PC              <= BRANCH_ADDRESS; // imediato
            IFID_PC_o       <= BOOT_ADDRESS;
            pc_is_unaligned <= (BRANCH_ADDRESS[1] == 1'b1);
            if(!instruction_response_i) begin
                flush_bus_o <= 1'b1;
            end

            finish_unaligned_pc <= 1'b0;
        end else begin
            if((!instruction_response_i && !memory_stall )) begin //instruction_response_i == 1'b0
                IFID_IR_o <= NOP;
                IFID_PC_o BOOT_ADDRESS;
            end else if (!memory_stall && !execute_stall && !flush_bus_o) begin
                if(finish_unaligned_pc) begin
                    finish_unaligned_pc <= 1'b0;
                    IFID_IR_o <= instr_d_o;
                    IFID_PC_o temp_pc;
                end else if(pc_is_unaligned) begin
                    temp_instruction <= {16'h0, instruction_data_i[31:16]};
                    IFID_IR_o <= NOP;
                    IFID_PC_o BOOT_ADDRESS;
                    finish_unaligned_pc <= 1'b1;
                    temp_pc <= PC;

                    if(instruction_data_i[17:16] != 2'b11) begin
                        PC <= PC + 'd2;
                        pc_is_unaligned <= 1'b0;
                    end else begin
                        PC <= PC + 'd4;
                        pc_is_unaligned <= 1'b1;
                    end
                end else begin
                    IFID_IR_o                      <= instr_d_o;
                    IFID_is_compressed_instruction <= is_compressed_instruction;
                    if(is_compressed_instruction) begin
                        PC <= PC + 'd2;
                        pc_is_unaligned <= 1'b1;
                    end else begin
                        PC <= PC + 'd4;
                        pc_is_unaligned <= 1'b0;
                    end
                    IFID_PC_o           <= PC;
                end
            end
        end
    end  
end


IR_Decompression IR_Decompression(
    .instr_c_i       (instr_c_i),
    .instr_is_c_o    (is_compressed_instruction),
    .instr_d_o       (instr_d_o),
    .instr_illegal_o (illegal_instruction)
);

assign IFIDop              = IFID_IR_o[6:0];
assign IFIDrs1             = IFID_IR_o[19:15];
assign IFIDrs2             = IFID_IR_o[24:20];
assign IFIDfunc3           = IFID_IR_o[14:12];
assign IFIDfunc5           = IFID_IR_o[31:27];
    
assign instruction_addr_o = PC;

endmodule