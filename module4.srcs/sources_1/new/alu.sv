`timescale 1ns / 1ps


module alu(
input logic [31:0] a,
input logic [31:0] b,
input logic [3:0] ALUsel,
output logic [31:0] out
    );
    logic ext;
    always_comb begin
    case(ALUsel)
    4'b0000:
    out = a+b;
    4'b1000:
    out = a-b;
    4'b0001:
    out = a<<b;
    4'b0010: begin
    if(a<b)
    out = 32'b1;
    else
    out = 32'b0;
    end
    4'b0011:
    out = $unsigned(a)<$unsigned(b);
    4'b0100:
    out = a^b;
    4'b0101: begin
    out = a >> b;
    end
    4'b1101: begin
    ext = a[31];
    out = a>>>b;
    end
    4'b0110:
    out = a|b;
    4'b0111:
    out = a&b;
    4'b1001:
    out = b;
    default: 
    out=32'b0;
    endcase
    end
endmodule
