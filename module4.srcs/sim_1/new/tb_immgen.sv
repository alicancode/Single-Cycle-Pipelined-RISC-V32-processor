`timescale 1ns / 1ps

module tb_immgen;

logic [31:0] instr;
logic [31:0] imm;
immgen i1(.instr(instr), .imm(imm));
initial begin
instr = 32'b10101010101001000000001110010011;
#50;
instr = 32'b11111111101001000000001110010011;
#50;
instr = 32'b10101010101001000000001110110011;
#50;
$finish;
end

endmodule
