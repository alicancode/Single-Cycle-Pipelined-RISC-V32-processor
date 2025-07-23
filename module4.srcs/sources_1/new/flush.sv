`timescale 1ns / 1ps

module flush(
input logic rst         ,
input logic PCsel       ,


output logic flush_reg  

    );
    always_comb begin
        if(rst) begin
            flush_reg = 1'b0;
        end
        else if(PCsel == 1'b1) begin
            flush_reg = 1'b1;
        end
        else begin
            flush_reg<=  1'b0;
        end
    end
endmodule
