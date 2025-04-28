module UART_TX #(
    parameter BAUD_RATE = 115200,  // Baud rate
    parameter CLK_FREQ  = 50000000 // Clock frequency
) (
    input logic clk,
    input logic rst_n,

    input logic wr_bit_period_i,
    input logic [15:0] bit_period_i,

    input logic uart_tx_en,
    input logic [7:0] uart_tx_data,

    output logic uart_txd,
    output logic uart_tx_busy
);

localparam DEFAULT_BIT_PERIOD = 16'((CLK_FREQ / BAUD_RATE) - 1);

logic [7:0] uart_tx_data_internal;
logic [3:0]  bit_index;
logic [15:0] counter;   // Bit counter
logic [15:0] bit_period;
logic parity_bit;

typedef enum logic [2:0] { 
    IDLE,
    START,
    SEND,
    PARITY_BIT,
    STOP
} uart_tx_state_t;

uart_tx_state_t state;

// FSM Principal
always_ff @(posedge clk or negedge rst_n) begin : UART_TX_FSM
    if (!rst_n) begin
        uart_txd     <= 1'b1;
        uart_tx_busy <= 1'b0;
        counter      <= 16'd0;
        bit_index    <= 4'd0;
        state        <= IDLE;
        parity_bit   <= 0;
    end else begin
        unique case (state)
            IDLE: begin
                uart_txd     <= 1'b1;
                uart_tx_busy <= 1'b0; // Desativa busy no estado IDLE
                if (uart_tx_en) begin
                    parity_bit            <= ^uart_tx_data;
                    uart_tx_data_internal <= uart_tx_data;
                    counter      <= bit_period; // Usa bit_period atualizado
                    bit_index    <= 4'd0;
                    state        <= START;
                    uart_tx_busy <= 1'b1; // Ativa busy quando começa a transmissão
                end
            end
            START: begin
                uart_txd <= 1'b0; // Envia o start bit
                if (counter > 0) begin
                    counter <= counter - 1'b1;
                end else begin
                    counter   <= bit_period;
                    uart_txd  <= uart_tx_data_internal[0]; // Primeiro bit de dados
                    uart_tx_data_internal <= {1'b0, uart_tx_data_internal[7:1]};
                    bit_index <= bit_index + 1'b1;
                    state     <= SEND;
                end
            end
            SEND: begin
                if (counter > 0) begin
                    counter <= counter - 1'b1;
                end else begin
                    counter <= bit_period;
                    if (bit_index < 'd8) begin
                        uart_txd  <= uart_tx_data_internal[0]; // Primeiro bit de dados
                        uart_tx_data_internal <= {1'b0, uart_tx_data_internal[7:1]};
                        bit_index <= bit_index + 1'b1;
                    end else begin
                        uart_txd <= parity_bit; // Garante que a linha vá para alto (STOP bit)
                        state    <= PARITY_BIT;
                    end
                end
            end
            PARITY_BIT: begin
                if (counter > 0) begin
                    counter <= counter - 1'b1;
                end else begin
                    counter   <= bit_period; 
                    uart_txd  <= 1'b1; // Garante que a linha vá para alto (STOP bit)
                    state     <= STOP;
                end
            end
            STOP: begin
                uart_txd <= 1'b1; // Garante que a linha fique alta
                if (counter > 0) begin
                    counter <= counter - 1'b1;
                end else begin
                    state   <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
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