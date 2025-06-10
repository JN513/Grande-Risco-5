`timescale 1ns / 1ps

module registers_tb ();
    
logic [31:0] read_data_1, read_data_2;
logic [31:0] write_data;
logic [4:0] read_reg_1, read_reg_2, write_reg;
logic clk, reg_write;
integer i;

always #1 clk = ~clk;

Registers Registers(
    .clk        (clk),
    .wr_en_i    (reg_write),
    .data_i     (write_data),
    .RS1_data_o (read_data_1),
    .RS2_data_o (read_data_2),
    .RD_ADDR_i  (write_reg),
    .RS1_ADDR_i (read_reg_1),
    .RS2_ADDR_i (read_reg_2)
);

initial begin
    $dumpfile("build/registers.vcd");
    $dumpvars;
    
    clk = 0;
    read_reg_1 = 0;
    read_reg_2 = 32'h1;

    #2

    $display("lendo estado inicial de dois registradores");

    if(read_data_1 == 32'h00000000) begin
        $display("reg 1 correto");
    end

    if(read_data_2 == 32'h00000000) begin
        $display("reg 2 correto");
    end

    $display("Escrevendo nos registradores");

    for(i = 0; i < 32; i = i + 1) begin
        write_reg = i;
        write_data = i;

        #1

        reg_write = 1'b1;

        #1

        reg_write = 1'b0;
    end

    $display("Lendo registradores");

    for(i = 0; i < 32; i = i + 1) begin
        read_reg_1 = i;

        #1

        if(read_data_1 == i) begin
            $display("Resultado %d correto", i);
        end else begin
            $display("Resultado %d incorreto", i);
        end
    end

    $finish;
end

endmodule
