`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2025 09:38:20 PM
// Design Name: 
// Module Name: Forwarding_Unit
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


module Forwarding_Unit(
    input EX_MEM_rwr, MEM_WB_rwr, WB_FIN_rwr,
    input [4:0] EX_MEM_wr_addr, MEM_WB_wr_addr, WB_FIN_wr_addr,
    input [4:0] ID_EX_rs1_addr, ID_EX_rs2_addr,
    output reg [1:0] FA, FB 
    );
    
    always @(*) begin
        if((EX_MEM_rwr) && (|EX_MEM_wr_addr) && (EX_MEM_wr_addr == ID_EX_rs1_addr))
            FA = 2'b11;
        else if ((MEM_WB_rwr) && (|MEM_WB_wr_addr) && (MEM_WB_wr_addr == ID_EX_rs1_addr))
            FA = 2'b10;
        else if ((WB_FIN_rwr) && (|WB_FIN_wr_addr) && (WB_FIN_wr_addr == ID_EX_rs1_addr))
            FA = 2'b01;
        else
            FA = 2'b00;
    end
    
    always @(*) begin
        if((EX_MEM_rwr) && (|EX_MEM_wr_addr) && (EX_MEM_wr_addr == ID_EX_rs2_addr))
            FB = 2'b11;
        else if ((MEM_WB_rwr) && (|MEM_WB_wr_addr) && (MEM_WB_wr_addr == ID_EX_rs2_addr))
            FB = 2'b10;
        else if ((WB_FIN_rwr) && (|WB_FIN_wr_addr) && (WB_FIN_wr_addr == ID_EX_rs2_addr))
            FB = 2'b01;
        else
            FB = 2'b00;
    end
    
    
    
    
endmodule
