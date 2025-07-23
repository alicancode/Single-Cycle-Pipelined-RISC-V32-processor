`timescale 1ns / 1ps


module pipe_regIFID(
    input logic  [31:0] PC          ,
    input logic  [31:0] instr       ,
    input logic         IFIDwrite   ,
    input logic         flush_reg   ,
    
    input logic         clk         ,
    input logic         rst         ,
    
    output logic [31:0] PC_ID,
    output logic [31:0] instr_ID
    );
    
    always_ff@(posedge clk) begin
    if(rst || flush_reg) begin
        PC_ID       <= 32'b0        ;
        instr_ID    <= 32'b0        ;
    end
    else begin
        if(IFIDwrite) begin
            PC_ID       <= PC       ;
            instr_ID    <= instr    ;
        end
        else begin
            PC_ID       <= PC_ID    ;
            instr_ID    <= instr_ID ;
        end    
    end
    end
endmodule

module pipe_regIDEX(
input logic clk                 ,
input logic rst                 ,
input logic flush_reg           ,

input  logic [31:0] PC_ID       ,
input  logic [31:0] rs1_ID      ,
input  logic [31:0] rs2_ID      ,
input  logic [31:0] imm_ID      ,
input  logic [31:0] instr_ID    ,
input  logic        Bsel        ,
input  logic        Asel        ,
input  logic        BrUn        ,
input  logic [3:0]  ALUsel      ,
input  logic [2:0]  func3       ,
//input  logic        PCsel       ,
input  logic        RegWEn      ,
input  logic [1:0]  WBsel       ,
input logic         MemRW       ,
input logic         MemRead     ,

output logic [31:0] PC_EX       ,
output logic [31:0] rs1_EX      ,
output logic [31:0] rs2_EX      ,
output logic [31:0] imm_EX      ,
output logic [31:0] instr_EX    ,
output logic        Bsel_EX     ,
output logic        Asel_EX     ,
output logic        BrUn_EX     ,
output logic [3:0]  ALUsel_EX   ,
output logic [2:0]  func3_EX    ,
//output logic        PCsel_EX    ,
output logic        RegWEn_EX   ,
output logic [1:0]  WBsel_EX    ,
output logic        MemRW_EX    ,
output logic        MemRead_EX  
);
always@(posedge clk) begin
    if(rst || flush_reg) begin
       PC_EX        <= 32'b0    ;
       rs1_EX       <= 32'b0    ;
       rs2_EX       <= 32'b0    ;
       imm_EX       <= 32'b0    ;
       instr_EX     <= 32'b0    ;
       Bsel_EX      <= 1'b0     ;
       Asel_EX      <= 1'b0     ;
       BrUn_EX      <= 1'b0     ; 
       ALUsel_EX    <= 4'b0000  ;
       func3_EX     <= 3'b0     ;
//       PCsel_EX     <= 1'b0     ;
       RegWEn_EX    <= 1'b0     ;
       WBsel_EX     <= 2'b0     ;
       MemRW_EX     <= 1'b0     ;
       MemRead_EX   <= 1'b0     ;

    end
    else begin
        PC_EX       <= PC_ID    ;
        rs1_EX      <= rs1_ID   ;
        rs2_EX      <= rs2_ID   ;
        imm_EX      <= imm_ID   ;
        instr_EX    <= instr_ID ;
        Bsel_EX     <= Bsel     ;
        Asel_EX     <= Asel     ;
        BrUn_EX     <= BrUn     ;
        ALUsel_EX   <= ALUsel   ;
        func3_EX    <= func3    ;
//        PCsel_EX    <= PCsel    ;
        RegWEn_EX   <= RegWEn   ;
        WBsel_EX    <= WBsel    ;
        MemRW_EX    <= MemRW    ;
        MemRead_EX  <= MemRead  ;

    end
end
endmodule

module pipe_regEXMEM(
input logic clk,
input logic rst,

input  logic [31:0] PC_EX       ,
input  logic [31:0] alu_EX      ,
input  logic [31:0] rs2_EX      ,
input  logic [31:0] instr_EX    ,
input  logic        MemRW_EX    ,
input  logic [1:0]  WBsel_EX    ,
input logic         RegWEn_EX   ,
input logic  [2:0]  func3_EX    ,
input logic         PCsel_EX    ,

output logic [31:0] PC_MEM      ,
output logic [31:0] alu_MEM     ,
output logic [31:0] rs2_MEM     ,
output logic [31:0] instr_MEM   ,
output logic        MemRW_MEM   ,
output logic [1:0]  WBsel_MEM   ,
output logic        RegWEn_MEM  ,
output logic [2:0]  func3_MEM   ,
output logic        PCsel_MEM   
);
always_ff@(posedge clk) begin
    if(rst) begin
        PC_MEM      <= 32'b0    ;
        alu_MEM     <= 32'b0    ;
        rs2_MEM     <= 32'b0    ;
        instr_MEM   <= 32'b0    ;
        MemRW_MEM   <= 1'b0     ;
        WBsel_MEM   <= 2'b0     ;
        RegWEn_MEM  <= 1'b0     ;
        func3_MEM   <= 3'b0     ;
        PCsel_MEM   <= 1'b0     ;  
    end
    else begin
        PC_MEM      <= PC_EX    ;
        alu_MEM     <= alu_EX   ;
        rs2_MEM     <= rs2_EX   ;
        instr_MEM   <= instr_EX ;
        MemRW_MEM   <= MemRW_EX ;
        WBsel_MEM   <= WBsel_EX ;
        RegWEn_MEM  <= RegWEn_EX;
        func3_MEM   <= func3_EX ;
        PCsel_MEM   <= PCsel_EX ;
    end
end
endmodule

module pipe_regMEMWB(
input logic        clk,
input logic        rst,
input logic [31:0] PC_MEM       ,
input logic [31:0] ALU_MEM      ,
input logic [31:0] DMEM         ,
input logic [31:0] instr_MEM    ,
input logic        RegWEn_MEM   ,
input logic [1:0]  WBsel_MEM    ,
input logic        PCsel_MEM    ,

output logic [31:0] PC_WB       ,
output logic [31:0] ALU_WB      ,
output logic [31:0] MEM_WB      ,
output logic [31:0] instr_WB    ,
output logic        RegWEn_WB   ,
output logic [1:0]  WBsel_WB    ,
output logic        PCsel_WB 
);

always_ff@(posedge clk) begin
    if(rst) begin
        PC_WB       <= 32'b0    ;
        ALU_WB      <= 32'b0    ;
        MEM_WB      <= 32'b0    ;
        instr_WB    <= 32'b0    ;
        RegWEn_WB   <= 1'b0     ;
        WBsel_WB    <= 2'b0     ;
        PCsel_WB    <= 1'b0     ;
        end
    else begin
        PC_WB       <= PC_MEM   ;
        ALU_WB      <= ALU_MEM  ;
        MEM_WB      <= DMEM     ;
        instr_WB    <= instr_MEM;
        RegWEn_WB   <= RegWEn_MEM;
        WBsel_WB    <= WBsel_MEM;
        PCsel_WB    <= PCsel_MEM;
    end    
end
endmodule
