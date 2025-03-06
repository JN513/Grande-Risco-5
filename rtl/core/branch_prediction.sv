module Branch_Prediction #(
    parameter BRANCH_PREDICTION_SIZE = 1024
) (
    input  logic clk,
    input  logic rst_n,

    // fetch
    input  logic is_incondicional_jump,
    input  logic is_condicional_jump,
    input  logic valid_instruction_i,
    input  logic [31:0] PC_i,
    input  logic [31:0] instruction_data_i,

    //solve
    input  logic [31:0] branch_address_i,
    input  logic branch_taken_i,
    input  logic is_branch_i,
    input  logic [31:0] address_to_jump_i,

    output logic [31:0] address_o
);

typedef enum logic [1:0] { 
    NOT_TAKEN_STRONG = 2'b00,
    NOT_TAKEN_WEAK   = 2'b01,
    TAKEN_WEAK       = 2'b10,
    TAKEN_STRONG     = 2'b11
} prediction_type_t;

prediction_type_t prediction      [0:BRANCH_PREDICTION_SIZE-1];
logic [31:0]      address_to_jump [0:BRANCH_PREDICTION_SIZE-1];
    
always_ff @( clk ) begin : BRANCH_PREDICTION_FSM
    if(!rst_n) begin
        prediction <= '{default:NOT_TAKEN_WEAK};
    end else begin
        if(is_branch_i) begin
            if(branch_taken_i) begin
                prediction[PC_i[31:1]]      <= (prediction[PC_i[31:1]] == TAKEN_STRONG) ? 
                    TAKEN_STRONG : prediction[PC_i[31:1]] + 1'b1;
                address_to_jump[PC_i[31:1]] <= branch_address_i;
            end else begin
                prediction[PC_i[31:1]] <= (prediction[PC_i[31:1]] == NOT_TAKEN_WEAK) ? 
                    TAKEN_STRONG : prediction[PC_i[31:1]] - 1'b1;
            end
        end
    end
end

always_comb begin: PREDICTION_ADDRESS_GENERATION
    if(is_condicional_jump) begin
        if(prediction[PC_i[31:1]][1]) begin
            address_o = address_to_jump[PC_i[31:1]];
        end else begin
            address_o = PC_i + 4;
        end
    end
end

endmodule
