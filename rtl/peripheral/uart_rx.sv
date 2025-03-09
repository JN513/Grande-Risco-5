module UART_RX #(
    parameter BAUD_RATE  = 115200,  // Baud rate
    parameter CLK_FREQ  = 50000000 // Clock frequency
) (
    input logic clk,
    input logic rst_n,

    input logic wr_bit_period_i,
    input logic [15:0] bit_period_i,

    input logic uart_rxd,
    input logic uart_rx_en,

    output logic uart_rx_valid,
    output logic [7:0] uart_rx_data
);

localparam DEFAULT_BIT_PERIOD = 16'((CLK_FREQ / BAUD_RATE) - 1);

logic [3:0] bit_index;
logic [15:0] counter;  
logic [7:0] buffer;  
logic [15:0] bit_period;

typedef enum logic [1:0] { 
    IDLE,
    START,
    RECEIVE,
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
    end else if (uart_rx_en) begin
        unique case (state)
            IDLE: begin
                uart_rx_valid <= 1'b0; // Garante reset do sinal válido
                if (!uart_rxd) begin
                    counter   <= bit_period;
                    bit_index <= 4'h0;
                    state     <= START;
                end
            end
            START: begin
                if (counter > 0) begin
                    counter <= counter - 1'b1;
                end else begin
                    counter <= bit_period;
                    state   <= RECEIVE;
                end
            end
            RECEIVE: begin
                if (counter > 0) begin
                    counter <= counter - 1'b1;
                end else begin
                    counter <= bit_period;
                    buffer[bit_index[2:0]] <= uart_rxd;
                    if (bit_index < 'd7) begin
                        bit_index <= bit_index + 1'b1;
                    end else begin
                        uart_rx_data  <= buffer;
                        uart_rx_valid <= 1'b1;
                        state         <= STOP;
                    end
                end
            end
            STOP: begin
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
