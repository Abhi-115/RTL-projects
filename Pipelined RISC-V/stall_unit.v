`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 03:32:47 AM
// Design Name: 
// Module Name: stall_unit
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


module stall_unit(
    input ID_EX_dmr, IF_hit_miss_bar,
    input [1:0] EX_PCsrc,
    input [4:0] ID_EX_wr_addr,
    input [4:0] ID_rs1_addr, ID_rs2_addr, 
    output ID_disc, IF_ID_CE, PC_CE, insert_nop,
    output ID_EX_CE, EX_MEM_CE, MEM_WB_CE, WB_FIN_CE
    );
    
    wire stall = (ID_EX_dmr & (|ID_EX_wr_addr) & ((ID_EX_wr_addr == ID_rs1_addr) | (ID_EX_wr_addr == ID_rs2_addr))); 
    assign ID_disc = stall | insert_nop;
    assign PC_CE = IF_ID_CE; 
    assign IF_ID_CE = ~stall & IF_hit_miss_bar;
    assign insert_nop = (|EX_PCsrc);
    
    assign ID_EX_CE = IF_hit_miss_bar;
    assign EX_MEM_CE = IF_hit_miss_bar;
    assign MEM_WB_CE = IF_hit_miss_bar;
    assign WB_FIN_CE = IF_hit_miss_bar;
    
    
endmodule
