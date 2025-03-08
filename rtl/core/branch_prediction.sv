module Branch_Prediction #(
    parameter BRANCH_PREDICTION_SIZE = 512
) (
    input  logic clk,
    input  logic rst_n,

    // fetch
    input  logic is_jump,
    input  logic [31:0] PC_i,

    // solve branch
    input  logic [31:0] branch_address_i,
    input  logic branch_taken_i,
    input  logic is_branch_i,
    input  logic [31:0] address_to_branch_i,

    // solve jump
    input  logic [31:0] jal_address_i,
    input  logic [31:0] jalr_address_i,
    input  logic is_jal_i,
    input  logic is_jalr_i,
    input  logic [31:0] address_to_jal_i,
    input  logic [31:0] address_to_jalr_i,

    // output
    output logic prediction_taken_o,
    output logic [31:0] address_o
);

localparam MOST_SIGNIFICATIVE_BIT = $clog2(BRANCH_PREDICTION_SIZE);

// Índices de acesso para a tabela de predição
logic [MOST_SIGNIFICATIVE_BIT-1:0] index, prediction_index, jal_index, jalr_index;

assign index            = PC_i             [MOST_SIGNIFICATIVE_BIT:1];
assign prediction_index = branch_address_i [MOST_SIGNIFICATIVE_BIT:1];
assign jal_index        = jal_address_i    [MOST_SIGNIFICATIVE_BIT:1];
assign jalr_index       = jalr_address_i   [MOST_SIGNIFICATIVE_BIT:1];

// Definição de estados para a predição
typedef enum logic [1:0] { 
    NOT_TAKEN_STRONG = 2'b00,
    NOT_TAKEN_WEAK   = 2'b01,
    TAKEN_WEAK       = 2'b10,
    TAKEN_STRONG     = 2'b11
} prediction_type_t;

// Tabela de predição e endereços de salto
prediction_type_t prediction      [0:BRANCH_PREDICTION_SIZE-1];
logic [31:0]      address_to_jump [0:BRANCH_PREDICTION_SIZE-1];


always_ff @(posedge clk) begin : BRANCH_PREDICTION_FSM
    if (!rst_n) begin
        prediction <= '{default: NOT_TAKEN_STRONG};
    end else begin
        if (is_branch_i) begin
            // Atualizar tabela de predição de branches
            if (branch_taken_i) begin
                if (prediction[prediction_index] != TAKEN_STRONG)
                    prediction[prediction_index]  <= prediction_type_t'(prediction[prediction_index] + 2'b01);
                address_to_jump[prediction_index] <= address_to_branch_i;
            end else begin
                if (prediction[prediction_index] != NOT_TAKEN_STRONG)
                    prediction[prediction_index] <= prediction_type_t'(prediction[prediction_index] - 2'b01);
            end
        end else if (is_jal_i) begin
            address_to_jump[jal_index] <= address_to_jal_i;
            
            if (prediction[jal_index] != TAKEN_STRONG)
                prediction[jal_index] <= prediction_type_t'(prediction[jal_index] + 2'b01);
        end else if (is_jalr_i) begin
            address_to_jump[jalr_index] <= address_to_jalr_i;
            
            if (prediction[jalr_index] != TAKEN_STRONG)
                prediction[jalr_index] <= prediction_type_t'(prediction[jalr_index] + 2'b01);
        end
    end
end

// Saída baseada na tabela de predição
assign address_o = address_to_jump[index];
assign prediction_taken_o = prediction[index][1] & is_jump;

endmodule
