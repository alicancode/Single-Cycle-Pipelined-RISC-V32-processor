`timescale 1ns / 1ps


module immgen(
input logic [31:0]instr,
input logic [2:0] immsel,
output logic [31:0] imm
    );
    always_comb begin
    case(immsel)
    3'b000: begin//I type
            imm = {{20{instr[31]}}, instr[31:20]};
    end
    3'b001: begin//s type
        imm = {{20{instr[31]}}, instr[31:25],instr[11:7]};
    end
    3'b010: begin//j type
        imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
        end
    3'b011: begin//branch
        imm = {{19{instr[31]}}, instr[31],instr[7], instr[30:25], instr[11:8], 1'b0};
        end
    3'b100: begin//u type
        imm = { instr[31:12],12'b0};
        end
    default: imm = 32'b0;
    endcase
    end
endmodule
