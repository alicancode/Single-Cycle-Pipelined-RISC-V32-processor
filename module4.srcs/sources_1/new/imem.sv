`timescale 1ns / 1ps

module imem(
input logic [31:0] addr,
output logic [31:0] dataR
    );

    logic[31:0] datar;
    logic [31:0] memory[0:15];
    
            initial begin
        $readmemh("imem.mem", memory);
    end
    
    always_comb begin
        dataR = memory[addr[5:2]];
    end

endmodule
