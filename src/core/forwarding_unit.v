module Forwarding_Unit (
    input wire immediate,
    input wire pc_operation,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] ex_mem_stage_rd,
    input wire [4:0] mem_wb_stage_rd,
    output reg [1:0] op_rs1,
    output reg [1:0] op_rs2
);

always @(*) begin
    if(pc_operation == 1'b1) begin
        op_rs1 = 2'b11;
    end else if(ex_mem_stage_rd == rs1 && rs1 != 0) begin
        op_rs1 = 2'b10;
    end else if(mem_wb_stage_rd == rs1 && rs1 != 0) begin
        op_rs1 = 2'b01;
    end else begin
        op_rs1 = 2'b00;
    end

    if(immediate == 1'b1) begin
        op_rs2 = 2'b11;
    end else if(ex_mem_stage_rd == rs2 && rs2 != 0) begin
        op_rs2 = 2'b10;
    end else if(mem_wb_stage_rd == rs2 && rs2 != 0) begin
        op_rs2 = 2'b01;
    end else begin
        op_rs2 = 2'b00;
    end
end
    
endmodule