`include "defines.vh"

module Core #(
    parameter BOOT_ADDRESS = 32'h00000000
) (
    // Control signal
    input wire clk,
    input wire rst_n,

    // Instruction BUS

    output  reg flush_bus,
    output  reg instruction_request,
    input  wire instruction_response,
    input  wire [31:0] instruction_data,
    output wire [31:0] instruction_address,

    // Data BUS
    input  wire data_memory_response,
    output wire data_memory_read,
    output wire data_memory_write,
    input  wire [31:0] read_data,
    output wire [31:0] data_address,
    output wire [31:0] write_data
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

localparam JAL_MASK  = 7'b0010000;
localparam JALR_MASK = 7'b0011000;

reg Zero_EXMEMB, mem_to_reg, reg_write, memory_write, memory_read, is_immediate,
    is_jal, is_branch, memory_operation, is_jalr;

// PC, IDEX Rs1 value, IDEX Rs2 value, Value to Memory, Value to write back register
reg [31:0] PC, IDEXA, IDEXB,
    IFIDPC, IDEXPC, IMMEDIATE_REG,
    BRANCH_ADDRESS;

wire branch_flush;

reg [31:0] EXMEM_mem_data_value, EXMEMB, EXMEMALUOut, alu_input_a, alu_input_b;

reg [31:0] MEMWB_mem_read_data, MEMWBALUOut;

reg [1:0] aluop;

reg [3:0] aluop_out_reg;

reg [31:0] JAL_PC, JALR_PC;

wire [2:0] IFDIfunc3, IDEXfunc3, EXMEMfunc3;
wire zero, execute_stall, takebranch, memory_stall, flush;
wire [1:0] op_rs1, op_rs2;
wire [3:0] aluop_out;
wire [31:0] alu_out, immediate, 
    register_data_1_out, register_data_2_out, MEMWBValue;
wire [31:0] forward_out_a, forward_out_b;


assign flush = branch_flush | is_jal;

// Pipeline States
// Instruction Fetch
// Instruction Decode
// Instruction Execute
// Instruction Memory Access
// Instruction WB

reg IFID_is_compressed_instruction, IDEX_is_compressed_instruction;
reg [31:0] IFIDIR, IDEXIR, EXMEMIR, MEMWBIR; // pipeline instruction registers

wire [4:0] IFIDrs1, IFIDrs2, IDEXrs1, IDEXrs2, EXMEMrd, MEMWBrd, IDEXrd; // Access register fields

wire [6:0] IFIDop, IDEXop, EXMEMop, MEMWBop; // Access opcodes
wire [4:0] IFIDfunc5, IDEXfunc5, EXMEMfunc5, MEMWBfunc5; // Access func5

reg is_different_branch_address, pc_is_unaligned, finish_unaligned_pc;

assign branch_flush = (is_different_branch_address & takebranch);

always @(posedge clk ) begin // IF/ID
    instruction_request <= 1'b1;
    flush_bus           <= 1'b0;
    Zero_EXMEMB         <= zero;

    is_jal  <= (IFIDop == JAL_OPCODE) && (~execute_stall);
    is_jalr <= (IDEXop == JALR_OPCODE) && (~execute_stall);

    JAL_PC  <= IFIDPC + immediate;
    JALR_PC <= forward_out_a + IMMEDIATE_REG;
    is_different_branch_address <= PC != (IFIDPC + immediate);
    IFID_is_compressed_instruction <= 1'b0;

    if(!rst_n) begin
        pc_is_unaligned     <= 1'b0;
        PC                  <= BOOT_ADDRESS;
        IFIDIR              <= NOP;
        flush_bus           <= 1'b0;
        finish_unaligned_pc <= 1'b0;
    end else begin
        if(flush_bus) begin
            instruction_request <= 1'b1;
        end
        
        if(is_jal) begin
            IFIDIR          <= NOP;
            PC              <= JAL_PC; // imediato
            IFIDPC          <= BOOT_ADDRESS;
            pc_is_unaligned <= (JAL_PC[1] == 1'b1);
            if(~instruction_response) begin
                flush_bus <= 1'b1;
            end

            finish_unaligned_pc <= 1'b0;
        end else if (is_jalr) begin 
            IFIDIR          <= NOP;
            PC              <= JALR_PC; // imediato
            IFIDPC          <= BOOT_ADDRESS;
            pc_is_unaligned <= (JALR_PC[1] == 1'b1);

            if(!instruction_response) begin
                flush_bus <= 1'b1;
            end

            finish_unaligned_pc <= 1'b0;
        end else if(branch_flush) begin
            IFIDIR          <= NOP;
            PC              <= BRANCH_ADDRESS; // imediato
            IFIDPC          <= BOOT_ADDRESS;
            pc_is_unaligned <= (BRANCH_ADDRESS[1] == 1'b1);
            if(!instruction_response) begin
                flush_bus <= 1'b1;
            end

            finish_unaligned_pc <= 1'b0;
        end else begin
            if((!instruction_response && !memory_stall )) begin //instruction_response == 1'b0
                IFIDIR <= NOP;
                IFIDPC <= BOOT_ADDRESS;
            end else if (!memory_stall && !execute_stall && !flush_bus) begin
                if(finish_unaligned_pc) begin
                    finish_unaligned_pc <= 1'b0;
                    IFIDIR <= decompressed_instruction_data_out;
                    IFIDPC <= temp_pc;
                end else if(pc_is_unaligned) begin
                    temp_instruction <= {16'h0, instruction_data[31:16]};
                    IFIDIR <= NOP;
                    IFIDPC <= BOOT_ADDRESS;
                    finish_unaligned_pc <= 1'b1;
                    temp_pc <= PC;

                    if(instruction_data[17:16] != 2'b11) begin
                        PC <= PC + 'd2;
                        pc_is_unaligned <= 1'b0;
                    end else begin
                        PC <= PC + 'd4;
                        pc_is_unaligned <= 1'b1;
                    end
                end else begin
                    IFIDIR                         <= decompressed_instruction_data_out;
                    IFID_is_compressed_instruction <= is_compressed_instruction;
                    if(is_compressed_instruction) begin
                        PC <= PC + 'd2;
                        pc_is_unaligned <= 1'b1;
                    end else begin
                        PC <= PC + 'd4;
                        pc_is_unaligned <= 1'b0;
                    end
                    IFIDPC              <= PC;
                end
            end
        end
    end  
end

reg [31:0] temp_instruction, temp_pc;
wire [31:0] unaligned_instruction;

assign unaligned_instruction = {instruction_data[15:0], temp_instruction[15:0]};

reg previous_instruction_is_lw;
reg IFID_ilegal_instruction; // EX AMO OPCODE and func3 != 010

always @(posedge clk ) begin // ID/EX
`ifdef ENABLE_MDU
    mdu_start <= 1'b0;
`endif
    BRANCH_ADDRESS <= IFIDPC + immediate;
    is_branch <= (IFIDop == BRANCH_OPCODE);
    IDEX_is_compressed_instruction <= IFID_is_compressed_instruction;

    if(!rst_n || branch_flush || (is_jal && ~execute_stall)
        || (is_jalr && ~execute_stall)) begin
        IDEXIR <= NOP;
        previous_instruction_is_lw <= 1'b0;
`ifdef ENABLE_MDU
        mdu_operation <= 1'b0;
`endif
    end else begin
        if(!memory_stall && !execute_stall) begin
            previous_instruction_is_lw <= (IDEXop == LW_OPCODE);
            IDEXIR <= IFIDIR;
            IDEXPC <= IFIDPC;
            IDEXA  <= register_data_1_out; 
            IDEXB  <= register_data_2_out;
            aluop_out_reg <= aluop_out;
            `ifdef ENABLE_MDU
            if(IFIDop == RTYPE_OPCODE && func7_lsb ) begin
                mdu_start <= 1'b1;
                mdu_operation <= 1'b1;
            end else
                mdu_operation <= 1'b0;
            `endif
        end else begin
            previous_instruction_is_lw <= (EXMEMop == LW_OPCODE);
            IDEXA <= forward_out_a;
            IDEXB <= forward_out_b; // Verificar isso em mais casos tipo um stall antes disso sem forwarding
        end
    end
end

always @(*) begin
    case (IDEXop)
        JAL_OPCODE, JALR_OPCODE, AUIPC_OPCODE: alu_input_a <= IDEXPC; // AUIPC: PC
        LUI_OPCODE: alu_input_a <= 32'h00000000; // LUI: 0
        default: alu_input_a <= forward_out_a; // Outros: Rs1
    endcase

    case (IDEXop)
        JAL_OPCODE, JALR_OPCODE:  alu_input_b <= (IDEX_is_compressed_instruction) ? 32'h2 : 32'h4; // JAL: 4
        AUIPC_OPCODE, LUI_OPCODE, SW_OPCODE, IMMEDIATE_OPCODE, LW_OPCODE: 
        alu_input_b <= IMMEDIATE_REG;
        default: alu_input_b <= forward_out_b; // Outros: Rs1
    endcase
end

reg is_immediate_reg_not;


assign execute_stall = (&op_rs1 || (&op_rs2 && is_immediate_reg_not)
`ifdef ENABLE_MDU
    || (!mdu_done && mdu_operation)
`endif
);
assign memory_stall = (memory_operation & ~data_memory_response) | unaligned_access_in_progress;

reg unaligned_access_in_progress;
wire is_unaligned_address;

assign is_unaligned_address = (memory_operation && EXMEMALUOut[1:0] != 2'b00);

localparam IDLE                      = 4'b0000;
localparam READ_FIRST_WORD           = 4'b0001;
localparam READ_SECOND_WORD          = 4'b0010;
localparam MERGE_WORDS               = 4'b0011;
localparam READ_FIRST_WORD_TO_WRITE  = 4'b0100;
localparam MODIFY_FIRST_WORD         = 4'b0101;
localparam WRITE_FIRST_WORD          = 4'b0110;
localparam READ_SECOND_WORD_TO_WRITE = 4'b0111;
localparam MODIFY_SECOND_WORD        = 4'b1000;
localparam WRITE_SECOND_WORD         = 4'b1001;
localparam CUT_WORDS                 = 4'b1010;

reg [3:0] unaligned_access_state;
reg [31:0] First_Word, Second_Word;

reg [31:0] Merged_word;

always @(posedge clk ) begin // EX/MEM
    is_immediate_reg_not <= ~is_immediate;
    memory_write <= 1'b0;
    memory_read  <= 1'b0;

    if(!rst_n) begin
        unaligned_access_in_progress <= 1'b0;
        unaligned_access_state <= IDLE;
        EXMEMIR <= NOP;
    end else if(unaligned_access_in_progress) begin 
        case (unaligned_access_state)
            IDLE: begin
                memory_operation <= 1'b0;
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
                    Merged_word <= {Second_Word[7:0], First_Word[31:8]};
                end else if(data_address[1:0] == 2'b10) begin
                    Merged_word <= {Second_Word[15:0], First_Word[31:16]};
                end else if(data_address[1:0] == 2'b11) begin
                    Merged_word <= {Second_Word[23:0], First_Word[31:24]};
                end
                unaligned_access_state <= CUT_WORDS;
            end
            CUT_WORDS: begin
                case (EXMEMfunc3)
                    3'b000: Merged_word <= {{24{Merged_word[7]}}, Merged_word[7:0]};
                    3'b001: Merged_word <= {{16{Merged_word[15]}}, Merged_word[15:0]};
                    3'b100: Merged_word <= {24'h0, Merged_word[7:0]};
                    3'b101: Merged_word <= {16'h0, Merged_word[15:0]};
                    default: Merged_word <= Merged_word;
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
                    EXMEM_mem_data_value <= {EXMEM_mem_data_value[15:0], First_Word[15:8]};
                end else if(Data_Address[1:0] == 2'b11) begin
                    EXMEM_mem_data_value <= {EXMEM_mem_data_value[7:0], First_Word[23:16]};
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
    end else if((execute_stall & ~memory_stall)) begin
        EXMEMIR <= NOP;
    end else begin
        if(!execute_stall && !memory_stall)
            IMMEDIATE_REG <= immediate;
        
        if(!memory_stall) begin
            memory_operation <= (IDEXop == LW_OPCODE || IDEXop == SW_OPCODE);
            unaligned_access_in_progress <= |alu_out[1:0] && (IDEXop == LW_OPCODE || IDEXop == SW_OPCODE);

            EXMEMIR <= IDEXIR;

            EXMEMALUOut  <= alu_out;
            Data_Address <= alu_out;


            `ifdef ENABLE_MDU
            EXMEMMDUOut <= MDU_out;
            EXMEMMDUop <= mdu_operation;
            `endif

            if(IDEXop == LW_OPCODE) begin
                memory_read <= 1'b1;
            end
            if(IDEXop == SW_OPCODE && ~|alu_out[1:0]) begin // verifica se tem mem
                memory_write <= 1'b1;
            end

            EXMEM_mem_data_value <= forward_out_b; 
        end else begin
            memory_operation <= (EXMEMop == LW_OPCODE || EXMEMop == SW_OPCODE);

            if(EXMEMop == LW_OPCODE) begin
                memory_read <= 1'b1;
            end
        end
    end   
end

reg [31:0] Data_Address;

always @(posedge clk ) begin // MEM/WB
    reg_write    <= 1'b0;
    mem_to_reg   <= 1'b0;

    if(!rst_n || memory_stall) begin
        MEMWBIR <= NOP;
    end else begin // memory_stall
        MEMWBIR <= EXMEMIR;
        MEMWB_mem_read_data <= (is_unaligned_address) ? Merged_word : read_data;
        
        `ifdef ENABLE_MDU
        MEMWBALUOut <= (EXMEMMDUop) ? EXMEMMDUOut : EXMEMALUOut;
        `else
        MEMWBALUOut <= EXMEMALUOut;
        `endif

        // wb stage - five stage

        if ((EXMEMop == RTYPE_OPCODE || 
            EXMEMop == IMMEDIATE_OPCODE || 
            EXMEMop == AUIPC_OPCODE || 
            EXMEMop == CSR_OPCODE || 
            EXMEMop == LUI_OPCODE || 
            EXMEMop == LW_OPCODE ||
            EXMEMop == JAL_OPCODE ||
            EXMEMop == JALR_OPCODE ) && (|EXMEMrd)) 
        begin
            // verifica se tem wb
            reg_write <= 1'b1;
        end

        if(EXMEMop == LW_OPCODE) begin 
            mem_to_reg <= 1'b1;
        end
    end   
end

always @(*) begin
    case (IFIDop)
        BRANCH_OPCODE: aluop = 2'b01;
        IMMEDIATE_OPCODE, CSR_OPCODE, JALR_OPCODE, RTYPE_OPCODE: 
        aluop = 2'b10;
        default: aluop = 2'b00; // Outros
    endcase

    case (IFIDop)
        IMMEDIATE_OPCODE, LW_OPCODE, SW_OPCODE, AUIPC_OPCODE, LUI_OPCODE: 
        is_immediate = 1'b1; // Tipo I: instruções com imediato (e.g., ADDI, SLTI)
        default: is_immediate = 1'b0; // Instruções que não usam imediato
    endcase
end

wire [31:0] decompressed_instruction_data_out, decompressed_instruction_data_in;
wire is_compressed_instruction, illegal_instruction;

assign decompressed_instruction_data_in = (finish_unaligned_pc) ? unaligned_instruction : instruction_data;

IR_Decompression IR_Decompression(
    .compressed_instruction    (decompressed_instruction_data_in),
    .is_compressed_instruction (is_compressed_instruction),
    .decompressed_instruction  (decompressed_instruction_data_out),
    .illegal_instruction       (illegal_instruction)
);

Registers RegisterBank(
    .clk           (clk),
    .regWrite      (reg_write),
    .readRegister1 (IFIDrs1),
    .readRegister2 (IFIDrs2),
    .writeRegister (MEMWBrd),
    .writeData     (MEMWBValue),
    .readData1     (register_data_1_out),
    .readData2     (register_data_2_out)
);

ALU_Control ALU_Control(
    .is_immediate (is_immediate),
    .aluop_in     (aluop),
    .func7        (IFIDIR[31:25]),
    .func3        (IFIDIR[14:12]),
    .aluop_out    (aluop_out)
);

Alu Alu(
    .operation (aluop_out_reg),
    .ALU_in_X  (alu_input_a),
    .ALU_in_Y  (alu_input_b),
    .ALU_out_S (alu_out),
    .ZR        (zero)
);

`ifdef ENABLE_MDU

reg mdu_start, mdu_operation, EXMEMMDUop;
reg [31:0] EXMEMMDUOut;
wire mdu_done, func7_lsb;
wire [31:0] MDU_out;

assign func7_lsb = IFIDIR[25];

MDU Mdu(
    .clk       (clk),
    .rst_n     (rst_n),
    .start     (mdu_start),
    .operation (IDEXfunc3),
    .MDU_in_X  (forward_out_a),
    .MDU_in_Y  (forward_out_b),
    .done      (mdu_done),
    .MDU_out   (MDU_out)
);

`endif

Immediate_Generator Immediate_Generator(
    .instruction (IFIDIR),
    .immediate   (immediate)
);

Forwarding_Unit Forwarding_Unit(
    .rs1                        (IDEXrs1),
    .rs2                        (IDEXrs2),
    .ex_mem_stage_rd            (EXMEMrd),
    .mem_wb_stage_rd            (MEMWBrd),
    .previous_instruction_is_lw (previous_instruction_is_lw),
    .op_rs1                     (op_rs1),
    .op_rs2                     (op_rs2)
);

MUX ForwardAMUX(
    .option (op_rs1),
    .A      (IDEXA),
    .B      (MEMWBValue),
    .C      (EXMEMALUOut),
    .S      (forward_out_a)
);

MUX ForwardBMUX(
    .option (op_rs2),
    .A      (IDEXB),
    .B      (MEMWBValue),
    .C      (EXMEMALUOut),
    .S      (forward_out_b)
);

assign takebranch          = (zero && is_branch);
assign instruction_address = PC;
assign IFIDop              = IFIDIR[6:0];
assign IFIDrs1             = IFIDIR[19:15];
assign IFIDrs2             = IFIDIR[24:20];
assign IFIDfunc3           = IFIDIR[14:12];
assign IFIDfunc5           = IFIDIR[31:27];
assign IDEXop              = IDEXIR[6:0];
assign IDEXrd              = IDEXIR[11:7];
assign IDEXrs1             = IDEXIR[19:15];
assign IDEXrs2             = IDEXIR[24:20];
assign IDEXfunc3           = IDEXIR[14:12];
assign IDEXfunc5           = IDEXIR[31:27];
assign EXMEMop             = EXMEMIR[6:0];
assign EXMEMrd             = EXMEMIR[11:7];
assign EXMEMfunc3          = EXMEMIR[14:12];
assign EXMEMfunc5          = EXMEMIR[31:27];
assign MEMWBop             = MEMWBIR[6:0];
assign MEMWBrd             = MEMWBIR[11:7];
assign MEMWBfunc5          = MEMWBIR[31:27];
assign data_memory_read    = memory_read;
assign data_memory_write   = memory_write;

assign MEMWBValue = (mem_to_reg) ? MEMWB_mem_read_data : MEMWBALUOut;

assign write_data   = EXMEM_mem_data_value;
assign data_address = Data_Address;

endmodule
