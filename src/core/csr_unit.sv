module CSR_Unit (
    input logic clk,
    input logic rst_n,

    // CSR read/write signals
    input  logic write_enable,
    output logic write_done,

    input logic [2:0] func3,
    input logic [4:0] csr_imm,
    input logic [11:0] csr_addr,

    input  logic [31:0] csr_data_in,
    output logic [31:0] csr_data_out,

    // Processor signals
    input logic invalid_decode_instruction,
    input logic instruction_finished,

    input logic [31:0] decode_pc,
    input logic [31:0] execute_pc,
    input logic [31:0] memory_pc,
    input logic [31:0] writeback_pc
);

// Address of Performance Counters CSRs

localparam CYCLE                = 12'hC00; // Contador de ciclos.
localparam TIME                 = 12'hC01; // Contador de tempo.
localparam INSTRET              = 12'hC02; // Contador de instruções.
localparam CYCLEH               = 12'hC80; // Campo de extensão do registrador CYCLE.
localparam TIMEH                = 12'hC81; // Campo de extensão do registrador TIME.
localparam INSTRETH             = 12'hC82; // Campo de extensão do registrador INSTRET.

// Address of Machine Information CSRs

localparam MVENDORID            = 12'hF11; // Identificador do fabricante.
localparam MARCHID              = 12'hF12; // Identificador da arquitetura.
localparam MIMPID               = 12'hF13; // Identificador da implementação.

// Address of Machine Trap Setup CSRs

localparam MSTATUS              = 12'h300; // Status do processador (habilitação de interrupções, modos de execução, etc.).
localparam MSTATUSH             = 12'h310; // Campo de extensão do registrador MSTATUS.
localparam MISA                 = 12'h301; // Informações sobre a arquitetura do processador.
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


// Read CSR
always_comb begin : READ_CSR
    case (csr_addr)
        // Performance Counters
        CYCLE:     csr_data_out = MCYCLE_reg[31:0];
        CYCLEH:    csr_data_out = MCYCLE_reg[63:32];
        TIME:      csr_data_out = 32'h00000000;
        TIMEH:     csr_data_out = 32'h00000000;
        INSTRET:   csr_data_out = MINSTRET_reg[31:0];
        INSTRETH:  csr_data_out = MINSTRET_reg[63:32];
        MCYCLE:    csr_data_out = MCYCLE_reg[31:0];
        MINSTRET:  csr_data_out = MINSTRET_reg[31:0];
        MCYCLEH:   csr_data_out = MCYCLE_reg[63:32];
        MINSTRETH: csr_data_out = MINSTRET_reg[63:32];

        // Machine Information
        MVENDORID: csr_data_out = 32'h00000000;
        MARCHID:   csr_data_out = 32'h00000000;
        MIMPID:    csr_data_out = 32'h00000000;
        MSTATUSH:  csr_data_out = 32'h00000000;
        MISA:      csr_data_out = 32'b01_000000000000000001000100100111; // RV32IMABC_Zicsr

        // Machine Trap Setup
        MSTATUS:   csr_data_out = MSTATUS_reg;
        MIE:       csr_data_out = MIE_reg;
        MTVEC:     csr_data_out = MTVEC_reg;
        MSCRATCH:  csr_data_out = MSCRATCH_reg;
        MEPC:      csr_data_out = MEPC_reg;
        MCAUSE:    csr_data_out = MCAUSE_reg;
        MTVAL:     csr_data_out = MTVAL_reg;
        MIP:       csr_data_out = MIP_reg;
        default:   csr_data_out = 32'h00000000;
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

// Write CSR (only for MSTATUS, MIE, MTVEC, MSCRATCH, MEPC)
always_ff @(posedge clk ) begin : WRITE_CSR
    write_done <= 1'b0;
    
    if(!rst_n) begin
        MSTATUS_reg  <= 32'h00000000;
        MIE_reg      <= 32'h00000000;
        MTVEC_reg    <= 32'h00000000;
        MSCRATCH_reg <= 32'h00000000;
        MEPC_reg     <= 32'h00000000;
    end else begin
        if(write_enable) begin
            case (csr_addr)
                MSTATUS:   MSTATUS_reg  <= csr_data_in;
                MIE:       MIE_reg      <= csr_data_in;
                MTVEC:     MTVEC_reg    <= csr_data_in;
                MSCRATCH:  MSCRATCH_reg <= csr_data_in;
                MEPC:      MEPC_reg     <= csr_data_in;
                default: begin
                    // Do nothing
                end
            endcase
            write_done <= 1'b1;
        end
    end
end

endmodule
