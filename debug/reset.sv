module ResetBootSystem #(
    parameter CYCLES = 20
) (
    input logic clk,
    output logic reset_o,
    output logic resetn_o
);

localparam INIT = 2'b00;
localparam RESET_COUNTER = 2'b01;
localparam IDLE = 2'b10;

logic [1:0] state;
logic [5:0] counter;

initial begin
    state   = 2'b01;
    reset_o = 2'b0;
    counter = 6'h00;
end

always_ff @(posedge clk ) begin : RESET_SYSTEM_FSM
    case (state)
        INIT: begin
            reset_o <= 1'b1;
            state <= RESET_COUNTER;
            counter <= 6'h00;
        end

        RESET_COUNTER: begin
            if(reset_o == 1'b0) begin
                state <= INIT;
            end else begin
                if(counter < CYCLES) begin
                    counter <= counter + 1;
                end else if(counter == CYCLES) begin
                    counter <= 0;
                    state <= IDLE;
                end else begin
                    state <= INIT;
                end
            end
        end

        IDLE: begin
            if(counter != 0) begin
                state <= INIT;
            end else begin
                reset_o <= 1'b0;
            end
        end

        default: state <= INIT;
    endcase
end

assign resetn_o = ~reset_o;

endmodule
