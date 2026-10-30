`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2025 01:46:44 AM
// Design Name: 
// Module Name: processor_with_display_top
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


module processor_with_display_top(
    input clk,
    input resetn,
    output [6:0] LED_display,
    output [3:0] anode
    );
    
    wire [15:0] regD;
    
    seven_segment_display_controller display(.clock_100Mhz(clk),.resetn(resetn), .displayed_number(regD), .Anode_Activate(anode),.LED_out(LED_display));
    
    processor_top cisc_proc(
        .clk(clk),
        .resetn(resetn),
        .regD(regD)
    );
    
endmodule
