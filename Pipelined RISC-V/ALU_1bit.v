//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2025 02:21:11 AM
// Design Name: 
// Module Name: ALU_1bit
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


module ALU_1bit(
    input a, b,
    input less, cin, 
    input [3:0] ALU_cntrl,  //{an, bn|cin, 2'b{op}}
    output cout,
    output reg result
);
    wire result_adder, a_sel, b_sel;
    
    assign a_sel = ALU_cntrl[3] ? ~a : a;
    assign b_sel = ALU_cntrl[2] ? ~b : b;
    always @(*) begin
        case(ALU_cntrl[1:0])
            2'b00: result = a_sel & b_sel; //AND
            2'b01: result = a_sel | b_sel; //OR
            2'b10: result = result_adder; //ADD
            2'b11: result = less;
            default: result = 1'b0;
        endcase
    end
    
    adder_1bit add_uut(.a(a_sel),.b((b_sel)),.cin(cin),.sum(result_adder),.cout(cout));
    
endmodule

