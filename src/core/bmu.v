module BMU ( // Bit manipulation unit for riscv B extension
    input wire clk,
    input wire [4:0] option,
    input wire [31:0] BMU_in_X,
    input wire [31:0] BMU_in_Y,
    output wire [31:0] BMU_out_S
);

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

always @(*) begin
    case (option)
        ANDN: begin
            BMU_out_S = BMU_in_X & ~BMU_in_Y;
        end
/*        CLZ: begin
            BMU_out_S = 0;
            for (int i = 31; i >= 0; i = i -1) begin
                if (BMU_out_X[i] == 1'b0) begin
                    BMU_out_S = BMU_out_S + 1'b1;
                end else begin
                    break;
                end
            end
        end
        CPOP: begin
            BMU_out_S = 0;
            for (int i = 0; i < 32; i = i + 1) begin
                if (BMU_in_X[i] == 1'b1) begin
                    BMU_out_S = BMU_out_S + 1;
                end
            end
        end
        CTZ: begin
            BMU_out_S = 0;
            for (int i = 0; i < 32; i = i + 1) begin
                if (BMU_out_X[i] == 1'b1) begin
                    BMU_out_S = i;
                    break;
                end
            end
            if (~|rs1) begin
                BMU_out_S = 32; // Se todos os bits forem 0, retorna 32
            end
        end*/

        MAX: begin
            if (BMU_in_X[31] == 1 && BMU_in_Y[31] == 0) begin
                BMU_out_S = BMU_in_X;
            end else if (BMU_in_X[31] == 0 && BMU_in_Y[31] == 1) begin
                BMU_out_S = BMU_in_Y;
            end else if (BMU_in_X > BMU_in_Y) begin
                BMU_out_S = BMU_in_X;
            end else begin
                BMU_out_S = BMU_in_Y;
            end
        end
        MAXU: begin
            if (BMU_in_X > BMU_in_Y) begin
                BMU_out_S = BMU_in_X;
            end else begin
                BMU_out_S = BMU_in_Y;
            end
        end

        MIN: begin
            if (BMU_in_X[31] == 1 && BMU_in_Y[31] == 0) begin
                BMU_out_S = BMU_in_Y;
            end else if (BMU_in_X[31] == 0 && BMU_in_Y[31] == 1) begin
                BMU_out_S = BMU_in_X;
            end else if (BMU_in_X < BMU_in_Y) begin
                BMU_out_S = BMU_in_X;
            end else begin
                BMU_out_S = BMU_in_Y;
            end
        end

        MINU: begin
            if (BMU_in_X < BMU_in_Y) begin
                BMU_out_S = BMU_in_X;
            end else begin
                BMU_out_S = BMU_in_Y;
            end
        end

        ORCB: begin // Bitwise OR-Combine, byte granule
            BMU_out_S = {(|BMU_in_X[31:24]) ? 8'hFF : 8'h00, 
            (|BMU_in_X[23:16]) ? 8'hFF : 8'h00, 
            (|BMU_in_X[15:8])  ? 8'hFF : 8'h00, 
            (|BMU_in_X[7:0])   ? 8'hFF : 8'h00};
        end

        ORN: begin
            BMU_out_S = BMU_in_X | ~BMU_in_Y;
        end

        REV8: begin
            BMU_out_S = {BMU_in_X[7:0], BMU_in_X[15:8], BMU_in_X[23:16], BMU_in_X[31:24]};
        end

        ROL: begin
            BMU_out_S = BMU_in_X << BMU_in_Y[4:0] | BMU_in_X >> (32 - BMU_in_Y[4:0]);
        end

        ROR: begin
            BMU_out_S = BMU_in_X >> BMU_in_Y[4:0] | BMU_in_X << (32 - BMU_in_Y[4:0]);
        end

        BCLR: begin
            BMU_out_S = BMU_in_X & ~(1'b1 << BMU_in_Y[4:0]);
        end

        BEXT: begin
            BMU_out_S = BMU_in_X >> BMU_in_Y[4:0] & 'd1;
        end

        BINV: begin
            BMU_out_S = BMU_in_X ^ (1'b1 << BMU_in_Y[4:0]);
        end

        BSET: begin
            BMU_out_S = BMU_in_X | (1'b1 << BMU_in_Y[4:0]);
        end

        SEXTB: begin
            BMU_out_S = {{24{BMU_in_X[7]}}, BMU_in_X[7:0]};
        end

        SEXTH: begin
            BMU_out_S = {{16{BMU_in_X[15]}}, BMU_in_X[15:0]};
        end

        SH1ADD: begin
            BMU_out_S = BMU_in_X + (BMU_in_Y << 'd1);
        end

        SH2ADD: begin
            BMU_out_S = BMU_in_X + (BMU_in_Y << 'd2);
        end

        SH3ADD: begin
            BMU_out_S = BMU_in_X + (BMU_in_Y << 'd3);
        end

        XNOR: begin
            BMU_out_S = ~(BMU_in_X ^ BMU_in_Y);
        end

        ZEXTH: begin
            BMU_out_S = {16{1'b0}, BMU_in_X[15:0]};
        end
        default: 
    endcase
end
    
endmodule
