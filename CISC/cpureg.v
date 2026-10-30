`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2025 11:23:16 AM
// Design Name: 
// Module Name: cpureg
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


module cpureg(
    input clk,
    input resetn,
    input reg_latch,
//    input reg_en,
    input [15:0] data_in,
    output [15:0] data_out
//    inout [15:0] data
    );
    
    reg [15:0] data_q;
    
    always @(posedge clk) begin
        if(~resetn) data_q <= 16'd0;
        else if(reg_latch) data_q <= data_in; 
    end
    
    assign data_out = data_q;
//    assign data = reg_en? data_q: 16'bz;
    
endmodule
