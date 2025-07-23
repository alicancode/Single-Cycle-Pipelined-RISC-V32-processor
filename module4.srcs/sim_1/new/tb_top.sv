`timescale 1ns / 1ps

module tb_top;

  logic clk, rst;
  top dut(.clk(clk), .rst(rst));

  // Clock generation (50MHz)
  initial begin
    clk = 0;
    forever #10 clk = ~clk;  // 20ns period
  end

  // Reset logic
  initial begin
    rst = 1;
    #25 rst = 0;
  end

  // Display information every positive clock edge
  always_ff @(posedge clk) begin
    if (!rst) begin
      $display("\nT=%0t ns", $time);

      $display("=============================================");
      $display("IF Stage:");
      $display("  PC = %h | instr = %h", dut.Q, dut.dataR);

      $display("ID Stage:");
      $display("  PC_ID   = %h | instr_ID = %h| Bsel = %b | PCwrite: %b | ContWrite: %b Microsoft.QuickAction.WiFi| IFIDwrite: %b | IDEXmemread: %b", dut.Q_ID, dut.dataR_ID, dut.Bsel, dut.PCwrite, dut.ContWrite, dut.IFIDwrite, dut.MemRead_EX);
      $display("  data1 = %h | data2 = %h", dut.data1, dut.data2);
      $display("  rs1 = %0d | rs2 = %0d | IDEXrd = %0d | IFIDr1 = %0d | IFIDr2 = %0d | flush: %b", dut.rs1, dut.rs2, dut.IDEXrd, dut.rs1, dut.rs2, dut.flush_reg);
      $display("  RegWEn = %b | ALUsel = %h | Bsel = %b | WBsel = %b | MemRW = %b | immsel = %d |",
                dut.RegWEn, dut.ALUsel, dut.Bsel, dut.WBsel, dut.MemRW, dut.immsel);

      $display("EX Stage:");
      $display("  PC_EX   = %h | instr_EX = %h, Bsel_EX = %b", dut.Q_EX, dut.dataR_EX, dut.Bsel_EX);
      $display("  a = %h | b = %h | a_fwd = %h | b_fwd = %h | ALU_out = %h | IDEXrd: %h | rs1_EX: %h | rs2_EX: %h | flush: %b", dut.a, dut.b, dut.a_fwd, dut.b_fwd, dut.out, dut.IDEXrd, dut.rs1_EX, dut.rs2_EX, dut.flush_reg);
      $display("  Eq = %b | Lt = %b | BrUn = %b, a_fwd = %h | b_fwd = %h", dut.Eq, dut. Lt, dut.BrUn, dut.a_fwd, dut.b_fwd);
      $display("  RegWEn_EX = %b | ALUsel_EX = %h | Bsel_EX = %b | Asel_EX  =%b |WBsel_EX = %b | MemRW_EX = %b | PCsel_cont = %b | ForwardA: %b | ForwardB: %b | Imm_EX = %h",
                dut.RegWEn_EX, dut.ALUsel_EX, dut.Bsel_EX,dut.Asel_EX,  dut.WBsel_EX, dut.MemRW_EX, dut.PCsel_cont, dut.ForwardA, dut.ForwardB, dut.imm_EX);

      $display("MEM Stage:");
      $display("  PC_MEM   = %h | instr_MEM = %h", dut.Q_MEM, dut.dataR_MEM);
      $display("  ALU_out = %h | dmem_out = %h | func3 = %0d | addr = %h | EXMEMrd =  %d", dut.out_MEM, dut.dout_WB, dut.func3_MEM, dut.out_MEM, dut.EXMEMrd);
      $display("  RegWEn_MEM = %b | WBsel_MEM = %b | MemRW_MEM = %b | PCsel_MEM = %b",
                dut.RegWEn_MEM, dut.WBsel_MEM, dut.MemRW_MEM, dut.PCsel_MEM);

      $display("WB Stage:");
      $display("  PC_WB   = %h | instr_WB = %h", dut.jaddr2_WB, dut.dataR_WB);
      $display("  ALU_WB = %h | dmem_WB = %h | DataW = %h", dut.out_WB, dut.dout_WB, dut.dataW);
      $display("  RegWEn_WB = %b | WBsel_WB = %b | PCsel_WB = %b | MEMWBrd: %d | RegWEn_WB: %b ",
                dut.RegWEn_WB, dut.WBsel_WB, dut.PCsel_WB, dut.MEMWBrd, dut.RegWEn_WB);

      // Show first few registers (0-7 for quick debug)
      $display("Registers:");
      for (int i = 0; i < 8; i++) begin
        $display("  x%-2d = %h", i, dut.uu1.registers[i]);
      end
        $display("memory[0]: %h", dut.uu6.memory[0]);
      $display("=============================================\n");
    end
  end

  // End simulation after fixed time
  initial begin
    #500;
    $finish;
  end

endmodule
