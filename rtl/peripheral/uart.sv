module UART #(
    parameter CLK_FREQ     = 25000000,
    parameter BIT_RATE     = 115200,
    parameter PAYLOAD_BITS = 8,
    parameter BUFFER_SIZE  = 32
) (
    input  logic clk,
    input  logic rst_n,

    input  logic rxd,
    output logic txd,

    input  logic        cyc_i,      // Indica uma transação ativa
    input  logic        stb_i,      // Indica uma solicitação ativa
    input  logic        we_i,       // 1 = Write, 0 = Read

    input  logic [31:0] addr_i,     // Endereço
    input  logic [31:0] data_i,     // Dados de entrada (para escrita)
    output logic [31:0] data_o,     // Dados de saída (para leitura)
    
    output logic        ack_o       // Confirmação da transação (agora assíncrona)
);

typedef enum logic [4:0] { 
    IDLE,
    READ,
    READ_WAIT,
    READ_RX_FIFO_EMPTY,
    READ_RX_FIFO_FULL,
    READ_TX_FIFO_EMPTY,
    READ_TX_FIFO_FULL,
    WRITE,
    RX_STATE,
    SET_BIT_PERIOD,
    FINISH,
    WAIT
} uart_state_t;

uart_state_t state;

// Write address_i:
// address_i[3:2] = 00 -> UART_TX
// address_i[3:2] = 01 -> SET RX STATE (0 - disable, 1 - enable)
// address_i[3:2] = 10 -> SET BIT PERIOD
// Read address_i:
// address_i[4:2] = 000 -> Read UART_RX
// address_i[4:2] = 001 -> Read RX FIFO EMPTY
// address_i[4:2] = 010 -> Read RX FIFO FULL
// address_i[4:2] = 011 -> Read TX FIFO EMPTY
// address_i[4:2] = 100 -> Read TX FIFO FULL


logic uart_rx_fifo_read;
logic uart_rx_fifo_write;
logic uart_tx_fifo_read;
logic uart_tx_fifo_write;

logic uart_rx_enable;

logic [7:0] uart_rx_fifo_data_in;
logic [7:0] uart_tx_fifo_data_in;
logic [7:0] uart_rx_fifo_data_out;
logic [7:0] uart_tx_fifo_data_out;

logic uart_rx_fifo_empty;
logic uart_tx_fifo_empty;
logic uart_rx_fifo_full;
logic uart_tx_fifo_full;

logic set_bit_period;
logic [15:0] bit_period;

always_ff @(posedge clk) begin : UART_FSM
    uart_rx_fifo_read  <= 1'b0;
    uart_tx_fifo_write <= 1'b0;
    ack_o              <= 1'b0;
    uart_rx_enable     <= 1'b0;
    set_bit_period     <= 1'b0;

    if (!rst_n) begin
        state      <= IDLE;
        bit_period <= 16'((CLK_FREQ / BIT_RATE) - 1'b1);
    end else begin
        unique case (state)
            IDLE: begin
                if(stb_i && cyc_i) begin
                    if (we_i) begin
                        unique case (addr_i[3:2])
                            2'b00: state   <= WRITE;
                            2'b01: state   <= RX_STATE;
                            2'b10: state   <= SET_BIT_PERIOD;
                            default: state <= WRITE;
                        endcase
                    end else begin
                        unique case (addr_i[4:2])
                            3'b000: state  <= READ;
                            3'b001: state  <= READ_RX_FIFO_EMPTY;
                            3'b010: state  <= READ_RX_FIFO_FULL;
                            3'b011: state  <= READ_TX_FIFO_EMPTY;
                            3'b100: state  <= READ_TX_FIFO_FULL;
                            default: state <= READ;
                        endcase
                    end
                end
            end
            READ: begin
                if(!uart_rx_fifo_empty) begin
                    uart_rx_fifo_read <= 1'b1;
                    state             <= READ_WAIT;
                end
            end
            READ_WAIT: begin
                data_o <= {24'h0, uart_rx_fifo_data_out};
                state  <= FINISH;
            end
            READ_RX_FIFO_EMPTY: begin
                data_o <= {31'h0, uart_rx_fifo_empty};
                state  <= FINISH;
            end
            READ_RX_FIFO_FULL: begin
                data_o <= {31'h0, uart_rx_fifo_full};
                state  <= FINISH;
            end
            READ_TX_FIFO_EMPTY: begin
                data_o <= {31'h0, uart_tx_fifo_empty};
                state  <= FINISH;
            end
            READ_TX_FIFO_FULL: begin
                data_o <= {31'h0, uart_tx_fifo_full};
                state <= FINISH;
            end
            WRITE: begin
                if(!uart_tx_fifo_full) begin
                    uart_tx_fifo_data_in <= data_i[7:0];
                    uart_tx_fifo_write   <= 1'b1;
                end
                state <= FINISH;
            end
            RX_STATE: begin
                uart_rx_enable <= data_i[0];
                state          <= FINISH;
            end
            SET_BIT_PERIOD: begin
                bit_period     <= data_i[15:0];
                set_bit_period <= 1'b1;
                state          <= FINISH;
            end
            FINISH: begin
                ack_o <= 1'b1;
                state <= WAIT;
            end
            WAIT: begin
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

logic uart_rx_valid;
logic [7:0] uart_rx_data;

always_ff @(posedge clk) begin : UART_RX_READ_TO_FIFO
    uart_rx_fifo_write <= 1'b0;

    if(!uart_rx_fifo_full && uart_rx_valid) begin
        uart_rx_fifo_data_in <= uart_rx_data;
        uart_rx_fifo_write   <= 1'b1;
    end
end

logic uart_tx_en, uart_tx_busy;
logic [7:0] uart_tx_data;
typedef enum logic [1:0] { 
    TX_FIFO_IDLE,
    TX_FIFO_READ_FIFO,
    TX_FIFO_WRITE_TX,
    TX_FIFO_WAIT
} tx_read_fifo_state_t;

tx_read_fifo_state_t tx_read_fifo_state;

always_ff @(posedge clk) begin : UART_TX_READ_FROM_FIFO
    uart_tx_en        <= 1'b0;
    uart_tx_fifo_read <= 1'b0;

    unique case (tx_read_fifo_state)
        TX_FIFO_IDLE: begin
            if(!uart_tx_fifo_empty && !uart_tx_busy) begin
                tx_read_fifo_state <= TX_FIFO_READ_FIFO;
                uart_tx_fifo_read  <= 1'b1;
            end
        end
        TX_FIFO_READ_FIFO: begin
            tx_read_fifo_state <= TX_FIFO_WRITE_TX;
        end
        TX_FIFO_WRITE_TX: begin
            uart_tx_data       <= uart_tx_fifo_data_out;
            uart_tx_en         <= 1'b1;
            tx_read_fifo_state <= TX_FIFO_WAIT;
        end
        TX_FIFO_WAIT: begin
            tx_read_fifo_state <= TX_FIFO_IDLE;
        end
        default: tx_read_fifo_state <= TX_FIFO_IDLE;
    endcase
end

FIFO #(
    .DEPTH      (BUFFER_SIZE),
    .WIDTH      (PAYLOAD_BITS)
) tx_fifo (
    .clk          (clk),
    .rst_n        (rst_n),

    .wr_en_i      (uart_tx_fifo_write),
    .rd_en_i      (uart_tx_fifo_read),

    .write_data_i (uart_tx_fifo_data_in),
    .full_o       (uart_tx_fifo_full),
    .empty_o      (uart_tx_fifo_empty),
    .read_data_o  (uart_tx_fifo_data_out)
);

FIFO #(
    .DEPTH        (BUFFER_SIZE),
    .WIDTH        (PAYLOAD_BITS)
) rx_fifo (
    .clk          (clk),
    .rst_n        (rst_n),

    .wr_en_i      (uart_rx_fifo_write),
    .rd_en_i      (uart_rx_fifo_read),

    .write_data_i (uart_rx_fifo_data_in),
    .full_o       (uart_rx_fifo_full),
    .empty_o      (uart_rx_fifo_empty),
    .read_data_o  (uart_rx_fifo_data_out)
);

UART_TX #(
    .BAUD_RATE  (BIT_RATE),
    .CLK_FREQ   (CLK_FREQ)
) uart_tx (
    .clk             (clk),
    .rst_n           (rst_n),

    .wr_bit_period_i (set_bit_period),
    .bit_period_i    (bit_period),

    .uart_tx_en      (uart_tx_en),
    .uart_tx_data    (uart_tx_data),
    .uart_txd        (txd),
    .uart_tx_busy    (uart_tx_busy)
);

UART_RX #(
    .BAUD_RATE       (BIT_RATE),
    .CLK_FREQ        (CLK_FREQ)
) uart_rx (
    .clk             (clk),
    .rst_n           (rst_n),

    .wr_bit_period_i (set_bit_period),
    .bit_period_i    (bit_period),

    .uart_rxd        (rxd),
    .uart_rx_en      (uart_rx_enable),
    .uart_rx_valid   (uart_rx_valid),
    .uart_rx_data    (uart_rx_data),
    .uart_rx_parity_error ()
);

endmodule
