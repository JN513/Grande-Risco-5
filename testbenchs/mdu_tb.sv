`timescale 1ns / 1ps

module mdu_tb;
    reg clk;
    reg rst_n;
    reg valid_i;
    reg [2:0] MDU_op_i;
    reg [31:0] MDU_RS1_i;
    reg [31:0] MDU_RS2_i;
    wire ready_o;
    wire [31:0] MDU_RD_o;

    // Instantiate MDU
    MDU uut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_i(valid_i),
        .ready_o(ready_o),
        .MDU_op_i(MDU_op_i),
        .MDU_RS1_i(MDU_RS1_i),
        .MDU_RS2_i(MDU_RS2_i),
        .MDU_RD_o(MDU_RD_o)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("build/mdu_tb.vcd");
        $dumpvars(0, mdu_tb);

        clk = 0;
        rst_n = 0;
        valid_i = 0;
        MDU_op_i = 3'b000;
        MDU_RS1_i = 0;
        MDU_RS2_i = 0;

        // Reset
        #10 rst_n = 1;

        // Test Case 1: Multiplication (MUL)
        #10 valid_i = 1;
        MDU_op_i = 3'b000;
        MDU_RS1_i = 32'd10;
        MDU_RS2_i = 32'd20;
        #10 valid_i = 0;
        wait(ready_o);
        assert(MDU_RD_o == 32'd200) else begin
            $display("Expected: %d, Got: %d", 32'd200, MDU_RD_o);
            $display("Test Case 1 Failed");
            $fatal;
        end;

        // Test Case 2: Multiplication by Zero
        #10 valid_i = 1;
        MDU_RS1_i = 32'd0;
        MDU_RS2_i = 32'd12345;
        #10 valid_i = 0;
        wait(ready_o);
        assert(MDU_RD_o == 0) else begin
            $display("Expected: %d, Got: %d", 0, MDU_RD_o);
            $display("Test Case 2 Failed");
            $fatal;
        end

        // Test Case 3: Multiplication with Negative Numbers
        #10 valid_i = 1;
        MDU_RS1_i = -32'd10;
        MDU_RS2_i = 32'd5;
        #10 valid_i = 0;
        wait(ready_o);
        assert(MDU_RD_o == -50) else begin
            $display("Expected: %d, Got: %d", -50, MDU_RD_o);
            $display("Test Case 3 Failed");
            $fatal;
        end

        // Test Case 4: Multiplication of Two Negative Numbers
        #10 valid_i = 1;
        MDU_RS1_i = -32'd10;
        MDU_RS2_i = -32'd5;
        #10 valid_i = 0;
        wait(ready_o);
        assert(MDU_RD_o == 50) else begin
            $display("Expected: %d, Got: %d", 50, MDU_RD_o);
            $display("Test Case 4 Failed");
            $fatal;
        end

        // Test Case 5: Division (DIV)
        #10 valid_i = 1;
        MDU_op_i = 3'b100;
        MDU_RS1_i = 32'd100;
        MDU_RS2_i = 32'd10;
        #10 valid_i = 0;
        wait(ready_o);
        assert(MDU_RD_o == 10) else begin
            $display("Expected: %d, Got: %d", 10, MDU_RD_o);
            $display("Test Case 5 Failed");
            $fatal;
        end

        // Test Case 6: Division by Zero
        #10 valid_i = 1;
        MDU_RS1_i = 32'd100;
        MDU_RS2_i = 32'd0;
        #10 valid_i = 0;
        wait(ready_o);
        assert(MDU_RD_o == 4294967295) else begin
            $display("Expected: %d, Got: %d", 4294967295, MDU_RD_o);
            $display("Test Case 6 Failed");
            $fatal;
        end

        // Test Case 7: Negative Division
        #10 valid_i = 1;
        MDU_RS1_i = -32'd100;
        MDU_RS2_i = 32'd10;
        #10 valid_i = 0;
        wait(ready_o);
        assert(MDU_RD_o == -10) else begin
            $display("Expected: %d, Got: %d", -10, MDU_RD_o);
            $display("Test Case 7 Failed");
            $fatal;
        end

        // Test Case 8: Negative Division Resulting in Positive Value
        #10 valid_i = 1;
        MDU_RS1_i = -32'd100;
        MDU_RS2_i = -32'd10;
        #10 valid_i = 0;
        wait(ready_o);
        assert(MDU_RD_o == 10) else begin
            $display("Expected: %d, Got: %d", 10, MDU_RD_o);
            $display("Test Case 8 Failed");
            $fatal;
        end

        // Test Case 9: Remainder (REM)
        #10 valid_i = 1;
        MDU_op_i = 3'b110;
        MDU_RS1_i = 32'd10;
        MDU_RS2_i = 32'd3;
        #10 valid_i = 0;
        wait(ready_o);
        assert(MDU_RD_o == 1) else begin
            $display("Expected: %d, Got: %d", 1, MDU_RD_o);
            $display("Test Case 9 Failed");
            $fatal;
        end

        // Test Case 10: Remainder when Dividend is Zero
        #10 valid_i = 1;
        MDU_RS1_i = 32'd0;
        MDU_RS2_i = 32'd5;
        #10 valid_i = 0;
        wait(ready_o);
        assert(MDU_RD_o == 0) else begin
            $display("Expected: %d, Got: %d", 0, MDU_RD_o);
            $display("Test Case 10 Failed");
            $fatal;
        end

        $display("All test cases passed!");
        $finish;
    end
endmodule
