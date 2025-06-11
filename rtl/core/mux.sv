module MUX (
    input  logic [1:0] op_i,
    input  logic [31:0] A_i,
    input  logic [31:0] B_i,
    input  logic [31:0] C_i,
    input  logic [31:0] D_i,
    output logic [31:0] S_o
);

always_comb begin : MUX
    unique case (op_i)
        2'b00:   S_o = A_i; 
        2'b01:   S_o = B_i; 
        2'b10:   S_o = C_i; 
        2'b11:   S_o = D_i; 
        default: S_o = A_i;
    endcase
end
    
endmodule
