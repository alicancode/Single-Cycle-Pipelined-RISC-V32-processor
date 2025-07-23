`timescale 1ns / 1ps


module tb_branch_comp;
logic [31:0] A;
logic [31:0] B;
logic BrUn, Eq, Lt;
branch_comp b1(.A(A), .B(B), .BrUn(BrUn), .Eq(Eq), .Lt(Lt));

initial begin
//equality check
A = 32'hDEADBEEF;
B = 32'hDEADBEEF;
BrUn  =1'b0;
#50
//signed fail
A = 32'h0000BEEF;
B = 32'hDEADBEEF;
BrUn  =1'b0;
#50
//signed pass
A = 32'hDEADBEEF;
B = 32'h0000BEEF;
BrUn  =1'b0;
//unsigned pass
A = 32'h0000BEEF;
B = 32'hDEADBEEF;
BrUn  =1'b1;
#50
//unsigned fail
A = 32'hFFFFBEEF;
B = 32'hDEADBEEF;
BrUn  =1'b1;
$finish;
end
endmodule
