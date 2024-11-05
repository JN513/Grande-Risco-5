module Grande_Risco5 #(
    parameter BOOT_ADDRESS=32'h00000000
) (
    // Control signal
    input wire clk,
    input wire reset,

    // Instruction BUS

    input wire instruction_response,
    input wire [31:0] instruction_data,
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

reg Zero_EXMEMB, mem_to_reg, reg_write, memory_write, memory_read, is_immediate,
    execute_stall, memory_stall, flush;

// PC, IDEX Rs1 value, IDEX Rs2 value, Value to Memory, Value to write back register
reg [31:0] PC, IDEXA, IDEXB,
    IFIDPC, IDEXPC, IMMEDIATE_REG,
    BRANCH_ADDRESS;

reg [31:0] EXMEM_mem_data_value, EXMEMB, EXMEMALUOut;

reg [31:0] MEMWB_mem_read_data, MEMWBALUOut;

reg [1:0] aluop;

wire zero, stall, takebranch;
wire [1:0] op_rs1, op_rs2;
wire [3:0] aluop_out;
wire [31:0] alu_input_a, alu_input_b, alu_out, immediate, 
    register_data_1_out, register_data_2_out, MEMWBValue;
wire [31:0] forward_out_a, forward_out_b;


// Pipeline States
// Instruction Fetch
// Instruction Decode
// Instruction Execute
// Instruction Memory Access
// Instruction WB

reg [31:0] IFIDIR, IDEXIR, EXMEMIR, MEMWBIR; // pipeline instruction registers

wire [4:0] IFIDrs1, IFIDrs2, IDEXrs1, IDEXrs2, EXMEMrd, MEMWBrd; // Access register fields

wire [6:0] IFIDop, IDEXop, EXMEMop, MEMWBop; // Access opcodes

always @(posedge clk ) begin // IF/ID
    Zero_EXMEMB    <= zero;
    if(reset == 1'b1) begin
        PC <= BOOT_ADDRESS;
        IFIDIR <= NOP;
    end else begin
        if(instruction_response == 1'b0 || flush == 1'b1) begin //instruction_response == 1'b0
            IFIDIR <= NOP;
        end else begin
            if (memory_stall == 1'b0 && execute_stall == 1'b0) begin
                if(takebranch == 1'b1) begin
                    IFIDIR         <= NOP;
                    PC             <= IMMEDIATE_REG + IDEXPC; // imediato
                    IFIDPC         <= BOOT_ADDRESS;
                end else begin
                    IFIDIR         <= instruction_data;
                    PC             <= PC + 'd4;
                    IFIDPC         <= PC;
                end
            end
        end
    end  
end

always @(posedge clk ) begin // ID/EX
    IMMEDIATE_REG <= immediate;
    execute_stall <= 1'b0;

    if(reset == 1'b1 || flush == 1'b1) begin
        IDEXIR <= NOP;
    end else begin
        if(IFIDop == BRANCH_OPCODE)
            aluop <= 2'b01;
        else if(IFIDop == IMMEDIATE_OPCODE || 
                IFIDop == CSR_OPCODE || 
                IFIDop == LUI_OPCODE || 
                IFIDop == AUIPC_OPCODE)
            aluop <= 2'b10;
        else
            aluop <= 2'b00;

        if(memory_stall == 1'b0 && execute_stall == 1'b0) begin
            IDEXA <= register_data_1_out; 
            IDEXB <= register_data_2_out;
            IDEXIR <= IFIDIR;
            IDEXPC <= IFIDPC;
        end
    end
end

always @(posedge clk ) begin // EX/MEM
    memory_write <= 1'b0;
    memory_read  <= 1'b0;
    memory_stall <= 1'b0;
    flush        <= 1'b0;

    if(reset == 1'b1) begin
        EXMEMIR <= NOP; 
    end else begin
        if(execute_stall) begin
            EXMEMIR <= NOP;
        end else begin
            if(memory_stall == 1'b0) begin
                EXMEMIR <= IDEXIR;

                EXMEM_mem_data_value <= forward_out_b;
                EXMEMALUOut <= alu_out; 

                if(IDEXop == LW_OPCODE) begin
                    memory_read <= 1'b1;
                    memory_stall <= ~data_memory_response;
                end
                if(IDEXop == SW_OPCODE) begin // verifica se tem mem
                    memory_write <= 1'b1;
                    memory_stall <= ~data_memory_response;
                end 
            end else begin
                if(IDEXop == SW_OPCODE) begin // verifica se tem mem
                    memory_stall <= ~data_memory_response;
                end 
                if(IDEXop == LW_OPCODE) begin
                    memory_stall <= ~data_memory_response;
                end 
            end
        end
    end   
end

always @(posedge clk ) begin // MEM/WB
    reg_write    <= 1'b0;
    mem_to_reg   <= 1'b0;

    if(reset == 1'b1 | memory_stall == 1'b1) begin
        MEMWBIR <= NOP;
    end else begin // memory_stall == 1'b1
        MEMWBIR <= EXMEMIR;
        MEMWB_mem_read_data <= read_data;
        MEMWBALUOut <= EXMEMALUOut;

        // wb stage - five stage

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
    end   
end

always @(*) begin
    case (IDEXop)
        IMMEDIATE_OPCODE: is_immediate = 1'b1; // Tipo I: instruções com imediato (e.g., ADDI, SLTI)
        LW_OPCODE:        is_immediate = 1'b1; // Tipo I: Load Word, precisa de imediato para o offset
        SW_OPCODE:        is_immediate = 1'b1; // Tipo S: Store Word, precisa de imediato para o offset
        AUIPC_OPCODE:     is_immediate = 1'b1; // Tipo U: Adiciona o imediato ao PC
        JALR_OPCODE:      is_immediate = 1'b1; // Tipo I: Jump And Link Register, usa imediato para o cálculo de endereço
        LUI_OPCODE:       is_immediate = 1'b1; // Tipo U: Load Upper Immediate, carrega um imediato na parte superior do registrador
        CSR_OPCODE:       is_immediate = 1'b1; // Tipo I: instruções CSR que usam imediato (e.g., CSRRWI)
        default:          is_immediate = 1'b0; // Instruções que não usam imediato
    endcase
end

Registers RegisterBank(
    .clk(clk),
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
    //.D(IDEXPC),
    .S(forward_out_a)
);

//.immediate(is_immediate),
//.pc_operation(IDEXop == AUIPC_OPCODE),

MUX ForwardBMUX(
    .option(op_rs2),
    .A(IDEXB),
    .B(MEMWBValue),
    .C(EXMEMALUOut),
    //.D(IMMEDIATE_REG),
    .S(forward_out_b)
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
assign data_memory_read = memory_read;
assign data_memory_write = memory_write;

assign MEMWBValue = (mem_to_reg == 1'b1) ? MEMWB_mem_read_data : MEMWBALUOut;

assign write_data = EXMEM_mem_data_value;
assign data_address = EXMEMALUOut;

assign alu_input_a = (IDEXop == AUIPC_OPCODE) ? IDEXPC : forward_out_a;
assign alu_input_b = (is_immediate == 1'b1) ? IMMEDIATE_REG : forward_out_b;

endmodule
