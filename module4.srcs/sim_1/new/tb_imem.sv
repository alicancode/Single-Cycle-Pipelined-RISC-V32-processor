`timescale 1ns / 1ps

module imem_tb;

    logic [3:0] addr;

    logic [31:0] dataR;

    imem uut (
        .addr(addr),
        .dataR(dataR)
    );

    initial begin
        addr = 0;

        #10;

        repeat (16) begin
            $display("Address: %0d, Data: 0x%08h", uut.addr2, dataR);
            #10;
            addr = addr + 4;
        end

        $display("Test complete.");
        $finish;
    end

endmodule
