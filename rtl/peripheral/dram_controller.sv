`include "config.vh"

`ifdef DRAM_ENABLE
module DRAM_Controller #(
    parameter SYS_CLK_FREQ  = 50_000_000,
    parameter USER_CLK_FREQ = 100_000_000,
    parameter WORD_SIZE     = 256
) (
    input  logic sys_clk_i, // Sys clk  - 050_000_000
    input  logic clk_i,     // User clk - 100_000_000
    input  logic rst_n_i,
    
    // Wishbone Interface
    input  logic        cyc_i,          // Wishbone cycle indicator
    input  logic        stb_i,          // Wishbone strobe (request)
    input  logic        we_i,           // Write enable

    input  logic [31:0] addr_i,         // Address input
    input  logic [WORD_SIZE - 1:0] data_i,         // Data input (for write)
    output logic [WORD_SIZE - 1:0] data_o,         // Data output (for read)
    output logic        ack_o,           // Acknowledge output

    // DRAM interface
    inout  logic [31:0] ddr3_dq,
    inout  logic [3:0]  ddr3_dqs_n,
    inout  logic [3:0]  ddr3_dqs_p,
    output logic [14:0] ddr3_addr,
    output logic [2:0]  ddr3_ba,
    output logic        ddr3_ras_n,
    output logic        ddr3_cas_n,
    output logic        ddr3_we_n,
    output logic        ddr3_reset_n,
    output logic [0:0]  ddr3_ck_p,
    output logic [0:0]  ddr3_ck_n,
    output logic [0:0]  ddr3_cke,
    output logic [0:0]  ddr3_cs_n,
    output logic [3:0]  ddr3_dm,
    output logic [0:0]  ddr3_odt,

);
    localparam CMD_WRITE      = 3'b000;
    localparam CMD_READ       = 3'b001;
    localparam ADDR_INCREMENT = 'd32;
    localparam ADDR_MAX       = 'h40000000;

    logic ddr3_clk, ddr3_ref_clk;

    clk_wiz_0 clk_wiz_0_inst (
        .clk_out1 (ddr3_clk),
        .clk_out2 (ddr3_ref_clk),
        .resetn   (rst_n_i),
        .locked   (),
        .clk_in1  (sys_clk_i)
    );

    logic [28:0]  app_addr;
    logic [2:0]   app_cmd;
    logic         app_en;
    logic [WORD_SIZE - 1:0] app_wdf_data;
    logic         app_wdf_end;
    logic         app_wdf_wren;
    logic [WORD_SIZE - 1:0] app_rd_data;
    logic         app_rd_data_end;
    logic         app_rd_data_valid;
    logic         app_rdy;
    logic         app_wdf_rdy;


    logic calib_done;
    logic [3:0] state_reg, next_state;
    logic [15:0] counter;

    localparam STATE_IDLE  = 0;
    localparam STATE_WRITE = 1;
    localparam STATE_READ  = 2;
    localparam STATE_WAIT  = 3;
    localparam STATE_ACK   = 4;

    // Address conversion: 32-bit word addr -> 29-bit burst addr (byte address >> log2(word_bytes))
    assign app_addr = addr_i[31:3]; // assume 8-byte aligned access if WORD_SIZE=64, 5 bits if 256

    assign app_wdf_data = data_i;
    assign app_wdf_end  = 1'b1;
    assign app_cmd      = (state_reg == STATE_READ) ? CMD_READ : CMD_WRITE;
    assign app_en       = ((state_reg == STATE_WRITE || state_reg == STATE_READ) && app_rdy) ? 1'b1 : 1'b0;
    assign app_wdf_wren = (state_reg == STATE_WRITE && app_rdy && app_wdf_rdy);

    assign data_o = app_rd_data;

    // ACK: depois que uma operação termina com sucesso
    assign ack_o = (state_reg == STATE_ACK);

    // FSM de controle
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            state_reg <= STATE_IDLE;
            counter <= 0;
        end else begin
            state_reg <= next_state;
        end
    end

    always_comb begin
        next_state = state_reg;
        case (state_reg)
            STATE_IDLE: begin
                if (calib_done && stb_i && cyc_i) begin
                    if (we_i)
                        next_state = STATE_WRITE;
                    else
                        next_state = STATE_READ;
                end
            end

            STATE_WRITE: begin
                if (app_rdy && app_wdf_rdy)
                    next_state = STATE_ACK;
            end

            STATE_READ: begin
                if (app_rdy)
                    next_state = STATE_WAIT;
            end

            STATE_WAIT: begin
                if (app_rd_data_valid)
                    next_state = STATE_ACK;
            end

            STATE_ACK: begin
                if (!stb_i || !cyc_i)
                    next_state = STATE_IDLE;
            end
        endcase
    end

    mig_7series_0 mig_7series_0_inst (
        // Memory signals
        .ddr3_dq      (ddr3_dq),
        .ddr3_dqs_n   (ddr3_dqs_n),
        .ddr3_dqs_p   (ddr3_dqs_p),
        .ddr3_addr    (ddr3_addr),
        .ddr3_ba      (ddr3_ba),
        .ddr3_ras_n   (ddr3_ras_n),
        .ddr3_cas_n   (ddr3_cas_n),
        .ddr3_we_n    (ddr3_we_n),
        .ddr3_reset_n (ddr3_reset_n),
        .ddr3_ck_p    (ddr3_ck_p),
        .ddr3_ck_n    (ddr3_ck_n),
        .ddr3_cke     (ddr3_cke),

        .ddr3_cs_n    (ddr3_cs_n),
        .ddr3_dm      (ddr3_dm),
        .ddr3_odt     (ddr3_odt),

        // Application signals
        .app_addr          (app_addr),
        .app_cmd           (app_cmd),
        .app_en            (app_en),
        .app_wdf_data      (app_wdf_data),
        .app_wdf_end       (app_wdf_end),
        .app_wdf_mask      (32'd0),
        .app_wdf_wren      (app_wdf_wren),
        .app_rd_data       (app_rd_data),
        .app_rd_data_end   (app_rd_data_end),
        .app_rd_data_valid (app_rd_data_valid),
        .app_rdy           (app_rdy),
        .app_wdf_rdy       (app_wdf_rdy),
        .app_sr_req        ('b0),
        .app_ref_req       ('b0),
        .app_zq_req        ('b0),
        .app_sr_active     (app_sr_active),
        .app_ref_ack       (app_ref_ack),
        .app_zq_ack        (app_zq_ac),

        .ui_clk            (clk_i),
        .ui_clk_sync_rst   (!rst_n_i),

        // Sys signals
        .sys_clk_i           (ddr3_clk),
        .clk_ref_i           (ddr3_ref_clk),
        .init_calib_complete (calib_done),
        .device_temp         (),
        .sys_rst             (rst_n_i)
    );    
    
endmodule
`endif