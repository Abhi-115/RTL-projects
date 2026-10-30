`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2025 02:59:28 AM
// Design Name: 
// Module Name: riscV_top_tb
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


module riscV_top_tb();

    reg clk;
    reg rstn;
    wire [31:0] reg10, reg11;
    
    riscV_top RV_uut(
        .clk(clk),
        .rstn(rstn),
        .x10(reg10), .x11(reg11)
    );
    always #7.75 clk = ~clk;
    
    initial begin
        clk = 0;
        rstn = 0;
        #150 rstn = 1; 
    end
endmodule
