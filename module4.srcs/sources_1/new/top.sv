`timescale 1ns / 1ps

module top(
input logic clk,
input logic rst
);

logic Eq, Lt, BrUn, BrUn_EX;
logic [3:0] ALUsel;
logic [3:0] ALUsel_EX;

logic [2:0] immsel;

logic       RegWEn;
logic       RegWEn_EX;
logic       RegWEn_MEM;
logic       RegWEn_WB;

logic       MemRead;
logic       MemRead_EX;

logic [31:0] dataW;

logic [31:0] data1;
logic [31:0] data1_EX;

logic [31:0] data2;
logic [31:0] data2_EX;
logic [31:0] data2_MEM;

//control bit for alu and dmem output to dataW
logic [1:0]WBsel;
logic [1:0] WBsel_EX;
logic [1:0] WBsel_MEM;
logic [1:0] WBsel_WB;

logic Bsel;
logic Bsel_EX;

logic MemRW;
logic MemRW_EX;
logic MemRW_MEM;
logic PCsel;
logic PCsel_cont;
logic PCsel_EX;
logic PCsel_MEM;
logic PCsel_WB;

logic Asel;
logic Asel_EX;

logic [31:0] dout; //dmem read
logic [31:0] dout_WB;

logic [31:0] imm;
logic [31:0] imm_EX;

logic [31:0] jaddr;

logic [31:0] jaddr2;
logic [31:0] jaddr2_WB;

logic [31:0] dataR;
logic [31:0] dataR_ID;
logic [31:0] dataR_EX;
logic [31:0] dataR_MEM;
logic [31:0] dataR_WB;

logic [31:0] a;
logic [31:0] b;

logic [31:0] out;
logic [31:0] out_MEM;
logic [31:0] out_WB;
 
logic [31:0]  D;

logic [31:0]  Q;
logic [31:0]  Q_ID;
logic [31:0] Q_EX;
logic [31:0] Q_MEM;

logic [6:0] opcode; 
logic [4:0] IDEXrd;
logic [4:0] EXMEMrd;
logic [4:0] MEMWBrd;
logic [2:0] func3;
logic [2:0] func3_EX;
logic [2:0] func3_MEM;
logic [4:0] rs1;
logic [4:0] rs1_EX;
logic [4:0] rs2;
logic [4:0] rs2_EX;
logic [6:0] func7;

logic [1:0] ForwardA;
logic [1:0] ForwardB;
logic       ContWrite;
logic       PCwrite;
logic       IFIDwrite;
logic [31:0] a_fwd;
logic [31:0] b_fwd;
logic        flush_reg;
logic [31:0] br1val;
logic [31:0] br2val;

assign jaddr = PCwrite?Q+32'd4:Q;
assign jaddr2 = Q_MEM+32'd4;

assign opcode = dataR_ID[6:0];
assign IDEXrd   = dataR_EX[11:7];
assign MEMWBrd  = dataR_WB[11:7];
assign EXMEMrd  = dataR_MEM[11:7];
assign func3 = dataR_ID[14:12];
assign rs1  = dataR_ID[19:15];
assign rs1_EX = dataR_EX[19:15];
assign rs2 = dataR_ID[24:20];
assign rs2_EX = dataR_EX[24:20];
assign func7 = dataR_ID[31:25];


assign a = Asel_EX?Q_EX:data1_EX;
assign b = Bsel_EX?imm_EX:data2_EX;
assign D = PCsel_cont?out:jaddr;
///
mux41 h3(
.WBsel(ForwardA),
.dout(data1_EX),
.out(dataW),
.D(out_MEM),
.dataW(br1val)
);

mux41 h4(
.WBsel(ForwardB),
.dout(data2_EX),
.out(dataW),
.D(out_MEM),
.dataW(br2val)
);
///
mux41 h1(
.WBsel(ForwardA),
.dout(a),
.out(dataW),
.D(out_MEM),
.dataW(a_fwd)
);

mux41 h2(
.WBsel(ForwardB),
.dout(b),
.out(dataW),
.D(out_MEM),
.dataW(b_fwd)
);
pipe_regIFID p1(
.IFIDwrite(IFIDwrite),
.clk(clk),
.rst(rst), 
.instr(dataR), 
.instr_ID(dataR_ID),
.PC(Q), 
.PC_ID(Q_ID),
.flush_reg(flush_reg)
);

pipe_regIDEX p2(
.clk(clk),
.rst(rst), 
.PC_ID(Q_ID),
.PC_EX(Q_EX),
.rs1_ID(data1),
.rs2_ID(data2),
.rs1_EX(data1_EX),
.rs2_EX(data2_EX),
.imm_ID(imm),
.imm_EX(imm_EX),
.instr_ID(dataR_ID),
.instr_EX(dataR_EX), 
.Asel(Asel),
.Asel_EX(Asel_EX),
.Bsel(Bsel),
.Bsel_EX(Bsel_EX),
.BrUn(BrUn),
.BrUn_EX(BrUn_EX),
.ALUsel(ALUsel),
.ALUsel_EX(ALUsel_EX),
.WBsel(WBsel),
.WBsel_EX(WBsel_EX),
.func3(func3),
.func3_EX(func3_EX),
.RegWEn(ContWrite?RegWEn:1'b0),
.RegWEn_EX(RegWEn_EX),
//.PCsel(PCsel),
//.PCsel_EX(PCsel_EX),
.MemRW(ContWrite?MemRW:1'b0),
.MemRW_EX(MemRW_EX),
.MemRead(ContWrite?MemRead:1'b0),
.MemRead_EX(MemRead_EX),
.flush_reg(flush_reg)
);

pipe_regEXMEM p3(
.clk(clk),
.rst(rst),
.PC_EX(Q_EX),
.PC_MEM(Q_MEM),
.alu_EX(out),
.alu_MEM(out_MEM),
.rs2_EX(data2_EX),
.rs2_MEM(data2_MEM),
.instr_EX(dataR_EX),
.instr_MEM(dataR_MEM),
.MemRW_EX(MemRW_EX),
.MemRW_MEM(MemRW_MEM),
.WBsel_EX(WBsel_EX),
.WBsel_MEM(WBsel_MEM),
.RegWEn_EX(RegWEn_EX),
.RegWEn_MEM(RegWEn_MEM),
.func3_EX(func3_EX),
.func3_MEM(func3_MEM),
.PCsel_EX(PCsel_cont),
.PCsel_MEM(PCsel_MEM)
 );
 
pipe_regMEMWB p4(
.clk(clk),
.rst(rst),
.PC_MEM(jaddr2), 
.PC_WB(jaddr2_WB), 
.ALU_MEM(out_MEM), 
.ALU_WB(out_WB), 
.DMEM(dout), 
.MEM_WB(dout_WB),
.instr_MEM(dataR_MEM), 
.instr_WB(dataR_WB),
.RegWEn_MEM(RegWEn_MEM),
.RegWEn_WB(RegWEn_WB),
.WBsel_MEM(WBsel_MEM),
.WBsel_WB(WBsel_WB),
.PCsel_MEM(PCsel_MEM),
.PCsel_WB(PCsel_WB)
);

regfile uu1(
.clk(clk),
.dataW(dataW), 
.rs1(rs1), 
.rs2(rs2), 
.rsW(MEMWBrd),
.RegWEn(RegWEn_WB), 
.data1(data1), 
.data2(data2)
);

immgen  uu2(
.instr(dataR_ID), 
.imm(imm), 
.immsel(immsel)
);

alu     uu3(
.a(PCsel_cont?a:a_fwd), 
.b(PCsel_cont?b:b_fwd), 
.ALUsel(ALUsel_EX), 
.out(out)
);

imem    uu4(
.addr(Q), 
.dataR(dataR)
);

pc      uu5(
.D(D), 
.Q(Q),
.rst(rst),
.clk(clk)
);

dmem    uu6(
.addr(out_MEM), 
.dataW(data2_MEM), 
.MemRW(MemRW_MEM), 
.clk(clk), 
.func3(func3_MEM), 
.dataR(dout)
);

branch_comp uu7(
.A(br1val), 
.B(br2val), 
.BrUn(BrUn_EX), 
.Eq(Eq), 
.Lt(Lt)
);

control_unit uu8(
.func7(func7[5]), 
.func3(func3), 
.opcode(opcode[6:2]),
.BrEq(Eq),.BrLT(Lt),
//.PCsel(PCsel), 
.Asel(Asel),
.Bsel(Bsel),
.BrUn(BrUn), 
.Immsel(immsel), 
.ALUsel(ALUsel),
.MemRW(MemRW), 
.RegWEn(RegWEn),
.WBsel(WBsel),
.MemRead(MemRead)
);

mux41 uu9(
.WBsel(WBsel_WB), 
.dout(dout_WB), 
.out(out_WB), 
.D(jaddr2_WB), 
.dataW(dataW)
);

fwd_logic uu10(
.EXMEMrd(EXMEMrd),
.MEMWBrd(MEMWBrd),
.IDEXrs1(rs1_EX),
.IDEXrs2(rs2_EX),
.EXMEMregW(RegWEn_MEM),
.MEMWBregW(RegWEn_WB),
.ForwardA(ForwardA),
.ForwardB(ForwardB)
);

hazard_detection uu11(
.IDEXrd(IDEXrd),
.IFIDr1(rs1),
.IFIDr2(rs2),
.IDEXmemread(MemRead_EX),
.ContWrite(ContWrite),
.PCwrite(PCwrite),
.IFIDwrite(IFIDwrite)
);

branch_control uu12(
.opcode(dataR_EX[6:2]),
.func3(func3_EX),
.Eq(Eq),
.Lt(Lt),
.PCsel(PCsel_cont)
);

flush uu13(
.rst(rst),
.PCsel(PCsel_cont),
.flush_reg(flush_reg)
);

endmodule

module mux41(input logic [1:0] WBsel,
input logic [31:0] dout,
input logic [31:0] out,
input logic [31:0] D,

output logic [31:0] dataW
);
always_comb begin
case(WBsel)
    2'b00: dataW  =dout;
    2'b01: dataW  =out;
    2'b10: dataW  =D;
    default: dataW = out;
endcase
end
endmodule
