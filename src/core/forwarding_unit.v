module Forwarding_Unit (
    input wire previous_instruction_is_lw,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] ex_mem_stage_rd,
    input wire [4:0] mem_wb_stage_rd,
    output reg [1:0] op_rs1,
    output reg [1:0] op_rs2
);

localparam LW_OPCODE = 7'b0000011;

always @(*) begin
    op_rs1 = 2'b00;
    op_rs2 = 2'b00;

    if(ex_mem_stage_rd == rs1 && |rs1) begin
        if(previous_instruction_is_lw) begin
            op_rs1 = 2'b11;
        end else begin
            op_rs1 = 2'b10;
        end
    end else if(mem_wb_stage_rd == rs1 && |rs1) begin
        op_rs1 = 2'b01;
    end

    if(ex_mem_stage_rd == rs2 && |rs2) begin
        if(previous_instruction_is_lw) begin
            op_rs2 = 2'b11;
        end else begin
            op_rs2 = 2'b10;
        end
    end else if(mem_wb_stage_rd == rs2 && |rs2) begin
        op_rs2 = 2'b01;
    end
end
    
endmodule
