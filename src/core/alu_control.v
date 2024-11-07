module ALU_Control (
    input wire is_immediate,
    input wire [1:0] aluop_in,
    input wire [6:0] func7,
    input wire [2:0] func3,
    output reg [3:0] aluop_out
);

always @(*) begin
    aluop_out <= 4'b0010; // Default para SUM
    case (aluop_in)
        2'b00: 
            aluop_out <= 4'b0010; // SUM

        2'b01: begin
            case (func3)
                3'b000: // beq
                    aluop_out <= 4'b1010; // SUB
                3'b100: // blt
                    aluop_out <= 4'b1100; // GREATER_EQUAL
                3'b110: // bltu  
                    aluop_out <= 4'b1101; // GREATER_EQUAL_U
                3'b101: // bge
                    aluop_out <= 4'b1110; // SLT
                3'b111: // bgeu
                    aluop_out <= 4'b1111; // SLT_U
                3'b001: // bne
                    aluop_out <= 4'b0011; // EQUAL
                default: aluop_out <= 4'b1010; // Default para SUB
            endcase
        end

        2'b10: begin
            case (func3)
                3'b000: // addi, add e sub
                    if(is_immediate == 1'b0 && func7[5] == 1'b1)
                        aluop_out <= 4'b1010; // SUB
                    else
                        aluop_out <= 4'b0010; // SUM
                3'b001: // slli e sll
                    aluop_out <= 4'b0100; // SHIFT_LEFT
                3'b010: // slti e slt
                    aluop_out <= 4'b1110; // SLT
                3'b011: // sltiu e sltu
                    aluop_out <= 4'b1111; // SLT_U
                3'b100: // xori e xor
                    aluop_out <= 4'b1000; // XOR
                3'b101: // srai, srli e sra, srl
                    if(func7[5] == 1'b1)
                        aluop_out <= 4'b0111; // SHIFT_RIGHT_A
                    else
                        aluop_out <= 4'b0101; // SHIFT_RIGHT
                3'b110: // ori e or
                    aluop_out <= 4'b0001; // OR
                3'b111: // andi e and
                    aluop_out <= 4'b0000; // AND
                default: aluop_out <= 4'b0010; // Default para SUM
            endcase
        end
    endcase
end

endmodule
