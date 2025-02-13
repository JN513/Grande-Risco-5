module Registers (
    input wire clk,
    input wire regWrite,
    input wire [4:0] readRegister1,
    input wire [4:0] readRegister2,
    input wire [4:0] writeRegister,
    input wire [31:0] writeData,
    output wire [31:0] readData1,
    output wire [31:0] readData2
);

reg [31:0] registers[0:31];

assign readData1 = (regWrite && (writeRegister == readRegister1) && (|writeRegister))
                   ? writeData
                   : registers[readRegister1];

assign readData2 = (regWrite && (writeRegister == readRegister2) && (|writeRegister))
                   ? writeData
                   : registers[readRegister2];


always @(posedge clk) begin
    if (regWrite) begin
        registers[writeRegister] <= writeData;
    end
    
    registers[0] <= 32'h00000000;
end

`ifdef __ICARUS__
wire [31:0] register1 = registers[1];
wire [31:0] register2 = registers[2];
wire [31:0] register3 = registers[3];
wire [31:0] register4 = registers[4];
wire [31:0] register5 = registers[5];
wire [31:0] register6 = registers[6];
wire [31:0] register7 = registers[7];
wire [31:0] register8 = registers[8];
wire [31:0] register9 = registers[9];
wire [31:0] register10 = registers[10];
wire [31:0] register11 = registers[11];
wire [31:0] register12 = registers[12];
wire [31:0] register13 = registers[13];
wire [31:0] register14 = registers[14];
wire [31:0] register15 = registers[15];
wire [31:0] register16 = registers[16];
wire [31:0] register17 = registers[17];
wire [31:0] register18 = registers[18];
wire [31:0] register19 = registers[19];
wire [31:0] register20 = registers[20];
wire [31:0] register21 = registers[21];
wire [31:0] register22 = registers[22];
wire [31:0] register23 = registers[23];
wire [31:0] register24 = registers[24];
wire [31:0] register25 = registers[25];
wire [31:0] register26 = registers[26];
wire [31:0] register27 = registers[27];
wire [31:0] register28 = registers[28];
wire [31:0] register29 = registers[29];
wire [31:0] register30 = registers[30];
wire [31:0] register31 = registers[31];

`endif

endmodule
