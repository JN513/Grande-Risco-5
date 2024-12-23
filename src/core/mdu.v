module MDU (
    input wire clk,
    input wire reset,
    input wire start,
    output wire done,
    input wire [2:0] operation,
    input wire [31:0] MDU_in_X,
    input wire [31:0] MDU_in_Y,
    output wire [31:0] MDU_out
);

// Operation codes

localparam MUL    = 3'b000; // rd = rs1 * rs2
localparam MULH   = 3'b001; // rd = (rs1 * rs2)[63:32]
localparam MULHSU = 3'b010; // rd = (rs1 * rs2)[63:32]
localparam MULHU  = 3'b011; // rd = (rs1 * rs2)[63:32]
localparam DIV    = 3'b100; // rd = rs1 / rs2
localparam DIVU   = 3'b101; // rd = rs1 / rs2
localparam REM    = 3'b110; // rd = rs1 % rs2
localparam REMU   = 3'b111; // rd = rs1 % rs2

// State machine states

localparam IDLE   = 3'b000;
localparam INIT   = 3'b001;
localparam EXEC   = 3'b010;
localparam FINISH = 3'b011;
localparam DONE   = 3'b100;

// Names of the registers
//
// multiplier = rs1
// multiplicand = rs2
// product = rd
//
// dividend = rs1
// divisor = rs2
// quotient = rd
//
// dividend = rs1
// divisor = rs2
// remainder = rd
//
// MDU_in_X = rs1
// MDU_in_Y = rs2
// MDU_out = rd

// Internal registers

reg mul_done;
reg [2:0] mul_state;
reg [63:0] final_product, product_one, product_two, product_three, product_four;
reg [63:0] multiplicand_1, multiplicand_2, multiplicand_3, multiplicand_4;
reg [7:0] multiplier_1, multiplier_2, multiplier_3, multiplier_4;
reg [31:0] quotient, MUL_RD;

// State machine
always @(posedge clk) begin
    mul_done <= 1'b0;

    if(reset == 1'b1) begin
        mul_state <= IDLE;
        MUL_RD    <= 32'h0;
    end else begin
        case (mul_state)
            IDLE: begin
                mul_state <= IDLE;
                if( start == 1'b1 && ~operation[2]) begin
                    mul_state <= INIT;
                end
            end
            INIT: begin
                multiplier_1 <= MDU_in_X[7:0];
                multiplier_2 <= MDU_in_X[15:8];
                multiplier_3 <= MDU_in_X[23:16];
                multiplier_4 <= MDU_in_X[31:24];

                product_one <= 64'b0;
                product_two <= 64'b0;
                product_three <= 64'b0;
                product_four <= 64'b0;

                if(operation[1:0] == 2'b01) begin
                    multiplicand_1 <= {{32{MDU_in_Y[31]}}, MDU_in_Y[31:0]};
                    multiplicand_2 <= {{24{MDU_in_Y[31]}}, MDU_in_Y[31:0], 8'h0};
                    multiplicand_3 <= {{16{MDU_in_Y[31]}}, MDU_in_Y[31:0], 16'h0};
                    multiplicand_4 <= {{8{MDU_in_Y[31]}}, MDU_in_Y[31:0], 24'h0};
                end else begin
                    multiplicand_1 <= {32'h0, MDU_in_Y[31:0]};
                    multiplicand_2 <= {24'h0, MDU_in_Y[31:0], 8'h0};
                    multiplicand_3 <= {16'h0, MDU_in_Y[31:0], 16'h0};
                    multiplicand_4 <= {8'h0, MDU_in_Y[31:0], 24'h0};
                end

                mul_state <= EXEC;
            end

            EXEC: begin
                product_one <= (multiplier_1[0]) ? product_one + (multiplicand_1) : product_one;
                product_two <= (multiplier_2[0]) ? product_two + (multiplicand_2) : product_two;
                product_three <= (multiplier_3[0]) ? product_three + (multiplicand_3) : product_three;
                product_four <= (multiplier_4[0]) ? product_four + (multiplicand_4) : product_four;

                multiplicand_1 <= multiplicand_1 << 1'b1;
                multiplicand_2 <= multiplicand_2 << 1'b1;
                multiplicand_3 <= multiplicand_3 << 1'b1;
                multiplicand_4 <= multiplicand_4 << 1'b1;

                multiplier_1 <= multiplier_1 >> 1'b1;
                multiplier_2 <= multiplier_2 >> 1'b1;
                multiplier_3 <= multiplier_3 >> 1'b1;
                multiplier_4 <= multiplier_4 >> 1'b1;

                if((~|multiplier_1) && (~|multiplier_2) && (~|multiplier_3) && (~|multiplier_4)) begin
                    mul_state <= FINISH;
                end
            end

            FINISH: begin
                final_product <= product_one + product_two + product_three + product_four;
                mul_state <= DONE;
            end

            DONE: begin
                MUL_RD <= (|operation) ? final_product[63:32] : final_product[31:0];
                mul_done <= 1'b1;
                mul_state <= IDLE;
            end
            default: mul_state <= IDLE;
        endcase
    end
end

localparam DIV_IDLE    = 2'b00;
localparam DIV_OPERATE = 2'b01;
localparam DIV_FINISH  = 2'b10;

reg negativo, div_done;
reg [1:0] state_div;
reg [31:0] dividendo, quociente, quociente_msk, DIV_RD;
reg [63:0] divisor;

always @(posedge clk) begin
    div_done <= 1'b0;
    if(reset == 1'b1) begin
        state_div <= IDLE;
        quociente <= 32'h00000000;
    end else begin
        case (state_div)
            DIV_IDLE: begin
                if(start & operation[2]) begin // se não for multiplicação
                    dividendo <= (!operation[0] & MDU_in_X[31]) ? -MDU_in_X : MDU_in_X;
                    divisor <= {(!operation[0] & MDU_in_Y[31]) ? -MDU_in_Y : MDU_in_Y, 31'h00000000};
                    negativo <= (!operation[0] & !operation[1] & (MDU_in_X[31] != MDU_in_Y[31]) & 
                                (|MDU_in_Y)) | (operation[0] & operation[1] & MDU_in_X[31]);
                    quociente_msk <= 32'h80000000;
                    quociente <= 32'h00000000;
                    state_div <= DIV_OPERATE;
                end else begin
                    state_div <= DIV_IDLE;
                end
            end
            DIV_OPERATE: begin
                if(quociente_msk == 32'h00000001) begin
                    state_div <= DIV_FINISH;
                end else begin
                    state_div <= DIV_OPERATE;
                end

                if(divisor <= dividendo) begin
                    dividendo <= dividendo - divisor;
                    quociente <= quociente | quociente_msk;
                end

                divisor <= divisor >> 1;
                quociente_msk <= quociente_msk >> 1;
            end

            DIV_FINISH: begin
                div_done <= 1'b1;
                if(operation[2] & !operation[1]) begin
                    DIV_RD <= (negativo) ? -quociente : quociente;
                end else begin
                    DIV_RD <= (negativo) ? -dividendo : dividendo;
                end
                state_div <= DIV_IDLE;
            end
            default: state_div <= DIV_IDLE;
        endcase
    end
end

assign done = mul_done | div_done;
assign MDU_out = (operation[2] == 1'b0) ? MUL_RD : DIV_RD;

endmodule
