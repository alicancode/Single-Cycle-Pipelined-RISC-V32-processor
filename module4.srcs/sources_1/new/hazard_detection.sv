`timescale 1ns / 1ps


module hazard_detection(
    input logic     [4:0]   IDEXrd      ,
    input logic     [4:0]   IFIDr1      ,
    input logic     [4:0]   IFIDr2      ,
    input logic             IDEXmemread ,
    
    output logic            ContWrite   ,
    output logic            PCwrite     ,
    output logic            IFIDwrite   
    );
    always_comb begin
        if ((IDEXmemread) && ((IDEXrd == IFIDr1) || (IDEXrd == IFIDr2))) begin
            PCwrite     =   1'b0        ;
            IFIDwrite   =   1'b0        ;
            ContWrite   =   1'b0        ;
            
        end
        else begin
            ContWrite   =   1'b1        ;
            PCwrite     =   1'b1        ;
            IFIDwrite   =   1'b1        ;        
        end
    end
endmodule
