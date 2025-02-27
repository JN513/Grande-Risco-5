`ifdef ENABLE_BMU

module BMU ( // Bit manipulation unit for riscv B extension
    input  logic clk_i,
    input  logic [4:0]  BMU_OP_i,
    input  logic [31:0] BMU_RS1_i,
    input  logic [31:0] BMU_RS2_i,
    output logic [31:0] BMU_RD_o
);

localparam OP = 7'b0110011;
localparam OPIMM = 7'b0010011;

localparam ANDN   = 5'b00000;
localparam CLMUL  = 5'b00001; // run in other unit
localparam CLMULH = 5'b00010; // run in other unit
localparam CLMULR = 5'b00011; // run in other unit
localparam CLZ    = 5'b00100; // run in other unit
localparam CPOP   = 5'b00101; // run in other unit
localparam CTZ    = 5'b00110; // run in other unit
localparam MAX    = 5'b00111;
localparam MAXU   = 5'b01000;
localparam MIN    = 5'b01001;
localparam MINU   = 5'b01010;
localparam ORCB   = 5'b01011;
localparam ORN    = 5'b01100;
localparam REV8   = 5'b01101;
localparam ROL    = 5'b01110;
localparam ROR    = 5'b01111; // RORI include
localparam BCLR   = 5'b10000; // BCLRI include
localparam BEXT   = 5'b10001; // BEXTI include
localparam BINV   = 5'b10010; // BINVI include
localparam BSET   = 5'b10011; // BSETI include
localparam SEXTB  = 5'b10100;
localparam SEXTH  = 5'b10101;
localparam SH1ADD = 5'b10110;
localparam SH2ADD = 5'b10111;
localparam SH3ADD = 5'b11000;
localparam XNOR   = 5'b11001;
localparam ZEXTH  = 5'b11010;

always_comb begin : BMU_OPERATION
    case (BMU_OP_i)
        ANDN:
            BMU_RD_o = BMU_RS1_i & ~BMU_RS2_i;
            
/*       CLZ: begin
            BMU_RD_o = 0;
            for (int i = 31; i >= 0; i = i -1) begin
                if (BMU_out_X[i] == 1'b0) begin
                    BMU_RD_o = BMU_RD_o + 1'b1;
                end else begin
                    break;
                end
            end
        end
        CPOP: begin
            BMU_RD_o = 0;
            for (int i = 0; i < 32; i = i + 1) begin
                if (BMU_RS1_i[i] == 1'b1) begin
                    BMU_RD_o = BMU_RD_o + 1;
                end
            end
        end
        CTZ: begin
            BMU_RD_o = 0;
            for (int i = 0; i < 32; i = i + 1) begin
                if (BMU_out_X[i] == 1'b1) begin
                    BMU_RD_o = i;
                    break;
                end
            end
            if (~|rs1) begin
                BMU_RD_o = 32; // Se todos os bits forem 0, retorna 32
            end
        end*/

        MAX: begin
            if (BMU_RS1_i[31] == 1 && BMU_RS2_i[31] == 0) begin
                BMU_RD_o = BMU_RS1_i;
            end else if (BMU_RS1_i[31] == 0 && BMU_RS2_i[31] == 1) begin
                BMU_RD_o = BMU_RS2_i;
            end else if (BMU_RS1_i > BMU_RS2_i) begin
                BMU_RD_o = BMU_RS1_i;
            end else begin
                BMU_RD_o = BMU_RS2_i;
            end
        end
        MAXU: begin
            if (BMU_RS1_i > BMU_RS2_i) begin
                BMU_RD_o = BMU_RS1_i;
            end else begin
                BMU_RD_o = BMU_RS2_i;
            end
        end

        MIN: begin
            if (BMU_RS1_i[31] == 1 && BMU_RS2_i[31] == 0) begin
                BMU_RD_o = BMU_RS2_i;
            end else if (BMU_RS1_i[31] == 0 && BMU_RS2_i[31] == 1) begin
                BMU_RD_o = BMU_RS1_i;
            end else if (BMU_RS1_i < BMU_RS2_i) begin
                BMU_RD_o = BMU_RS1_i;
            end else begin
                BMU_RD_o = BMU_RS2_i;
            end
        end

        MINU: begin
            if (BMU_RS1_i < BMU_RS2_i) begin
                BMU_RD_o = BMU_RS1_i;
            end else begin
                BMU_RD_o = BMU_RS2_i;
            end
        end

        ORCB: // Bitwise OR-Combine, byte granule
            BMU_RD_o = {(|BMU_RS1_i[31:24]) ? 8'hFF : 8'h00, 
            (|BMU_RS1_i[23:16]) ? 8'hFF : 8'h00, 
            (|BMU_RS1_i[15:8])  ? 8'hFF : 8'h00, 
            (|BMU_RS1_i[7:0])   ? 8'hFF : 8'h00};

        ORN:
            BMU_RD_o = BMU_RS1_i | ~BMU_RS2_i;

        REV8:
            BMU_RD_o = {BMU_RS1_i[7:0], BMU_RS1_i[15:8], BMU_RS1_i[23:16], BMU_RS1_i[31:24]};

        ROL:
            BMU_RD_o = BMU_RS1_i << BMU_RS2_i[4:0] | BMU_RS1_i >> (32 - BMU_RS2_i[4:0]);

        ROR:
            BMU_RD_o = BMU_RS1_i >> BMU_RS2_i[4:0] | BMU_RS1_i << (32 - BMU_RS2_i[4:0]);

        BCLR:
            BMU_RD_o = BMU_RS1_i & ~(1'b1 << BMU_RS2_i[4:0]);

        BEXT:
            BMU_RD_o = BMU_RS1_i >> BMU_RS2_i[4:0] & 'd1;

        BINV:
            BMU_RD_o = BMU_RS1_i ^ (1'b1 << BMU_RS2_i[4:0]);

        BSET:
            BMU_RD_o = BMU_RS1_i | (1'b1 << BMU_RS2_i[4:0]);

        SEXTB:
            BMU_RD_o = {{24{BMU_RS1_i[7]}}, BMU_RS1_i[7:0]};

        SEXTH:
            BMU_RD_o = {{16{BMU_RS1_i[15]}}, BMU_RS1_i[15:0]};

        SH1ADD:
            BMU_RD_o = BMU_RS1_i + (BMU_RS2_i << 'd1);

        SH2ADD:
            BMU_RD_o = BMU_RS1_i + (BMU_RS2_i << 'd2);

        SH3ADD:
            BMU_RD_o = BMU_RS1_i + (BMU_RS2_i << 'd3);

        XNOR:
            BMU_RD_o = ~(BMU_RS1_i ^ BMU_RS2_i);

        ZEXTH:
            BMU_RD_o = {16'h0, BMU_RS1_i[15:0]};
            
        default: BMU_RD_o = BMU_RS1_i;
    endcase
end
    
endmodule

`endif
