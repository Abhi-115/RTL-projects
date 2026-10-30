`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2025 06:00:08 PM
// Design Name: 
// Module Name: tb_cisc_processor
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


module tb_proc_with_display();

    reg clk;
    reg resetn;
    //wire [15:0] regD;//, regA;
    wire [6:0] LED_display;
    wire [3:0] anode;
    
    
    processor_with_display_top CISC_proc_LED(.clk(clk), .resetn(resetn), .LED_display(LED_display), .anode(anode));
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        resetn = 0;
        #100 resetn = 1;
        
      
    end
endmodule
