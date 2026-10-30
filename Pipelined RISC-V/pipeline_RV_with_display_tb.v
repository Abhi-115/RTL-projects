`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2025 04:44:30 AM
// Design Name: 
// Module Name: pipeline_RV_with_display_tb
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


module pipeline_RV_with_display_tb();
    
    reg clk;
    reg rst;
    //wire [15:0] regD;//, regA;
    wire [6:0] LED_display;
    wire [3:0] anode;
    
    
    pipeline_RV_with_display RV_proc_pipeline_LED(.clk(clk), .rst(rst), .LED_display(LED_display), .anode(anode));
    always #8 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        #150 rst = 0;
    end
endmodule
