`timescale 1ns / 1ps

module dmem(
    input logic [31:0] addr,
    input logic [31:0] dataW,
    input logic MemRW,
    input logic clk,
    input logic [2:0] func3,
    output logic [31:0] dataR
);
    logic [31:0] memory [0:31];
    logic [4:0] offset;
    logic [31:0] mask;
    logic [31:0] DATA;
    logic [31:0] Wdata;
    logic [31:0] address;

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            memory[i] = 32'b0;
    end

    assign offset = addr[1:0] * 8; 

    always_comb begin
        dataR = 32'b0;
        address = addr & 32'hFFFFFFFC; 
        mask = 32'b0;
        Wdata = 32'b0;
        DATA = 32'b0;

        case (func3)
            3'b000: begin 
                mask = 32'hFF << offset;
                DATA = (memory[addr >> 2] & mask) >> offset;
                dataR = {{24{DATA[7]}}, DATA[7:0]};
                Wdata = dataW[7:0] << offset;
            end
            3'b001: begin 
                mask = 32'hFFFF << offset;
                DATA = (memory[addr >> 2] & mask) >> offset;
                dataR = {{16{DATA[15]}}, DATA[15:0]};
                Wdata = dataW[15:0] << offset;
            end
            3'b010: begin 
                dataR = memory[addr >> 2];
                Wdata = dataW;
			     mask = 32'b0;
            end
            3'b100: begin 
                mask = 32'hFF << offset;
                DATA = (memory[addr >> 2] & mask) >> offset;
                dataR = {24'b0, DATA[7:0]};
            end
            3'b101: begin 
                mask = 32'hFFFF << offset;
                DATA = (memory[addr >> 2] & mask) >> offset;
                dataR = {16'b0, DATA[15:0]};
            end
            default: begin
                dataR = 32'b0;
					 mask = 32'b0;
					 dataR = 32'b0;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (MemRW)
            memory[address >> 2] <= (memory[address >> 2] & ~mask) | Wdata;
    end
endmodule
