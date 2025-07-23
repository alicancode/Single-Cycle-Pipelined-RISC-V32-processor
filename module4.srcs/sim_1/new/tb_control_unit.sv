`timescale 1ns / 1ps

module tb_control_unit;

  logic func7;
  logic [2:0] func3;
  logic [4:0] opcode;
  logic BrEq;
  logic BrLT;

  logic PCsel;
  logic [2:0] Immsel;
  logic BrUn;
  logic Asel;
  logic Bsel;
  logic [3:0] ALUsel;
  logic MemRW;
  logic RegWEn;
  logic [1:0] WBsel;

  control_unit dut (
    .func7(func7),
    .func3(func3),
    .opcode(opcode),
    .BrEq(BrEq),
    .BrLT(BrLT),
    .PCsel(PCsel),
    .Immsel(Immsel),
    .BrUn(BrUn),
    .Asel(Asel),
    .Bsel(Bsel),
    .ALUsel(ALUsel),
    .MemRW(MemRW),
    .RegWEn(RegWEn),
    .WBsel(WBsel)
  );

  initial begin
    $display("Time | opcode func3 func7 | PCsel Immsel BrUn Asel Bsel ALUsel MemRW RegWEn WBsel");
    $display("--------------------------------------------------------------------------");

    // R-type (ADD)
    opcode = 5'b01100; func3 = 3'b000; func7 = 1'b0; BrEq = 0; BrLT = 0;
    #1 $display("%4t |  %b   %b    %b  |   %b     %b    %b    %b    %b    %b     %b      %b     %b",
      $time, opcode, func3, func7, PCsel, Immsel, BrUn, Asel, Bsel, ALUsel, MemRW, RegWEn, WBsel);

    // I-type (ADDI)
    opcode = 5'b00100; func3 = 3'b000; func7 = 1'bx;
    #1 $display("%4t |  %b   %b    %b  |   %b     %b    %b    %b    %b    %b     %b      %b     %b",
      $time, opcode, func3, func7, PCsel, Immsel, BrUn, Asel, Bsel, ALUsel, MemRW, RegWEn, WBsel);

    // Load
    opcode = 5'b00000; func3 = 3'b010;
    #1 $display("%4t |  %b   %b    %b  |   %b     %b    %b    %b    %b    %b     %b      %b     %b",
      $time, opcode, func3, func7, PCsel, Immsel, BrUn, Asel, Bsel, ALUsel, MemRW, RegWEn, WBsel);

    // Store
    opcode = 5'b01001; func3 = 3'b010;
    #1 $display("%4t |  %b   %b    %b  |   %b     %b    %b    %b    %b    %b     %b      %b     %b",
      $time, opcode, func3, func7, PCsel, Immsel, BrUn, Asel, Bsel, ALUsel, MemRW, RegWEn, WBsel);

    // Branch - BEQ
    opcode = 5'b11000; func3 = 3'b000; BrEq = 1; BrLT = 0;
    #1 $display("%4t |  %b   %b    %b  |   %b     %b    %b    %b    %b    %b     %b      %b     %b",
      $time, opcode, func3, func7, PCsel, Immsel, BrUn, Asel, Bsel, ALUsel, MemRW, RegWEn, WBsel);

    // Branch - BLT
    opcode = 5'b11000; func3 = 3'b100; BrEq = 0; BrLT = 1;
    #1 $display("%4t |  %b   %b    %b  |   %b     %b    %b    %b    %b    %b     %b      %b     %b",
      $time, opcode, func3, func7, PCsel, Immsel, BrUn, Asel, Bsel, ALUsel, MemRW, RegWEn, WBsel);

    // JALR
    opcode = 5'b11001;
    #1 $display("%4t |  %b   %b    %b  |   %b     %b    %b    %b    %b    %b     %b      %b     %b",
      $time, opcode, func3, func7, PCsel, Immsel, BrUn, Asel, Bsel, ALUsel, MemRW, RegWEn, WBsel);

    // JAL
    opcode = 5'b11011;
    #1 $display("%4t |  %b   %b    %b  |   %b     %b    %b    %b    %b    %b     %b      %b     %b",
      $time, opcode, func3, func7, PCsel, Immsel, BrUn, Asel, Bsel, ALUsel, MemRW, RegWEn, WBsel);

    // U-type (LUI)
    opcode = 5'b01101;
    #1 $display("%4t |  %b   %b    %b  |   %b     %b    %b    %b    %b    %b     %b      %b     %b",
      $time, opcode, func3, func7, PCsel, Immsel, BrUn, Asel, Bsel, ALUsel, MemRW, RegWEn, WBsel);

    // Done
    $finish;
  end

endmodule
