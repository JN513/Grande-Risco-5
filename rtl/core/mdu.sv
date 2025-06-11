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

typedef enum logic [1:0] {
    MUL_IDLE,
    MUL_OPERATE,
    MUL_FINISH
} mul_state_t;

mul_state_t state_mul;

logic [63:0] Data_X;
logic [31:0] Data_Y;
logic [63:0] acumulador;

always_ff @(posedge clk) begin : MUL_FSM_FPGA
    mul_ready_o <= 1'b0;

    if(!rst_n) begin
        Data_X    <= 0;
        Data_Y    <= 0;
        MUL_RD    <= 0;
        state_mul <= MUL_IDLE;
    end else begin
        unique case (state_mul)
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
                state_mul   <= MUL_IDLE;
                MUL_RD      <= (|MDU_op_i[1:0]) ? acumulador[63:32] : acumulador[31:0];
                mul_ready_o <= 1'b1;
            end
            default: state_mul <= MUL_IDLE;
        endcase
    end
end


typedef enum logic [1:0] {
    DIV_IDLE,
    DIV_OPERATE,
    DIV_FINISH
} div_state_t;

div_state_t state_div;

logic negativo, div_ready_o;
logic [31:0] dividendo, quociente, quociente_msk, DIV_RD;
logic [62:0] divisor;

always_ff @(posedge clk) begin : DIV_FSM
    div_ready_o <= 1'b0;
    if(!rst_n) begin
        state_div <= DIV_IDLE;
        quociente <= 32'h0;
    end else begin
        unique case (state_div)
            DIV_IDLE: begin
                if(valid_i && MDU_op_i[2]) begin // se não for multiplicação
                    dividendo     <= (!MDU_op_i[0] & MDU_RS1_i[31]) ? -MDU_RS1_i : MDU_RS1_i;
                    divisor       <= {(!MDU_op_i[0] & MDU_RS2_i[31]) ? -MDU_RS2_i : MDU_RS2_i, 31'h0};
                    quociente_msk <= 32'h80000000;
                    quociente     <= 32'h0;
                    state_div     <= DIV_OPERATE;
                    negativo      <= (!MDU_op_i[0] & !MDU_op_i[1] & (MDU_RS1_i[31] != MDU_RS2_i[31]) & 
                                    (|MDU_RS2_i)) | (MDU_op_i[0] & MDU_op_i[1] & MDU_RS1_i[31]);
                end else begin
                    state_div <= DIV_IDLE;
                end
            end
            DIV_OPERATE: begin
                if(~|quociente_msk[31:1] && quociente_msk[0]) begin // quociente_msk == 32'h00000001
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

                divisor       <= divisor >> 1;
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

assign ready_o  = mul_ready_o | div_ready_o;
assign MDU_RD_o = (MDU_op_i[2]) ? DIV_RD: MUL_RD;

endmodule

`endif
