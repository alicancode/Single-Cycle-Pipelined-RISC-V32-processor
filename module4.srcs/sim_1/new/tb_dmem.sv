`timescale 1ns / 1ps


module tb_dmem;

logic [31:0] addr;
logic[31:0] dataW;
logic MemRW;
logic clk;
logic [2:0] func3;
logic [31:0] dataR;

dmem d1(.addr(addr), .dataW(dataW), .MemRW(MemRW), .clk(clk), .func3(func3), .dataR(dataR));

initial begin
    clk = 0;
    
    forever #10 clk=~clk;
end

initial begin
$monitor("Time: %0t Mem0:%h Mem8:%h Mem9:%h Mem10:%h",$time,d1.memory[0],d1.memory[8],d1.memory[9],d1.memory[10]);
addr = 32'h00000000;dataW = 32'hDEADBEEF;MemRW = 1;func3 = 3'b010;#20;
addr = 32'h00000000;dataW = 32'hDEADBEEF;MemRW = 0;func3 = 3'b010;#20;
addr = 32'h00000024;dataW = 32'hDEADBEEF;MemRW = 1;func3 = 3'b010;#20;
addr = 32'h00000025;dataW = 32'hDEADBEEF;MemRW = 0;func3 = 3'b000;#20;
addr = 32'h00000024;dataW = 32'hDEADBEEF;MemRW = 0;func3 = 3'b001;#20;
addr = 32'h00000028;dataW = 32'hDEADBEEF;MemRW = 1;func3 = 3'b001;#20;
addr = 32'h00000028;dataW = 32'hDEADBEEF;MemRW = 0;func3 = 3'b101;#20;
addr = 32'h00000028;dataW = 32'hDEADBEEF;MemRW = 0;func3 = 3'b100;#20;
addr = 32'h00000028;dataW = 32'hDEADBEEF;MemRW = 1;func3 = 3'b001;#20;
$finish;
end

endmodule
