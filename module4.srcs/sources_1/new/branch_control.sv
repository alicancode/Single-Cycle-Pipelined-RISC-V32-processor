    `timescale 1ns / 1ps
    
    module branch_control(
    input logic [4:0]opcode,
    input logic [2:0] func3,
    input logic  Lt, Eq,
    
    output logic PCsel
        );
        
        always_comb begin
            if(opcode == 5'b11000) begin
            case(func3)
            3'b000:begin
            PCsel = Eq;
            end
            3'b001:begin
            PCsel = ~Eq;
            end
            3'b100: begin
            PCsel = Lt;
            end
            3'b101:begin
            PCsel =  ~Lt;
            end
            3'b110:begin
            PCsel = Lt;
            end
            3'b111:begin
            PCsel = ~Lt;
            end
            default:begin
            PCsel = 1'b0;
            end
            endcase
            end
            else if((opcode == 5'b11011)||(opcode == 5'b11001))begin
            PCsel = 1'b1;
            end
            else begin
            PCsel = 1'b0;
            end
        end
    endmodule
