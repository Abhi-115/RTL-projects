`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IISc
// Engineer: Abhinava De
// 
// Create Date: 09/02/2025 12:00:29 AM
// Design Name: 
// Module Name: idmem
// Project Name: 16-bit CISC Processor Design
// Target Devices: 
// Tool Versions: 
// Description: this module is the 64x16-bit instruction cum data memory requisite for the processor
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module idmem(
    input clk,
//    input resetn,
    input /*rd_bar,*/ wr_bar,
    input [5:0] addr,
    input [15:0] data_in,
    output [15:0] data_out
    );
    
//    reg [15:0] mem[0:63];
//    reg [15:0] data_out_int;
    
//  assign data_out = (~rd_bar && wr_bar) ? data_out_int : 16'bz;
//    assign data_out = data_out_int;  
    dist_mem_gen_0 idmem_64x16 (
      .a(addr),      // input wire [5 : 0] a
      .d(data_in),      // input wire [15 : 0] d
      .clk(clk),  // input wire clk
      .we(~wr_bar),    // input wire we
      .spo(data_out)  // output wire [15 : 0] spo
    );

//    always @(posedge clk) begin
//        if(resetn) data_out_int <= 16'b0;
//        else begin
//            if(~wr_bar) mem[addr] <= data_in;
//            else if(~rd_bar) data_out_int <= mem[addr];
//        end
//    end
    
endmodule
