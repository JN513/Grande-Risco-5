module Forwarding_Unit (
    input  logic prev_instr_is_lw_i,  // Indica se a instrução anterior era LW
    input  logic [4:0] rs1_i,         // Registrador fonte 1
    input  logic [4:0] rs2_i,         // Registrador fonte 2
    input  logic [4:0] ex_mem_rd_i,   // Destino da instrução no estágio EX/MEM
    input  logic [4:0] mem_wb_rd_i,   // Destino da instrução no estágio MEM/WB
    input logic exmem_sw_opcode_i,
    input logic memwb_sw_opcode_i,
    output logic [1:0] fwd_rs1_o,     // Controle de forwarding para rs1
    output logic [1:0] fwd_rs2_o      // Controle de forwarding para rs2
);

localparam LW_OPCODE = 7'b0000011;

always_comb begin : FORWARDING_UNIT_LOGIC
    fwd_rs1_o = 2'b00;
    fwd_rs2_o = 2'b00;

    if (ex_mem_rd_i == rs1_i && |rs1_i && !exmem_sw_opcode_i) begin
        if (prev_instr_is_lw_i) begin
            fwd_rs1_o = 2'b11;
        end else begin
            fwd_rs1_o = 2'b10;
        end
    end else if (mem_wb_rd_i == rs1_i && |rs1_i && !memwb_sw_opcode_i) begin
        fwd_rs1_o = 2'b01;
    end

    if (ex_mem_rd_i == rs2_i && |rs2_i && !exmem_sw_opcode_i) begin
        if (prev_instr_is_lw_i) begin
            fwd_rs2_o = 2'b11;
        end else begin
            fwd_rs2_o = 2'b10;
        end
    end else if (mem_wb_rd_i == rs2_i && |rs2_i && !memwb_sw_opcode_i) begin
        fwd_rs2_o = 2'b01;
    end
end

endmodule
