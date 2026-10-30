`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 12:45:23 AM
// Design Name: 
// Module Name: riscV_with_display
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


module riscV_with_display(
    input clk,
    input rstn,
    output [6:0] LED_display,
    output [3:0] anode
    );
    
    wire [31:0] reg10;//, reg11;
    
    seven_segment_display_controller display(.clock_100Mhz(clk),.resetn(rstn), .displayed_number(reg10[15:0]), .Anode_Activate(anode),.LED_out(LED_display));
    
    riscV_top RV_proc(
        .clk(clk),
        .rstn(rstn),
        .x10(reg10)//, .x11(reg11)
    );
    
//    thermo_code tc_uut(.count(reg11), .thermo_cnt(count));
    
endmodule
