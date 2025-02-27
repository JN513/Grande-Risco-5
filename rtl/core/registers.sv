module Registers (
    input  logic clk,
    input  logic regWrite,
    input  logic [4:0] readRegister1,
    input  logic [4:0] readRegister2,
    input  logic [4:0] writeRegister,
    input  logic [31:0] writeData,
    output logic [31:0] readData1,
    output logic [31:0] readData2
);

logic [31:0] registers[0:31];

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
logic [31:0] register1 = registers[1];
logic [31:0] register2 = registers[2];
logic [31:0] register3 = registers[3];
logic [31:0] register4 = registers[4];
logic [31:0] register5 = registers[5];
logic [31:0] register6 = registers[6];
logic [31:0] register7 = registers[7];
logic [31:0] register8 = registers[8];
logic [31:0] register9 = registers[9];
logic [31:0] register10 = registers[10];
logic [31:0] register11 = registers[11];
logic [31:0] register12 = registers[12];
logic [31:0] register13 = registers[13];
logic [31:0] register14 = registers[14];
logic [31:0] register15 = registers[15];
logic [31:0] register16 = registers[16];
logic [31:0] register17 = registers[17];
logic [31:0] register18 = registers[18];
logic [31:0] register19 = registers[19];
logic [31:0] register20 = registers[20];
logic [31:0] register21 = registers[21];
logic [31:0] register22 = registers[22];
logic [31:0] register23 = registers[23];
logic [31:0] register24 = registers[24];
logic [31:0] register25 = registers[25];
logic [31:0] register26 = registers[26];
logic [31:0] register27 = registers[27];
logic [31:0] register28 = registers[28];
logic [31:0] register29 = registers[29];
logic [31:0] register30 = registers[30];
logic [31:0] register31 = registers[31];

`endif

endmodule
