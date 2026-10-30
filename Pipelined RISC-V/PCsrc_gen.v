`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2025 01:02:53 PM
// Design Name: 
// Module Name: PCsrc_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PCsrc_gen(
    input [2:0] insn_type, func3,
    input zero,
    output reg [1:0] PCsrc
    );
    
    always @(*) begin
        if(insn_type == 3'd5) PCsrc = 2'b01; //j-type
        else if(insn_type == 3'd6) PCsrc = 2'b10; //jalr
        else if(insn_type == 3'd4) begin
            case(func3)
                3'b0: PCsrc = (zero == 1); // beq
                3'b1: PCsrc = (zero == 0); // bne
                3'd4: PCsrc = (zero == 0); // blt
                3'd5: PCsrc = (zero == 1); // bge
                3'd6: PCsrc = (zero == 0); // bltu
                3'd7: PCsrc = (zero == 1); // bgeu
                default: PCsrc = 2'b00;
            endcase
        end
        else PCsrc = 2'b00;
    end
    
    
endmodule
