`timescale 1ns / 1ps

module regfile_tb;

    // Inputs
    logic clk;
    logic [31:0] dataW;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rsW;
    logic RegWEn;

    // Outputs
    logic [31:0] data1;
    logic [31:0] data2;

    // Instantiate the register file
    regfile uut (
        .clk(clk),
        .dataW(dataW),
        .rs1(rs1),
        .rs2(rs2),
        .rsW(rsW),
        .RegWEn(RegWEn),
        .data1(data1),
        .data2(data2)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 10 ns period

    // Test sequence
    initial begin
        $display("Starting register file test...");
        RegWEn = 0;
        dataW = 0;
        rs1 = 0;
        rs2 = 0;
        rsW = 0;

        // Wait for a few clock cycles
        #10;

        // Write 42 to register 5
        rsW = 5;
        dataW = 32'd42;
        RegWEn = 1;
        #10;  // Wait for posedge clk

        // Write 99 to register 10
        rsW = 10;
        dataW = 32'd99;
        #10;

        // Disable write
        RegWEn = 0;
        rs1 = 5;
        rs2 = 10;
        #1; // Wait a little for combinational read

        // Check values
        $display("Read reg[5] = %0d (Expected: 42)", data1);
        $display("Read reg[10] = %0d (Expected: 99)", data2);

        // Write to x0 (register 0) – should not change if x0 protection is in place
        rsW = 0;
        dataW = 32'd1234;
        RegWEn = 1;
        #10;

        RegWEn = 0;
        rs1 = 0;
        rs2 = 5;
        #1;

        $display("Read reg[0] = %0d (Expected: 0)", data1);
        $display("Read reg[5] = %0d (Expected: 42)", data2);

        $display("Test complete.");
        $finish;
    end

endmodule
