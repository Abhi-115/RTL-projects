`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2025 04:34:22 AM
// Design Name: 
// Module Name: pipeline_RV_with_display
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


module pipeline_RV_with_display(
    input clk,
    input rst,
    output [6:0] LED_display,
    output [3:0] anode
    );
    
    wire [31:0] reg4;//, reg11;
    
    seven_segment_display_controller display(.clock_100Mhz(clk),/*.resetn(rstn), */.displayed_number(reg4[15:0]), .Anode_Activate(anode),.LED_out(LED_display));
    
    Pipelined_RISCV RV_proc_pipeline(
        .clk(clk),
        .rst(rst),
        .x4(reg4)//, .x11(reg11)
    );
    
//    thermo_code tc_uut(.count(reg11), .thermo_cnt(count));
    
endmodule
