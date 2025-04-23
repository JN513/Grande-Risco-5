`include "defines.vh"

`ifdef ENABLE_MDU
module MDU (
    input  logic clk,
    input  logic rst_n,
    input  logic valid_i,
    output logic ready_o,
    input  logic [2:0]  MDU_op_i,
    input  logic [31:0] MDU_RS1_i,
    input  logic [31:0] MDU_RS2_i,
    output logic [31:0] MDU_RD_o
);

// MDU_op_i codes

localparam MUL    = 3'b000; // rd = rs1 * rs2
localparam MULH   = 3'b001; // rd = (rs1 * rs2)[63:32]
localparam MULHSU = 3'b010; // rd = (rs1 * rs2)[63:32]
localparam MULHU  = 3'b011; // rd = (rs1 * rs2)[63:32]
localparam DIV    = 3'b100; // rd = rs1 / rs2
localparam DIVU   = 3'b101; // rd = rs1 / rs2
localparam REM    = 3'b110; // rd = rs1 % rs2
localparam REMU   = 3'b111; // rd = rs1 % rs2


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
// MDU_RS1_i = rs1
// MDU_RS2_i = rs2
// MDU_RD_o = rd

// Internal registers



logic mul_ready_o;
logic [31:0] MUL_RD;


`ifdef FPGA

typedef enum logic [1:0] {
    MUL_IDLE    = 2'b00,
    MUL_OPERATE = 2'b01,
    MUL_FINISH  = 2'b10
} mul_state_t;

mul_state_t state_mul;

logic [63:0] Data_X;
logic [31:0] Data_Y;
logic [63:0] acumulador;

always_ff @(posedge clk) begin : MUL_FSM_FPGA
    mul_ready_o <= 1'b0;

    if(!rst_n) begin
        Data_X <= 0;
        Data_Y <= 0;
        MUL_RD <= 0;
        state_mul <= MUL_IDLE;
    end else begin
        case (state_mul)
            MUL_IDLE: begin
                if(valid_i & !MDU_op_i[2]) begin
                    state_mul <= MUL_OPERATE;
                    unique case (MDU_op_i[1:0])
                        2'b00: begin // MUL
                            Data_X <= {{32{MDU_RS1_i[31]}}, MDU_RS1_i};
                            Data_Y <= $signed(MDU_RS2_i);
                        end
                        2'b01: begin // MULH
                            Data_X <= {{32{MDU_RS1_i[31]}}, MDU_RS1_i};
                            Data_Y <= $signed(MDU_RS2_i);
                        end
                        2'b10: begin // MULHSU
                            Data_X <= {{32{MDU_RS1_i[31]}}, MDU_RS1_i};
                            Data_Y <= $unsigned(MDU_RS2_i);
                        end
                        2'b11: begin // MULHU
                            Data_X <= {32'b0, MDU_RS1_i};
                            Data_Y <= $unsigned(MDU_RS2_i);
                        end
                    endcase
                end else begin
                    state_mul <= MUL_IDLE;
                end
            end 
            MUL_OPERATE: begin
                unique case (MDU_op_i[1:0])
                    2'b00, 2'b01: // MUL ou MULH (ambos signed)
                        acumulador <= $signed(Data_X) * $signed(Data_Y);
                    2'b10: // MULHSU
                        acumulador <= $signed(Data_X) * $unsigned(Data_Y);
                    2'b11: // MULHU
                        acumulador <= $unsigned(Data_X) * $unsigned(Data_Y);
                endcase
                state_mul <= MUL_FINISH;
            end

            MUL_FINISH: begin
                state_mul <= MUL_IDLE;
                MUL_RD <= (|MDU_op_i) ? acumulador[63:32] : acumulador[31:0];
                mul_ready_o <= 1'b1;
            end
            default: state_mul <= MUL_IDLE;
        endcase
    end
end

`else
// State machine states

typedef enum logic [2:0] {
    MUL_IDLE   = 3'b000,
    MUL_INIT   = 3'b001,
    MUL_EXEC   = 3'b010,
    MUL_FINISH = 3'b011,
    MUL_ready_o   = 3'b100
} mul_state_t;

mul_state_t mul_state;
logic [63:0] final_product, product_one, product_two, product_three, product_four;
logic [63:0] multiplicand_1, multiplicand_2, multiplicand_3, multiplicand_4;
logic [7:0] multiplier_1, multiplier_2, multiplier_3, multiplier_4;

// State machine
always_ff @(posedge clk) begin : MUL_FSM
    mul_ready_o <= 1'b0;

    if(!rst_n) begin
        mul_state <= MUL_IDLE;
        MUL_RD    <= 32'h0;
    end else begin
        case (mul_state)
            MUL_IDLE: begin
                mul_state <= MUL_IDLE;
                if( valid_i == 1'b1 && !MDU_op_i[2]) begin
                    mul_state <= MUL_INIT;
                end
            end
            MUL_INIT: begin
                multiplier_1 <= MDU_RS1_i[7:0];
                multiplier_2 <= MDU_RS1_i[15:8];
                multiplier_3 <= MDU_RS1_i[23:16];
                multiplier_4 <= MDU_RS1_i[31:24];

                product_one <= 64'b0;
                product_two <= 64'b0;
                product_three <= 64'b0;
                product_four <= 64'b0;

                if(MDU_op_i[1:0] == 2'b01) begin
                    multiplicand_1 <= {{32{MDU_RS2_i[31]}}, MDU_RS2_i[31:0]};
                    multiplicand_2 <= {{24{MDU_RS2_i[31]}}, MDU_RS2_i[31:0], 8'h0};
                    multiplicand_3 <= {{16{MDU_RS2_i[31]}}, MDU_RS2_i[31:0], 16'h0};
                    multiplicand_4 <= {{8{MDU_RS2_i[31]}}, MDU_RS2_i[31:0], 24'h0};
                end else begin
                    multiplicand_1 <= {32'h0, MDU_RS2_i[31:0]};
                    multiplicand_2 <= {24'h0, MDU_RS2_i[31:0], 8'h0};
                    multiplicand_3 <= {16'h0, MDU_RS2_i[31:0], 16'h0};
                    multiplicand_4 <= {8'h0, MDU_RS2_i[31:0], 24'h0};
                end

                mul_state <= MUL_EXEC;
            end

            MUL_EXEC: begin
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
                    mul_state <= MUL_FINISH;
                end
            end

            MUL_FINISH: begin
                final_product <= product_one + product_two + product_three + product_four;
                mul_state <= MUL_ready_o;
            end

            MUL_ready_o: begin
                MUL_RD <= (|MDU_op_i) ? final_product[63:32] : final_product[31:0];
                mul_ready_o <= 1'b1;
                mul_state <= MUL_IDLE;
            end
            default: mul_state <= MUL_IDLE;
        endcase
    end
end

`endif

typedef enum logic [1:0] {
    DIV_IDLE    = 2'b00,
    DIV_OPERATE = 2'b01,
    DIV_FINISH  = 2'b10
} div_state_t;

div_state_t state_div;

logic negativo, div_ready_o;
logic [31:0] dividendo, quociente, quociente_msk, DIV_RD;
logic [62:0] divisor;

always_ff @(posedge clk) begin : DIV_FSM
    div_ready_o <= 1'b0;
    if(!rst_n) begin
        state_div <= DIV_IDLE;
        quociente <= 32'h00000000;
    end else begin
        case (state_div)
            DIV_IDLE: begin
                if(valid_i & MDU_op_i[2]) begin // se não for multiplicação
                    dividendo <= (!MDU_op_i[0] & MDU_RS1_i[31]) ? -MDU_RS1_i : MDU_RS1_i;
                    divisor <= {(!MDU_op_i[0] & MDU_RS2_i[31]) ? -MDU_RS2_i : MDU_RS2_i, 31'h00000000};
                    negativo <= (!MDU_op_i[0] & !MDU_op_i[1] & (MDU_RS1_i[31] != MDU_RS2_i[31]) & 
                                (|MDU_RS2_i)) | (MDU_op_i[0] & MDU_op_i[1] & MDU_RS1_i[31]);
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
                /* verilator lint_off WIDTHEXPAND */
                /* verilator lint_off WIDTHTRUNC */
                if(divisor <= dividendo) begin
                    dividendo <= dividendo - divisor;
                    quociente <= quociente | quociente_msk;
                end
                /* verilator lint_on WIDTHEXPAND */
                /* verilator lint_on WIDTHTRUNC */

                divisor <= divisor >> 1;
                quociente_msk <= quociente_msk >> 1;
            end

            DIV_FINISH: begin
                div_ready_o <= 1'b1;
                if(MDU_op_i[2] & !MDU_op_i[1]) begin
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

assign ready_o = mul_ready_o | div_ready_o;
assign MDU_RD_o = (MDU_op_i[2] == 1'b0) ? MUL_RD : DIV_RD;

endmodule

`endif
