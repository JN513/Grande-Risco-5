module Grande_Risco5 #(
    parameter BOOT_ADDRESS           = 32'h00000000,
    parameter I_CACHE_SIZE           = 32'd32,
    parameter D_CACHE_SIZE           = 32'd32,
    parameter DATA_WIDTH             = 32'd32,
    parameter ADDR_WIDTH             = 32'd32,
    parameter BRANCH_PREDICTION_SIZE = 512,
    parameter CLK_FREQ               = 100_000_000
) (
    // Control signal
    input logic clk,
    input logic rst_n,
    input logic halt,

    // Memory BUS
    output logic cyc_o,
    output logic stb_o,
    output logic we_o,

    output logic [31:0] addr_o,
    output logic [31:0] data_o,

    input  logic ack_i,
    input  logic [31:0] data_i,

    input logic interruption
);

logic instruction_response, flush_bus, instruction_request;
logic [31:0] instruction_address, instruction_data;

logic data_read_request, data_write_request, data_memory_response;
logic [31:0] data_read_data, data_write_data, data_address;

// Bus logic for data memory and peripheral
logic d_cache_read_request, d_cache_write_request, d_cache_response;
logic [31:0] d_cache_read_data;


// Bus logic for memory
logic d_cache_memory_write_request, d_cache_memory_read_request, 
    d_cache_memory_response;

logic i_cache_memory_read_request, i_cache_memory_response;

logic [31:0] d_cache_memory_write_data, d_cache_memory_read_data,
    d_cache_memory_addr;

logic [31:0] i_cache_memory_read_data, i_cache_memory_addr;

logic core_clk;

logic processor_data_we, cache_data_we;
logic processor_cyc, cache_cyc;

logic memory_response;
logic memory_read_request;
logic memory_write_request;

logic [31:0] memory_read_data;
logic [31:0] memory_write_data;
logic [31:0] memory_addr;

assign core_clk = clk & ~halt;

Core #(
    .BOOT_ADDRESS            (BOOT_ADDRESS),
    .BRANCH_PREDICTION_SIZE  (BRANCH_PREDICTION_SIZE),
    .CLK_FREQ                (CLK_FREQ)
) Core1 (
    .clk                     (core_clk),
    .rst_n                   (rst_n),

    .instr_flush_o           (flush_bus),
    .instr_req_o             (instruction_request),
    .instr_rsp_i             (instruction_response),
    .instr_addr_o            (instruction_address),
    .instr_data_i            (instruction_data),

    .data_mem_rsp_i          (data_memory_response),
    .data_addr_o             (data_address),
    .data_mem_rd_o           (data_read_request),
    .data_mem_wr_o           (data_write_request),
    .data_write_o            (data_write_data),
    .data_read_i             (data_read_data),

    .external_interruption_i (interruption)
);

ICache #(
    .CACHE_SIZE(I_CACHE_SIZE)
) ICache(
    .clk   (clk),
    .rst_n (rst_n),

    .flush_bus     (flush_bus),
    .read_request  (instruction_request),
    .addr          (instruction_address),
    .read_response (instruction_response),
    .read_data     (instruction_data),

    .memory_read_request  (i_cache_memory_read_request),
    .memory_read_response (i_cache_memory_response),
    .memory_addr          (i_cache_memory_addr),
    .memory_read_data     (i_cache_memory_read_data)
);

DCache #(
    .CACHE_SIZE(D_CACHE_SIZE)
) DCache(
    .clk   (clk),
    .rst_n (rst_n),

    .write_request (d_cache_write_request),
    .read_request  (d_cache_read_request),
    .addr          (data_address),
    .response      (d_cache_response),
    .read_data     (d_cache_read_data),
    .write_data    (data_write_data),

    .memory_read_request  (d_cache_memory_read_request),
    .memory_write_request (d_cache_memory_write_request),
    .memory_response      (d_cache_memory_response),
    .memory_addr          (d_cache_memory_addr),
    .memory_read_data     (d_cache_memory_read_data),
    .memory_write_data    (d_cache_memory_write_data)
);

Cache_request_Multiplexer #(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
) M1(
    .clk   (clk),
    .rst_n (rst_n),

    .i_cache_address       (i_cache_memory_addr),
    .i_cache_read_data     (i_cache_memory_read_data),
    .i_cache_read_request  (i_cache_memory_read_request),
    .i_cache_response      (i_cache_memory_response),

    .d_cache_address       (d_cache_memory_addr),
    .d_cache_read_data     (d_cache_memory_read_data),
    .d_cache_write_data    (d_cache_memory_write_data),
    .d_cache_read_request  (d_cache_memory_read_request),
    .d_cache_write_request (d_cache_memory_write_request),
    .d_cache_response      (d_cache_memory_response),

    .memory_read_request   (memory_read_request),
    .memory_write_request  (memory_write_request),
    .memory_addr           (memory_addr),
    .memory_write_data     (memory_write_data),
    .memory_response       (memory_response),
    .memory_read_data      (memory_read_data)
);

logic peripheral_access_lock, peripheral_wr_through;

always_ff @( posedge clk ) begin : BUS_LOGIC
    if(!rst_n) begin
        peripheral_access_lock <= 1'b0;
        peripheral_wr_through  <= 1'b0;
    end else begin
        if((data_read_request || data_write_request) && data_address[31] && !ack_i) begin
            peripheral_access_lock <= 1'b1;
            peripheral_wr_through  <= data_write_request;
        end else if(ack_i) begin
            peripheral_access_lock <= 1'b0;
            peripheral_wr_through  <= 1'b0;
        end
    end
end

assign processor_cyc     = (data_read_request | data_write_request | peripheral_access_lock ) & data_address[31];
assign cache_cyc         = memory_read_request | memory_write_request;
assign processor_data_we = data_write_request | peripheral_wr_through;
assign cache_data_we     = memory_write_request;

assign stb_o                 = cyc_o;
assign cyc_o                 = (data_address[31]) ? processor_cyc     : cache_cyc;
assign we_o                  = (data_address[31]) ? processor_data_we : cache_data_we;
assign addr_o                = (processor_cyc) ? data_address      : memory_addr;
assign data_o                = (processor_cyc) ? data_write_data   : memory_write_data;
assign memory_response       = (processor_cyc) ? 1'b0 : ack_i;
assign memory_read_data      = data_i;
assign d_cache_read_request  = (!data_address[31]) ? data_read_request  : 1'b0;
assign d_cache_write_request = (!data_address[31]) ? data_write_request : 1'b0;
assign data_memory_response  = (data_address[31])  ? ack_i  : d_cache_response;
assign data_read_data        = (data_address[31])  ? data_i : d_cache_read_data;



endmodule
