module CSR_Unit (
    input logic clk,
    input logic rst_n,

    // CSR read/write signals
    input  logic csr_wr_en, // Fazer bypass na escrita dos registradores depois

    input logic [2:0] func3_i,
    input logic [4:0] csr_imm_i,
    input logic [11:0] csr_addr_i,

    input  logic [31:0] csr_data_in,
    output logic [31:0] csr_data_out,

    // Processor signals
    input logic invalid_fetch_instruction,
    input logic invalid_decode_instruction,
    input logic instruction_finished,

    input logic [31:0] fetch_pc,
    input logic [31:0] decode_pc,
    input logic [31:0] execute_pc,
    input logic [31:0] memory_pc,
    input logic [31:0] writeback_pc,

    // Trap signals
    output logic IDEX_trap_flush_o,
    output logic EXMEM_trap_flush_o,
    output logic IFID_trap_flush_o,
    output logic [31:0] trap_pc_o,

    input logic external_interruption_i
);

// Address of Performance Counters CSRs

localparam CYCLE                = 12'hC00; // Contador de ciclos.
localparam TIME                 = 12'hC01; // Contador de tempo.
localparam INSTRET              = 12'hC02; // Contador de instruções.
localparam CYCLEH               = 12'hC80; // Campo de extensão do registrador CYCLE.
localparam TIMEH                = 12'hC81; // Campo de extensão do registrador TIME.
localparam INSTRETH             = 12'hC82; // Campo de extensão do registrador INSTRET.
localparam TIMECMP              = 12'hFFF; // Implementar depois

// Address of Machine Information CSRs

localparam MISA                 = 12'h301; // Informações sobre a arquitetura do processador.
localparam MVENDORID            = 12'hF11; // Identificador do fabricante.
localparam MARCHID              = 12'hF12; // Identificador da arquitetura.
localparam MIMPID               = 12'hF13; // Identificador da implementação.
localparam MHARTID              = 12'hF14; // Identificador do processador.

// Address of Machine Trap Setup CSRs

localparam MSTATUS              = 12'h300; // Status do processador (habilitação de interrupções, modos de execução, etc.).
localparam MSTATUSH             = 12'h310; // Campo de extensão do registrador MSTATUS.
localparam MIE                  = 12'h304; // Habilitação de interrupções.
localparam MTVEC                = 12'h305; // Endereço base para tratamento de exceções.

// Address of Machine Trap Handling CSRs

localparam MSCRATCH             = 12'h340; // Registrador de propósito geral.
localparam MEPC                 = 12'h341; // Endereço de retorno de exceções.
localparam MCAUSE               = 12'h342; // Causa da exceção.
localparam MTVAL                = 12'h343; // Valor associado à exceção.
localparam MIP                  = 12'h344; // Pendências de interrupções.

// Address of Machine Performance Counters CSRs

localparam MCYCLE               = 12'hB00; // Contador de ciclos.
localparam MINSTRET             = 12'hB02; // Contador de instruções.
localparam MCYCLEH              = 12'hB80; // Campo de extensão do registrador MCYCLE.
localparam MINSTRETH            = 12'hB82; // Campo de extensão do registrador MINSTRET.


logic [31:0] MEPC_reg, MSTATUS_reg, MCAUSE_reg, MTVAL_reg, 
    MIP_reg, MIE_reg, MTVEC_reg, MSCRATCH_reg;
logic [63:0] MCYCLE_reg, MINSTRET_reg;

logic [31:0] csr_input, csr_write_data;

assign csr_input = (func3_i[2] == 1'b1) ? {27'h0000000, csr_imm_i} : csr_data_in;

logic [31:0] csr_read_data;

always_comb begin : CSR_ALU
    unique case (func3_i[1:0])
        2'b01: csr_write_data = csr_input;
        2'b10: csr_write_data = csr_read_data | csr_input;
        2'b11: csr_write_data = csr_read_data & ~csr_input;
        default: csr_write_data = csr_read_data;
    endcase
end

assign csr_data_out = csr_read_data; // verificar necessidade de bypass

// Read CSR
always_comb begin : READ_CSR
    unique case (csr_addr_i)
        // Performance Counters
        CYCLE:     csr_read_data = MCYCLE_reg[31:0];
        CYCLEH:    csr_read_data = MCYCLE_reg[63:32];
        TIME:      csr_read_data = 32'h00000000;
        TIMEH:     csr_read_data = 32'h00000000;
        INSTRET:   csr_read_data = MINSTRET_reg[31:0];
        INSTRETH:  csr_read_data = MINSTRET_reg[63:32];
        MCYCLE:    csr_read_data = MCYCLE_reg[31:0];
        MINSTRET:  csr_read_data = MINSTRET_reg[31:0];
        MCYCLEH:   csr_read_data = MCYCLE_reg[63:32];
        MINSTRETH: csr_read_data = MINSTRET_reg[63:32];

        // Machine Information
        MISA:      csr_read_data = 32'b01_000000000000000001000100100111; // RV32IMABC_Zicsr
        MVENDORID: csr_read_data = 32'h00000000;
        MARCHID:   csr_read_data = 32'h00000000;
        MIMPID:    csr_read_data = 32'h00000000;
        MHARTID:   csr_read_data = 32'h00000000;
        MSTATUSH:  csr_read_data = 32'h00000000;

        // Machine Trap Setup
        MSTATUS:   csr_read_data = MSTATUS_reg;
        MIE:       csr_read_data = MIE_reg;
        MTVEC:     csr_read_data = MTVEC_reg;
        MSCRATCH:  csr_read_data = MSCRATCH_reg;
        MEPC:      csr_read_data = MEPC_reg;
        MCAUSE:    csr_read_data = MCAUSE_reg;
        MTVAL:     csr_read_data = MTVAL_reg;
        MIP:       csr_read_data = MIP_reg;
        default:   csr_read_data = 32'h00000000;
    endcase
end


// Counters incrementation
always_ff @( posedge clk ) begin : COUNTERS
    if(!rst_n) begin
        MCYCLE_reg   <= 64'h0000000000000000;
        MINSTRET_reg <= 64'h0000000000000000;
    end else begin
        MCYCLE_reg <= MCYCLE_reg + 1'b1;
        if(instruction_finished) begin
            MINSTRET_reg <= MINSTRET_reg + 1'b1;
        end
    end
end

// Write CSR (only for MSTATUS, MIE, MTVEC, MSCRATCH, MEPC, MCAUSE, MTVAL, MIP)
always_ff @(posedge clk ) begin : WRITE_CSR    
    if(!rst_n) begin
        MSTATUS_reg  <= 32'h00000000;
        MIE_reg      <= 32'h00000000;
        MTVEC_reg    <= 32'h00000000;
        MSCRATCH_reg <= 32'h00000000;
        MEPC_reg     <= 32'h00000000;
        MCAUSE_reg   <= 32'h00000000;
        MTVAL_reg    <= 32'h00000000;
        MIP_reg      <= 32'h00000000;
    end else begin
        if(csr_wr_en) begin
            case (csr_addr_i)
                MSTATUS:   MSTATUS_reg  <= csr_write_data;
                MIE:       MIE_reg      <= csr_write_data;
                MTVEC:     MTVEC_reg    <= csr_write_data;
                MSCRATCH:  MSCRATCH_reg <= csr_write_data;
                MEPC:      MEPC_reg     <= csr_write_data;
                MCAUSE:    MCAUSE_reg   <= csr_write_data;
                MTVAL:     MTVAL_reg    <= csr_write_data;
                MIP:       MIE_reg      <= csr_write_data;
                default: begin
                    // Do nothing
                end
            endcase
        end
    end
end

assign IFID_trap_flush_o  = 1'b0;
assign EXMEM_trap_flush_o = 1'b0;
assign IDEX_trap_flush_o  = 1'b0;
assign trap_pc_o          = 32'h00000000;

endmodule
