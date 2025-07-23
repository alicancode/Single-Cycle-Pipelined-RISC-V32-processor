`timescale 1ns / 1ps

module fwd_logic(
    input  logic [4:0] EXMEMrd,
    input  logic [4:0] MEMWBrd,
    input  logic [4:0] IDEXrs1,
    input  logic [4:0] IDEXrs2,
    input  logic       EXMEMregW,
    input  logic       MEMWBregW,

    output logic [1:0] ForwardA,
    output logic [1:0] ForwardB
);

    always_comb begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        if (EXMEMregW && (EXMEMrd != 0) && (EXMEMrd == IDEXrs1)) begin
            ForwardA = 2'b10;
        end else if (MEMWBregW && (MEMWBrd != 0) && (MEMWBrd == IDEXrs1)) begin
            ForwardA = 2'b01;
        end

        if (EXMEMregW && (EXMEMrd != 0) && (EXMEMrd == IDEXrs2)) begin
            ForwardB = 2'b10;
        end else if (MEMWBregW && (MEMWBrd != 0) && (MEMWBrd == IDEXrs2)) begin
            ForwardB = 2'b01;
        end
         
        
    end
endmodule
