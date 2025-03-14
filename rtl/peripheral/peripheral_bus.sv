module Peripheral_BUS (
    // Wishbone Master Interface
    input  logic        clk,
    input  logic        rst_n,

    input  logic        cyc_i,      // Transação ativa
    input  logic        stb_i,      // Requisição ativa
    input  logic        we_i,       // 1 = Write, 0 = Read
    input  logic [31:0] addr_i,     // Endereço de acesso
    input  logic [31:0] data_i,      // Dados de escrita
    output logic [31:0] data_o,      // Dados de leitura
    output logic        ack_o,      // Confirmação da transação

    // Wishbone Peripheral Interface
    output logic        peripheral_1_cyc_o,
    output logic        peripheral_1_stb_o,
    output logic        peripheral_1_we_o,
    input  logic        peripheral_1_ack_i,
    input  logic [31:0] peripheral_1_data_i,

    output logic        peripheral_2_cyc_o,
    output logic        peripheral_2_stb_o,
    output logic        peripheral_2_we_o,
    input  logic        peripheral_2_ack_i,
    input  logic [31:0] peripheral_2_data_i,

    output logic        peripheral_3_cyc_o,
    output logic        peripheral_3_stb_o,
    output logic        peripheral_3_we_o,
    input  logic        peripheral_3_ack_i,
    input  logic [31:0] peripheral_3_data_i,

    output logic        peripheral_4_cyc_o,
    output logic        peripheral_4_stb_o,
    output logic        peripheral_4_we_o,
    input  logic        peripheral_4_ack_i,
    input  logic [31:0] peripheral_4_data_i,

    output logic        peripheral_5_cyc_o,
    output logic        peripheral_5_stb_o,
    output logic        peripheral_5_we_o,
    input  logic        peripheral_5_ack_i,
    input  logic [31:0] peripheral_5_data_i,

    output logic        peripheral_6_cyc_o,
    output logic        peripheral_6_stb_o,
    output logic        peripheral_6_we_o,
    input  logic        peripheral_6_ack_i,
    input  logic [31:0] peripheral_6_data_i,

    output logic        peripheral_7_cyc_o,
    output logic        peripheral_7_stb_o,
    output logic        peripheral_7_we_o,
    input  logic        peripheral_7_ack_i,
    input  logic [31:0] peripheral_7_data_i,

    output logic        peripheral_8_cyc_o,
    output logic        peripheral_8_stb_o,
    output logic        peripheral_8_we_o,
    input  logic        peripheral_8_ack_i,
    input  logic [31:0] peripheral_8_data_i
);

logic [2:0] sel;
assign sel = addr_i[30:28];  // Seleciona qual periférico será ativado

// Multiplexação dos sinais de resposta (ACK e Read Data)
always_comb begin
    unique case (sel)
        3'b000: begin
            data_o = peripheral_1_data_i;
            ack_o = peripheral_1_ack_i;
        end
        3'b001: begin
            data_o = peripheral_2_data_i;
            ack_o = peripheral_2_ack_i;
        end
        3'b010: begin
            data_o = peripheral_3_data_i;
            ack_o = peripheral_3_ack_i;
        end
        3'b011: begin
            data_o = peripheral_4_data_i;
            ack_o = peripheral_4_ack_i;
        end
        3'b100: begin
            data_o = peripheral_5_data_i;
            ack_o = peripheral_5_ack_i;
        end
        3'b101: begin
            data_o = peripheral_6_data_i;
            ack_o = peripheral_6_ack_i;
        end
        3'b110: begin
            data_o = peripheral_7_data_i;
            ack_o = peripheral_7_ack_i;
        end
        3'b111: begin
            data_o = peripheral_8_data_i;
            ack_o = peripheral_8_ack_i;
        end
        default: begin
            data_o = 32'h00000000;
            ack_o = 1'b0;
        end
    endcase
end

// Propagação das requisições para os periféricos
assign peripheral_1_cyc_o = (sel == 3'b000) ? cyc_i : 1'b0;
assign peripheral_2_cyc_o = (sel == 3'b001) ? cyc_i : 1'b0;
assign peripheral_3_cyc_o = (sel == 3'b010) ? cyc_i : 1'b0;
assign peripheral_4_cyc_o = (sel == 3'b011) ? cyc_i : 1'b0;
assign peripheral_5_cyc_o = (sel == 3'b100) ? cyc_i : 1'b0;
assign peripheral_6_cyc_o = (sel == 3'b101) ? cyc_i : 1'b0;
assign peripheral_7_cyc_o = (sel == 3'b110) ? cyc_i : 1'b0;
assign peripheral_8_cyc_o = (sel == 3'b111) ? cyc_i : 1'b0;

assign peripheral_1_stb_o = (sel == 3'b000) ? stb_i : 1'b0;
assign peripheral_2_stb_o = (sel == 3'b001) ? stb_i : 1'b0;
assign peripheral_3_stb_o = (sel == 3'b010) ? stb_i : 1'b0;
assign peripheral_4_stb_o = (sel == 3'b011) ? stb_i : 1'b0;
assign peripheral_5_stb_o = (sel == 3'b100) ? stb_i : 1'b0;
assign peripheral_6_stb_o = (sel == 3'b101) ? stb_i : 1'b0;
assign peripheral_7_stb_o = (sel == 3'b110) ? stb_i : 1'b0;
assign peripheral_8_stb_o = (sel == 3'b111) ? stb_i : 1'b0;

assign peripheral_1_we_o = (sel == 3'b000) ? we_i : 1'b0;
assign peripheral_2_we_o = (sel == 3'b001) ? we_i : 1'b0;
assign peripheral_3_we_o = (sel == 3'b010) ? we_i : 1'b0;
assign peripheral_4_we_o = (sel == 3'b011) ? we_i : 1'b0;
assign peripheral_5_we_o = (sel == 3'b100) ? we_i : 1'b0;
assign peripheral_6_we_o = (sel == 3'b101) ? we_i : 1'b0;
assign peripheral_7_we_o = (sel == 3'b110) ? we_i : 1'b0;
assign peripheral_8_we_o = (sel == 3'b111) ? we_i : 1'b0;

endmodule
