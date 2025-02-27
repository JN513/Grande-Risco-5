module MUX (
    input  logic [1:0] option,
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [31:0] C,
    input  logic [31:0] D,
    output logic [31:0] S
);

always_comb begin : MUX
    case (option)
        2'b00: S = A; 
        2'b01: S = B; 
        2'b10: S = C; 
        2'b11: S = D; 
        default: S = A;
    endcase
end
    
endmodule
