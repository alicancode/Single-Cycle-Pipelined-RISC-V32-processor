`timescale 1ns / 1ps


module tb_alu;

logic [31:0] a;
logic [31:0] b;
logic [3:0] alusel;
logic [31:0] out;

alu u1(.a(a), .b(b),.alusel(alusel),.out(out));

initial begin

$display("%b, %b, %b : %b", a, b, alusel, out);
a = 32'hDEADBEEF;
b = 32'h21524110;
alusel = 4'b0000;
#10000;
a = 32'hDEADBEEF;
b = 32'h21524110;
alusel = 4'b1000;
#10000;
a = 32'hDEADBEEF;
b = 32'h00000004;
alusel = 4'b0001;
#10000;
a = 32'hDEADBEEF;
b = 32'hFFFFFFFF;
alusel = 4'b0010;
#10000;
a = 32'h00000001;
b = 32'h00000000;
alusel = 4'b0010;
#10000;
a = 32'hDEADBEEF;
b = 32'hDEADBEEF;
alusel = 4'b0100;
#10000;
a = 32'hDEADBEEF;
b = 32'h00000000;
alusel = 4'b0100;
#10000;
a = 32'hDEADBEEF;
b = 32'h00000004;
alusel = 4'b0101;
#100000;
a = 32'hDEADBEEF;
b = 32'h00000004;
alusel = 4'b1101;
#10000;
a = 32'hDEADBEEF;
b = 32'h10101010;
alusel = 4'b0110;
#10000;
a = 32'hDEADBEEF;
b = 32'hF0F0F0F0;
alusel = 4'b0110;
#10000;
a = 32'hDEADBEEF;
b = 32'hF0F0F0F0;
alusel = 4'b0111;
#10000;
$stop;
$finish;
end

endmodule
