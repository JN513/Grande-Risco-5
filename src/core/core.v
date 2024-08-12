module Grande_Risco5 #(
    parameter BOOT_ADDRESS=32'h00000000
) (
    // Control signal
    input wire clk,
    input wire reset,

    // Instruction BUS

    input wire [31:0] instruction_data,
    output wire [31:0] instruction_address,

    // Data BUS
    output wire data_memory_read,
    output wire data_memory_write,
    input  wire [31:0] read_data,
    output wire [31:0] data_address,
    output wire [31:0] write_data
);

localparam NOP              = 32'h00000000;
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

reg Zero_EXMEMB, mem_to_reg, reg_write, memory_write;

// PC, IDEX Rs1 value, IDEX Rs2 value, Value to Memory, Value to write back register
reg [31:0] PC, IDEXA, IDEXB,
    IFIDPC, IDEXPC, IMMEDIATE_REG,
    BRANCH_ADDRESS;

reg [31:0] EXMEM_mem_data_value, EXMEMB, EXMEMALUOut;

reg [31:0] MEMWB_mem_read_data, MEMWBALUOut;

reg [1:0] aluop;

wire zero, is_immediate, stall, takebranch;
wire [1:0] op_rs1, op_rs2;
wire [3:0] aluop_out;
wire [31:0] alu_input_a, alu_input_b, alu_out, immediate, 
    register_data_1_out, register_data_2_out, MEMWBValue;


// Pipeline instruction register
// Instruction Fetch - Instruction Decode Register
// Instruction Decode - Instruction Execute Register
// Instruction Execute - Instruction Memory Access Register
// Instruction Memory Access - Instruction Write back register

reg [31:0] IFIDIR, IDEXIR, EXMEMIR, MEMWBIR; // pipeline instruction registers

wire [4:0] IFIDrs1, IFIDrs2, IDEXrs1, IDEXrs2, EXMEMrd, MEMWBrd; // Access register fields

wire [6:0] IFIDop, IDEXop, EXMEMop, MEMWBop; // Access opcodes

initial begin
    PC = BOOT_ADDRESS;
    IFIDIR = NOP; 
    IDEXIR = NOP; 
    EXMEMIR = NOP; 
    MEMWBIR = NOP;

    Zero_EXMEMB = 1'b0;
    IFIDPC = BOOT_ADDRESS;
    IDEXPC = BOOT_ADDRESS;
    IMMEDIATE_REG = 32'h00000000;
end

always @(posedge clk ) begin
    memory_write <= 1'b0;
    reg_write <= 1'b0;
    mem_to_reg <= 1'b0;

    if(reset == 1'b1) begin
        PC <= BOOT_ADDRESS;
        IFIDIR <= NOP; 
        IDEXIR <= NOP; 
        EXMEMIR <= NOP; 
        MEMWBIR <= NOP;
        memory_write <= 1'b0;
        reg_write <= 1'b0;
    end else begin
        // Instruction Fetch - first stage / IFID
        if(takebranch == 1'b1) begin
            IFIDIR <= NOP;
            PC <= BRANCH_ADDRESS; // imediato
        end else begin
            IFIDIR <= instruction_data;
            PC <= PC + 'd4;
        end


        // Instruction Decode - second stage / IDEX
        if(IFIDop == BRANCH_OPCODE)
            aluop <= 2'b01;
        else if(IFIDop == IMMEDIATE_OPCODE || 
                IFIDop == CSR_OPCODE || 
                IFIDop == LUI_OPCODE || 
                IFIDop == AUIPC_OPCODE)
            aluop <= 2'b10;
        else
            aluop <= 2'b00;

        if(0) begin
            IDEXIR <= NOP;
        end else begin
            IDEXA <= register_data_1_out; 
            IDEXB <= register_data_2_out;
            IDEXIR <= IFIDIR;
        end


        // Instruction Execute - third stage / EXMEM
        if(0) begin
            EXMEMIR <= NOP;
        end else begin
            EXMEMIR <= IDEXIR;

            EXMEM_mem_data_value <= alu_input_b;
            EXMEMALUOut <= alu_out;

            if(IDEXop == SW_OPCODE) begin // verifica se tem mem
                memory_write <= 1'b1;
            end
        end

        // Memory access - four stage / MEMWB

        MEMWBIR <= EXMEMIR;
        MEMWB_mem_read_data <= read_data;
        MEMWBALUOut <= EXMEMALUOut;

        if ((EXMEMop == RTYPE_OPCODE || 
            EXMEMop == IMMEDIATE_OPCODE || 
            EXMEMop == AUIPC_OPCODE || 
            EXMEMop == CSR_OPCODE || 
            EXMEMop == LUI_OPCODE || 
            EXMEMop == LW_OPCODE) && (EXMEMrd != 'd0)) 
        begin
            // verifica se tem wb
            reg_write <= 1'b1;
        end

        if(EXMEMop == LW_OPCODE) begin 
            mem_to_reg <= 1'b1;
        end

        // wb stage - five stage
    end
end

always @(posedge clk) begin
    if(reset == 1'b1) begin
        Zero_EXMEMB <= 1'b0;
        IFIDPC <= BOOT_ADDRESS;
        IDEXPC <= BOOT_ADDRESS;
        IMMEDIATE_REG <= 32'h00000000;
        BRANCH_ADDRESS <= BOOT_ADDRESS;
    end else begin
        Zero_EXMEMB <= zero;
        IFIDPC <= PC;
        IDEXPC <= IFIDPC;
        IMMEDIATE_REG <= immediate;
        BRANCH_ADDRESS <= IMMEDIATE_REG + IDEXPC;
    end
end

Registers RegisterBank(
    .clk(clk),
    .reset(reset),
    .regWrite(reg_write),
    .readRegister1(IFIDrs1),
    .readRegister2(IFIDrs2),
    .writeRegister(MEMWBrd),
    .writeData(MEMWBValue),
    .readData1(register_data_1_out),
    .readData2(register_data_2_out)
);

ALU_Control ALU_Control(
    .is_immediate(is_immediate),
    .aluop_in(aluop),
    .func7(IDEXIR[31:25]),
    .func3(IDEXIR[14:12]),
    .aluop_out(aluop_out)
);

Alu Alu(
    .operation(aluop_out),
    .ALU_in_X(alu_input_a),
    .ALU_in_Y(alu_input_b),
    .ALU_out_S(alu_out),
    .ZR(zero)
);

Immediate_Generator Immediate_Generator(
    .instruction(IFIDIR),
    .immediate(immediate)
);

Forwarding_Unit Forwarding_Unit(
    .immediate(is_immediate),
    .pc_operation(IDEXop == AUIPC_OPCODE),
    .rs1(IDEXrs1),
    .rs2(IDEXrs2),
    .ex_mem_stage_rd(EXMEMrd),
    .mem_wb_stage_rd(MEMWBrd),
    .op_rs1(op_rs1),
    .op_rs2(op_rs2)
);

MUX ForwardAMUX(
    .option(op_rs1),
    .A(IDEXA),
    .B(MEMWBValue),
    .C(EXMEMALUOut),
    .D(IDEXPC),
    .S(alu_input_a)
);

MUX ForwardBMUX(
    .option(op_rs2),
    .A(IDEXB),
    .B(MEMWBValue),
    .C(EXMEMALUOut),
    .D(IMMEDIATE_REG),
    .S(alu_input_b)
);
/*
MUX AluInputAMUX(
    .option(alu_src_a),
    .A(IDEXA),
    .B(),
    .C(IDEXPC),
    .D(32'd0),
    .S()
);

MUX AluInputBMUX(
    .option(alu_src_b),
    .A(IDEXB),
    .B(IMMEDIATE_REG),
    .C(),
    .D(),
    .S()
);
*/
assign is_branch = (EXMEMop == BRANCH_OPCODE) ? 1'b1 : 1'b0;
assign takebranch = (Zero_EXMEMB && is_branch);
assign instruction_address = PC;
assign IFIDop = IFIDIR[6:0];
assign IFIDrs1 = IFIDIR[19:15];
assign IFIDrs2 = IFIDIR[24:20];
assign IDEXop = IDEXIR[6:0];
assign IDEXrs1 = IDEXIR[19:15];
assign IDEXrs2 = IDEXIR[24:20];
assign EXMEMop = EXMEMIR[6:0];
assign EXMEMrd = EXMEMIR[11:7];
assign MEMWBop = MEMWBIR[6:0];
assign MEMWBrd = MEMWBIR[11:7];

assign MEMWBValue = (mem_to_reg == 1'b1) ? MEMWB_mem_read_data : MEMWBALUOut;

assign write_data = EXMEM_mem_data_value;
assign data_address = EXMEMALUOut;
assign data_memory_write = memory_write;

assign is_immediate = (IDEXop == IMMEDIATE_OPCODE) ? 1'b1 : 1'b0;

endmodule
