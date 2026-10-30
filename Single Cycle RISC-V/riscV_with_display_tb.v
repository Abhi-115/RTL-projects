`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 02:47:47 AM
// Design Name: 
// Module Name: riscV_with_display_tb
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


module riscV_with_display_tb();

    reg clk;
    reg rstn;
    //wire [15:0] regD;//, regA;
    wire [6:0] LED_display;
    wire [3:0] anode;
    
    
    riscV_with_display RISC_proc_LED(.clk(clk), .rstn(rstn), .LED_display(LED_display), .anode(anode));
    always #7.75 clk = ~clk;
    
    initial begin
        clk = 0;
        rstn = 0;
        #150 rstn = 1;
        
      
    end

endmodule
