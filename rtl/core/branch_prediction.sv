module Branch_Prediction (
    input  logic clk,
    input  logic rst_n,

    // fetch
    input  logic valid_instruction_i,
    input  logic [31:0] PC_i,
    input  logic [31:0] instruction_data_i,

    output logic [31:0] address_i
);
    
endmodule
