module UART_RX #(
    parameter BAUD_RATE  = 115200,  // Baud rate
    parameter CLK_FREQ   = 50000000 // Clock frequency
) (
    input logic clk,
    input logic rst_n,

    input logic wr_bit_period_i,
    input logic [15:0] bit_period_i,

    input logic uart_rxd,
    input logic uart_rx_en,

    output logic uart_rx_parity_error,
    output logic uart_rx_valid,
    output logic [7:0] uart_rx_data
);

localparam DEFAULT_BIT_PERIOD = 16'((CLK_FREQ / BAUD_RATE) - 1);

logic [3:0] bit_index;
logic [15:0] counter;  
logic [7:0] buffer;  
logic [15:0] bit_period;
logic parity_bit;

typedef enum logic [2:0] { 
    IDLE,
    START,
    RECEIVE,
    PARITY,
    STOP
} uart_rx_state_t;

uart_rx_state_t state;

// FSM Principal
always_ff @(posedge clk) begin : UART_RX_FSM
    if (!rst_n || wr_bit_period_i) begin
        uart_rx_valid <= 1'b0;
        counter       <= 16'h0;
        bit_index     <= 4'h0;
        state         <= IDLE; // Inicialização do estado
        uart_rx_parity_error  <= 1'b0; // Reseta o erro de paridade
    end else if (uart_rx_en) begin
        unique case (state)
            IDLE: begin
                uart_rx_valid <= 1'b0; // Garante reset do sinal válido
                if (!uart_rxd) begin
                    uart_rx_parity_error <= 1'b0; // Reseta o erro de paridade
                    counter      <= bit_period; // Espera o bit de start
                    bit_index    <= 4'h0;
                    state        <= START;
                end
            end
            START: begin
                if (counter > 0) begin
                    counter <= counter - 1'b1;
                end else begin
                    counter <= bit_period - 5;
                    state   <= RECEIVE;
                end
            end
            RECEIVE: begin
                if (counter > 0) begin
                    counter <= counter - 1'b1;
                end else begin
                    counter <= bit_period;
                    buffer <= {uart_rxd, buffer[7:1]}; // Recebe os dados
                    if (bit_index < 'd7) begin
                        bit_index <= bit_index + 1'b1;
                    end else begin
                        uart_rx_data  <= {uart_rxd, buffer[7:1]}; // Atualiza os dados recebidos
                        parity_bit    <= ^{uart_rxd, buffer[7:1]}; // Calcula o bit de paridade
                        state         <= PARITY;
                    end
                end
            end
            PARITY: begin
                if (counter > 0) begin
                    counter <= counter - 1'b1;
                end else begin
                    counter <= bit_period;
                    if (uart_rxd != parity_bit) begin
                        uart_rx_parity_error  <= 1'b1; // Erro de paridade
                        uart_rx_valid         <= 1'b0; // Erro de paridade
                    end else begin
                        uart_rx_valid         <= 1'b1; // Dados válidos
                        uart_rx_parity_error  <= 1'b0; // Reseta o erro de paridade
                    end
                    state <= STOP;
                end
            end
            STOP: begin
                uart_rx_valid <= 1'b0; // Garante reset do sinal válido
                if (counter > 0) begin
                    counter <= counter - 1'b1;
                end else begin
                    state   <= IDLE;
                end
            end
            default: state <= IDLE; // Garante retorno ao IDLE se uart_rx_en for desativado
        endcase
    end else begin
        state <= IDLE; // Garante retorno ao IDLE se uart_rx_en for desativado
    end
end

// Atualização do bit_period
always_ff @(posedge clk) begin
    if (!rst_n) begin
        bit_period <= DEFAULT_BIT_PERIOD;
    end else if (wr_bit_period_i) begin
        bit_period <= bit_period_i;
    end
end

endmodule