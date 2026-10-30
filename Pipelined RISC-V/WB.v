`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2025 02:43:00 AM
// Design Name: 
// Module Name: WB
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


module WB(
    input clk, rst,
    input [31:0] MEM_WB_ALU_out, MEM_WB_data_mem_read_out, MEM_WB_PC,
    input [4:0] MEM_WB_wr_addr,
    input [2:0] MEM_WB_insn_type,
    input MEM_WB_rwr, MEM_WB_memreg, WB_FIN_CE,
    output [31:0] WB_data_out,
    output reg [31:0] WB_FIN_data_out,
    output reg WB_FIN_rwr,
    output reg [4:0] WB_FIN_wr_addr
    );
    
    assign WB_data_out = (MEM_WB_insn_type == 3'd5 || MEM_WB_insn_type == 3'd6)? {{24'b0},MEM_WB_PC[7:0]} + 4: MEM_WB_memreg ? MEM_WB_data_mem_read_out : MEM_WB_ALU_out;
    
    always @(posedge clk) begin
        if(rst) WB_FIN_data_out <= 0;
        else if(~WB_FIN_CE) WB_FIN_data_out <= WB_FIN_data_out;
        else WB_FIN_data_out <= WB_data_out;    
    end
    
    always @(posedge clk) begin
        if(rst) WB_FIN_rwr <= 0;
        else if(~WB_FIN_CE) WB_FIN_rwr <= WB_FIN_rwr;
        else WB_FIN_rwr <= MEM_WB_rwr;
    end
    
    always @(posedge clk) begin
        if(rst) WB_FIN_wr_addr <= 0;
        else if(~WB_FIN_CE) WB_FIN_wr_addr <= WB_FIN_wr_addr;
        else WB_FIN_wr_addr <= MEM_WB_wr_addr;
    end
endmodule
