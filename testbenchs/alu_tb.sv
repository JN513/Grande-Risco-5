`timescale 1ns/1ps

module alu_tb;
    logic [3:0] ALU_OP_i;
    logic [31:0] ALU_RS1_i;
    logic [31:0] ALU_RS2_i;
    logic [31:0] ALU_RD_o;
    logic ALU_ZR_o;

    // Instância da ALU
    Alu uut (
        .ALU_OP_i(ALU_OP_i),
        .ALU_RS1_i(ALU_RS1_i),
        .ALU_RS2_i(ALU_RS2_i),
        .ALU_RD_o(ALU_RD_o),
        .ALU_ZR_o(ALU_ZR_o)
    );

    initial begin
        $dumpfile("build/alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // Teste AND
        ALU_OP_i = 4'b0000;
        ALU_RS1_i = 32'hA5A5A5A5;
        ALU_RS2_i = 32'h5A5A5A5A;
        #10;
        assert(ALU_RD_o == (ALU_RS1_i & ALU_RS2_i)) else $error("Erro: AND falhou");

        // Teste OR
        ALU_OP_i = 4'b0001;
        #10;
        assert(ALU_RD_o == (ALU_RS1_i | ALU_RS2_i)) else $error("Erro: OR falhou");

        // Teste XOR
        ALU_OP_i = 4'b1000;
        #10;
        assert(ALU_RD_o == (ALU_RS1_i ^ ALU_RS2_i)) else $error("Erro: XOR falhou");

        // Teste NOR
        ALU_OP_i = 4'b1001;
        #10;
        assert(ALU_RD_o == ~(ALU_RS1_i | ALU_RS2_i)) else $error("Erro: NOR falhou");

        // Teste Soma
        ALU_OP_i = 4'b0010;
        ALU_RS1_i = 32'd15;
        ALU_RS2_i = 32'd10;
        #10;
        assert(ALU_RD_o == 32'd25) else $error("Erro: Soma falhou");

        // Teste Subtração
        ALU_OP_i = 4'b1010;
        #10;
        assert(ALU_RD_o == 32'd5) else $error("Erro: Subtração falhou");

        // Teste Shift Left
        ALU_OP_i = 4'b0100;
        ALU_RS1_i = 32'h00000001;
        ALU_RS2_i = 32'd4;
        #10;
        assert(ALU_RD_o == 32'h00000010) else $error("Erro: Shift Left falhou");

        // Teste Shift Right
        ALU_OP_i = 4'b0101;
        ALU_RS1_i = 32'h00000010;
        ALU_RS2_i = 32'd4;
        #10;
        assert(ALU_RD_o == 32'h00000001) else $error("Erro: Shift Right falhou");

        // Teste Shift Right Aritmético
        ALU_OP_i = 4'b0111;
        ALU_RS1_i = 32'h80000000;
        ALU_RS2_i = 32'd4;
        #10;
        assert(ALU_RD_o == 32'hF8000000) else $error("Erro: Shift Right Aritmético falhou");

        // Teste de Comparação SLT
        ALU_OP_i = 4'b1110;
        ALU_RS1_i = 32'h00000002;
        ALU_RS2_i = 32'h00000003;
        #10;
        assert(ALU_RD_o == 1) else $error("Erro: SLT falhou");

        // Teste de Igualdade
        ALU_OP_i = 4'b0011;
        ALU_RS1_i = 32'h00000005;
        ALU_RS2_i = 32'h00000005;
        #10;
        assert(ALU_RD_o == 1) else $error("Erro: Igualdade falhou");

        // Teste Zero Result
        ALU_OP_i = 4'b0010;
        ALU_RS1_i = 32'd10;
        ALU_RS2_i = -32'd10;
        #10;
        assert(ALU_ZR_o == 1) else $error("Erro: ALU_ZR_o falhou");

        $display("Testbench finalizado com sucesso.");
        $finish;
    end
endmodule
