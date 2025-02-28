module mdu_tb ();

logic clk, reset, start;
logic done;

logic [2:0] operation;
logic [31:0] MDU_in_X, MDU_in_Y;
logic [31:0] MDU_out;

always #1 clk = ~clk;

initial begin
    $dumpfile("build/mdu_tb.vcd");
    $dumpvars;

    clk = 0;
    reset = 0;
    start = 0;
    operation = 3'b000;
    MDU_in_X = 32'h5;
    MDU_in_Y = 32'h3;

    #2

    reset = 1;

    #2

    reset = 0;

    #2

    start = 1;

    #2

    start = 0;

    #16

    MDU_in_X = 32'h8F4;
    MDU_in_Y = 32'h357;

    #2

    start = 1;

    #2

    start = 0;

    #26 

    MDU_in_Y = 32'h0;
    MDU_in_X = 32'hFFFFFFFF;

    #2

    start = 1;

    #2

    start = 0;

    #26

    MDU_in_X = -32'h1;
    MDU_in_Y = 32'h1;

    #2

    start = 1;

    #2

    start = 0;

    #26

    MDU_in_X = -32'h60;
    MDU_in_Y = 32'h1FFFFFFC;

    #2

    start = 1;

    #2

    start = 0;

    #26

    MDU_in_X = -32'h60;
    MDU_in_Y = 32'h1FFFFFFC;
    operation = 3'b010;

    #2

    start = 1;

    #2

    start = 0;

    #26

    MDU_in_X = 32'h1;
    MDU_in_Y = -32'h1;
    operation = 3'b001;

    #2

    start = 1;

    #2

    start = 0;

    #26

    MDU_in_X = 32'd15;
    MDU_in_Y = 32'd3;
    operation = 3'b100;

    #2

    start = 1;

    #2

    start = 0;

    #72

    MDU_in_X = 32'd15;
    MDU_in_Y = 32'd4;
    operation = 3'b101;

    #2

    start = 1;

    #2

    start = 0;

    #72

    $finish;
end

MDU U1(
    .clk(clk),
    .reset(reset),
    .start(start),
    .operation(operation),
    .MDU_in_X(MDU_in_X),
    .MDU_in_Y(MDU_in_Y),
    .MDU_out(MDU_out),
    .done(done)
);

endmodule