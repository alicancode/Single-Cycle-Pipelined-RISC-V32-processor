`timescale 1ns / 1ps

module pc(
    input  logic        clk         ,
    input  logic        rst         ,      
    input  logic [31:0] D           ,   
    output logic [31:0] Q
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 32'h00000000;    
        else
            Q <= D;               
    end
endmodule
