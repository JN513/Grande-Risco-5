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
    output wire [1:0] data_option,
    input  wire [31:0] read_data,
    output wire [31:0] data_address,
    output wire [31:0] write_data
);

localparam NOP              = 32'h00000013;
localparam LW_OPCODE        = 7'b0000011;
localparam SW_OPCODE        = 7'b0100011;
localparam JAL_OPCODE       = 7'b1101111;
localparam LUI_OPCODE       = 7'b0110111;
localparam CSR_OPCODE       = 7'b1110011;
localparam JALR_OPCODE      = 7'b1100111;
localparam AUIPC_OPCODE     = 7'b0010111;
localparam BRANCH_OPCODE    = 7'b1100011;
localparam IMMEDIATE_OPCODE = 7'b0010011;

reg Zero_EXMEMB;

// PC, IDEX Rs1 value, IDEX Rs2 value, Value to Memory, Value to write back register
reg [31:0] PC, IDEXA, IDEXB, EXMEMB, EXMEMALUOut,
    MEMWBValue, IFIDPC, IDEXPC, IMMEDIATE_REG,
    BRANCH_ADDRESS;

wire zero, is_immediate, reg_write, stall, takebranch;
wire [1:0] aluop, alu_src_a, alu_src_b;
wire [3:0] aluop_out;
wire [31:0] alu_input_a, alu_input_b, alu_out, immediate, 
    register_data_1_out, register_data_2_out;


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
    if(reset == 1'b1) begin
        PC <= BOOT_ADDRESS;
        IFIDIR <= NOP; 
        IDEXIR <= NOP; 
        EXMEMIR <= NOP; 
        MEMWBIR <= NOP;
    end else begin
        // Instruction Fetch - first stage
        if(takebranch == 1'b1) begin
            IFIDIR <= NOP;
            PC <= BRANCH_ADDRESS; // imediato
        end else begin
            IFIDIR <= instruction_data;
            PC <= PC + 'd4;
        end


        // Instruction Decode - second stage

        IDEXA <= register_data_1_out; 
        IDEXB <= register_data_2_out;
        IDEXIR <= IFIDIR;


        // Instruction Execute - third stage
        EXMEMIR <= IDEXIR;

        // Memory access - four stage

        MEMWBIR <= EXMEMIR;

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

MUX AluInputAMUX(
    .option(alu_src_a),
    .A(IDEXA),
    .B(),
    .C(IDEXPC),
    .D(32'd0),
    .S(alu_input_a)
);

MUX AluInputBMUX(
    .option(alu_src_b),
    .A(IDEXB),
    .B(IMMEDIATE_REG),
    .C(),
    .D(),
    .S(alu_input_b)
);

assign is_branch = (EXMEMop == BRANCH_OPCODE) ? 1'b1 : 1'b0;
assign takebranch = (Zero_EXMEMB && is_branch);
assign instruction_address = {2'b00, PC[31:2]};
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
    
endmodule
