//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 10:59:10 PM
// Design Name: 
// Module Name: reg_bank
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

module reg_bank(
    input clk, rstn,
    input [4:0] rd_addr1, rd_addr2,
    input rwr,
    input [4:0] wr_addr,
    input [31:0] wr_data,
    output [31:0] rd_data1, rd_data2,
    output [31:0] x10//, x11
    );
    
    reg [31:0] cpureg[31:0];
  
    assign x10 = cpureg[10];
    assign x11 = cpureg[11];
    
    
    integer i;
    
    always @(posedge clk) begin
        if(~rstn) begin
            for(i = 0; i<32; i=i+1) begin
                if(i!=2)
                    cpureg[i] <= 32'd0;
                else cpureg[i] <= 32'd1024;
            end
        end
        else if (rwr) cpureg[wr_addr] <= wr_data; 
    end
    
    assign rd_data1 = cpureg[rd_addr1];
    assign rd_data2 = cpureg[rd_addr2];
    
endmodule
