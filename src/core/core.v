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

reg [31:0] IFIDIR, IDEXIR, EXMEMIR, MEMWBIR; // pipeline instruction registers

wire [4:0] IFIDrs1, IFIDrs2, IDEXrs1, IDEXrs2, EXMEMrd, MEMWBrd, IDEXrd; // Access register fields

wire [6:0] IFIDop, IDEXop, EXMEMop, MEMWBop; // Access opcodes

assign branch_flush = (is_different_branch_address & takebranch);

reg is_different_branch_address;

always @(posedge clk ) begin // IF/ID
    Zero_EXMEMB <= zero;
    is_jal <= (IFIDop == JAL_OPCODE) && (~execute_stall);
    is_jalr <= (IFIDop == JALR_OPCODE) && (~execute_stall);

    JAL_PC <= IFIDPC + immediate;
    JALR_PC <= forward_out_a + IMMEDIATE_REG;
    //branch_flush <= (PC != (IFIDPC + IMMEDIATE_REG) && takebranch);
    is_different_branch_address <= PC != (IFIDPC + immediate);

    if(reset) begin
        PC <= BOOT_ADDRESS;
        IFIDIR <= NOP;
    end else begin
        if(is_jal) begin
            IFIDIR         <= NOP;
            PC             <= JAL_PC; // imediato
            IFIDPC         <= BOOT_ADDRESS;
        end else if (is_jalr) begin 
            IFIDIR         <= NOP;
            PC             <= JALR_PC; // imediato
            IFIDPC         <= BOOT_ADDRESS;
        end else if(branch_flush) begin
            IFIDIR         <= NOP;
            PC             <= BRANCH_ADDRESS; // imediato
            IFIDPC         <= BOOT_ADDRESS;
        end else begin
            if((~instruction_response && ~memory_stall )) begin //instruction_response == 1'b0
                IFIDIR <= NOP;
                IFIDPC <= BOOT_ADDRESS;
            end else if (~memory_stall && ~execute_stall) begin
                IFIDIR <= instruction_data;
                PC     <= PC + 'd4;
                IFIDPC <= PC;
            end
        end
    end  
end

reg previous_instruction_is_lw;

always @(posedge clk ) begin // ID/EX
    BRANCH_ADDRESS <= IFIDPC + immediate;
    is_branch <= (IFIDop == BRANCH_OPCODE);

    if(reset || branch_flush || (is_jal && ~execute_stall)
        || (is_jalr && ~execute_stall)) begin
        IDEXIR <= NOP;
        previous_instruction_is_lw <= 1'b0;
    end else begin
        if(~memory_stall && ~execute_stall) begin
            previous_instruction_is_lw <= (IDEXop == LW_OPCODE);
            IDEXIR <= IFIDIR;
            IDEXPC <= IFIDPC;
            IDEXA <= register_data_1_out; 
            IDEXB <= register_data_2_out;
            aluop_out_reg <= aluop_out;
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
        LUI_OPCODE:   alu_input_a <= 32'h00000000; // LUI: 0
        default: alu_input_a <= forward_out_a; // Outros: Rs1
    endcase

    case (IDEXop)
        JAL_OPCODE, JALR_OPCODE:  alu_input_b <= 32'h00000004; // JAL: 4
        AUIPC_OPCODE, LUI_OPCODE, SW_OPCODE, IMMEDIATE_OPCODE, LW_OPCODE: 
        alu_input_b <= IMMEDIATE_REG;
        default: alu_input_b <= forward_out_b; // Outros: Rs1
    endcase
end

reg is_immediate_reg_not;

assign execute_stall = (&op_rs1 || (&op_rs2 && is_immediate_reg_not));
assign memory_stall = memory_operation & ~data_memory_response;


always @(posedge clk ) begin // EX/MEM
    is_immediate_reg_not <= ~is_immediate;
    memory_write <= 1'b0;
    memory_read  <= 1'b0;


    if(reset || (execute_stall & ~memory_stall)) begin
        EXMEMIR <= NOP;
    end else begin
        if(~execute_stall && ~memory_stall)
            IMMEDIATE_REG <= immediate;
        
        if(~memory_stall) begin
            memory_operation <= (IDEXop == LW_OPCODE || IDEXop == SW_OPCODE);

            EXMEMIR <= IDEXIR;

            EXMEMALUOut <= alu_out;

            if(IDEXop == LW_OPCODE) begin
                memory_read <= 1'b1;
            end
            if(IDEXop == SW_OPCODE) begin // verifica se tem mem
                memory_write <= 1'b1;
            end

            EXMEM_mem_data_value <= forward_out_b; 
        end else begin
            memory_operation <= (EXMEMop == LW_OPCODE || EXMEMop == SW_OPCODE);
            if(EXMEMop == LW_OPCODE) begin
                memory_read <= 1'b1;
            end
            if(EXMEMop == SW_OPCODE) begin // verifica se tem mem
                memory_write <= 1'b1;
            end 
        end
    end   
end

always @(posedge clk ) begin // MEM/WB
    reg_write    <= 1'b0;
    mem_to_reg   <= 1'b0;

    if(reset || memory_stall) begin
        MEMWBIR <= NOP;
    end else begin // memory_stall
        MEMWBIR <= EXMEMIR;
        MEMWB_mem_read_data <= read_data;
        MEMWBALUOut <= EXMEMALUOut;

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
    .func7(IFIDIR[31:25]),
    .func3(IFIDIR[14:12]),
    .aluop_out(aluop_out)
);

Alu Alu(
    .operation(aluop_out_reg),
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
    .previous_instruction_is_lw(previous_instruction_is_lw),
    //.ex_mem_op(EXMEMop),
    .op_rs1(op_rs1),
    .op_rs2(op_rs2)
);

MUX ForwardAMUX(
    .option(op_rs1),
    .A(IDEXA),
    .B(MEMWBValue),
    .C(EXMEMALUOut),
    .S(forward_out_a)
);

MUX ForwardBMUX(
    .option(op_rs2),
    .A(IDEXB),
    .B(MEMWBValue),
    .C(EXMEMALUOut),
    .S(forward_out_b)
);

assign takebranch = (zero && is_branch);
assign instruction_address = PC;
assign IFIDop = IFIDIR[6:0];
assign IFIDrs1 = IFIDIR[19:15];
assign IFIDrs2 = IFIDIR[24:20];
assign IDEXop = IDEXIR[6:0];
assign IDEXrd = IDEXIR[11:7];
assign IDEXrs1 = IDEXIR[19:15];
assign IDEXrs2 = IDEXIR[24:20];
assign EXMEMop = EXMEMIR[6:0];
assign EXMEMrd = EXMEMIR[11:7];
assign MEMWBop = MEMWBIR[6:0];
assign MEMWBrd = MEMWBIR[11:7];
assign data_memory_read = memory_read;
assign data_memory_write = memory_write;

assign MEMWBValue = (mem_to_reg) ? MEMWB_mem_read_data : MEMWBALUOut;

assign write_data = EXMEM_mem_data_value;
assign data_address = EXMEMALUOut;

endmodule
