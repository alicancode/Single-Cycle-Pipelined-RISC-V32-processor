`timescale 1ns / 1ps

module control_unit(
    input logic func7,
    input logic [2:0] func3,
    input logic [4:0] opcode,
    
    input logic BrEq,
    input logic BrLT,
    
    //output logic PCsel,
    output logic[2:0] Immsel,
    output logic BrUn,
    output logic Asel,
    output logic Bsel,
    output logic [3:0] ALUsel,
    output logic MemRW,
    output logic RegWEn,
    output logic [1:0]WBsel,
    output logic MemRead
    );
    
        always_comb begin

        case(opcode)
         
            5'b01100: begin//R type arithmetic
               Bsel = 1'b0;
              /// PCsel = 1'b0;
               Asel = 1'b0;
               MemRW  =1'b0;
               RegWEn = 1'b1;
               WBsel = 2'b01;
               BrUn = 1'b0;
               Immsel = 3'b0;
               MemRead = 1'b0;
               case(func3)
                    3'b000: begin//add/sub
                        ALUsel = {func7, func3};
                    end
                    3'b001: begin//shift left logical
                        ALUsel = 4'b0001;
                    end
                    3'b010: begin//set less than
                        ALUsel = 4'b0010;
                    end
                    3'b011: begin//set less than unsigned
                        ALUsel = 4'b0011;
                        end
                    3'b100: begin//xor
                        ALUsel = 4'b0100;
                    end
                    3'b101: begin//srl sra
                        ALUsel = {func7, func3};
                    end
                    3'b110: begin//or
                        ALUsel = 4'b0110;
                    end
                    3'b111: begin//and
                        ALUsel  =4'b0111;
                    end
                    default: ALUsel = 4'b0000;
                endcase 
            end
            5'b00100: begin//I type arithmetic
                Bsel  = 1'b1;
               // PCsel = 1'b0;
                Asel = 1'b0;
                MemRW = 1'b0;
                RegWEn = 1'b1;
                WBsel = 2'b01;
                BrUn = 1'b0;
                Immsel = 3'b000;
                MemRead = 1'b0;
                case(func3)
                    3'b000: begin//add/sub
                        ALUsel = 4'b0000;
                    end
                    3'b001: begin//shift left logical
                        ALUsel = 4'b0001;
                    end
                    3'b010: begin//set less than
                        ALUsel = 4'b0010;
                    end
                    3'b011: begin//set less than unsigned
                        ALUsel = 4'b0011;
                        end
                    3'b100: begin//xor
                        ALUsel = 4'b0100;
                    end
                    3'b101: begin//srl sra
                        ALUsel = {func7, func3};
                    end
                    3'b110: begin//or
                        ALUsel = 4'b0110;
                    end
                    3'b111: begin//and
                        ALUsel  =4'b0111;
                    end
                    default: ALUsel = 4'b0000;
                endcase                
            end
            5'b00000: begin//Load instr
                ALUsel = 4'b0000;
                //PCsel = 1'b0;
                Immsel = 3'b000;
                BrUn = 1'b0;
                Asel = 1'b0;
                Bsel = 1'b1;
                MemRW = 1'b0;
                RegWEn = 1'b1;
                WBsel = 2'b00;
                MemRead = 1'b1;
                    
            end
            5'b01000: begin//store instr
                ALUsel = 4'b0000;
//                PCsel = 1'b0;
                Immsel = 3'b001;
                BrUn = 1'b0;
                Asel = 1'b0;
                Bsel = 1'b1;
                MemRW = 1'b1;
                RegWEn = 1'b0;
                WBsel = 2'b00;
                MemRead = 1'b0;
            end
            5'b11001: begin//J instr
					 //jalr
                     ALUsel = 4'b0000;
					 Immsel = 3'b000;
					 BrUn = 1'b0;
					 Asel = 1'b0;
					 Bsel = 1'b1;
					 MemRW = 1'b0;
					 RegWEn = 1'b1;
					 WBsel =2'b10;
					 MemRead = 1'b0;
					 end
			5'b11011: begin//jal
					 ALUsel = 4'b0000;
					 Immsel = 3'b010;
					 BrUn = 1'b0;
					 Asel = 1'b1;
					 Bsel = 1'b1;
					 MemRW = 1'b0;
					 RegWEn = 1'b1;
					 WBsel =2'b10;
					 MemRead = 1'b0;
					 end
            5'b11000: begin //branch instr
                ALUsel = 4'b0000;
                Immsel = 3'b011;
                Asel = 1'b1;
                Bsel = 1'b1;
                MemRW = 1'b0;
                RegWEn = 1'b0;
                WBsel = 2'b00;
                MemRead = 1'b0;

                    
                case(func3)
                3'b000:begin
                BrUn = 1'b0;
                end
                3'b001:begin
                BrUn = 1'b0;                
                end
                3'b100: begin
                BrUn = 1'b0;
                end
                3'b101:begin
                BrUn = 1'b0;
                end
                3'b110:begin
                BrUn = 1'b1;
                end
                3'b111:begin
                BrUn = 1'b1;
                end
                default:begin
                BrUn = 1'b1;
                end
                endcase
            end
            5'b00101: begin//auipc type instr
					 ALUsel = 4'b0000;
					 //PCsel = 1'b0;
					 Immsel = 3'b100;
					 BrUn = 1'b0;
					 Asel = 1'b1;
					 Bsel = 1'b1;
					 MemRW = 1'b0;
					 RegWEn = 1'b1;
					 WBsel =2'b01;
					 MemRead = 1'b0;

            end
				5'b01101: begin//lui
					ALUsel = 4'b1001;
					//PCsel = 1'b0;
					Immsel = 3'b100;
					BrUn = 1'b0;
					Asel = 1'b1;
					Bsel = 1'b1;
					MemRW = 1'b0;
					RegWEn = 1'b1;
					WBsel=2'b01;
					MemRead = 1'b0;                                                                                                                                                                                                                                                                                                             
				end
				default:begin
                    //PCsel = 1'b0;
                    Immsel = 3'b000;
                    BrUn = 1'b0;
                    Asel = 1'b0;
                    Bsel = 1'b0;
                    ALUsel = 4'b0000;
                    MemRW = 1'b0;
                    RegWEn = 1'b0;
                    WBsel = 2'b00;
                    MemRead = 1'b0;

			     end
        endcase
        end
endmodule

