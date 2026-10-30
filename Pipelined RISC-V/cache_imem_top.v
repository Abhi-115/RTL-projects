`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2025 05:36:41 AM
// Design Name: 
// Module Name: cache_imem_top
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


module cache_imem_top(
    input clk, rst,
    input [31:0] insn_addr,
    output hit_miss_bar,
    output [31:0] insn
    );
    
    wire main_imem_en, cache_en;
    
    cache_imem cache_mem_uut(
        .clk(clk),// .rst(rst),
        .addr(insn_addr),
        .cache_en(cache_en), .main_imem_en(main_imem_en),
        .insn(insn)
    );
    
    cache_controller cache_controller_uut(
        .clk(clk), .rst(rst),
        .addr(insn_addr),
        .cache_en(cache_en), .main_imem_en(main_imem_en),
        .hit_miss_bar(hit_miss_bar)   
    );
endmodule
