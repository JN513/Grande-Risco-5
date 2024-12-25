module IR_Decompression ( // Convert compressed instruction to decompressed instruction
    input wire clk,
    input wire [15:0] compressed_instruction,
    output reg [31:0] decompressed_instruction
);

// Compressed instruction is terminated by 2'b00, 2'b01 or 2'b10


endmodule