`ifdef ENABLE_FPU

module FPU (
    input  logic clk,
    input  logic rst_n,
    input  logic [31:0] FPU_RS1_i,
    input  logic [31:0] FPU_RS2_i,
    input  logic [2:0]  FPU_op_i,
    output logic [31:0] FPU_RD_o
);
    
endmodule

`endif
