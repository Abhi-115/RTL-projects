`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2025 06:33:22 PM
// Design Name: 
// Module Name: MEM
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


module MEM(
    input clk, rst,
    input [31:0] EX_MEM_rd_data2, EX_MEM_ALU_out, /*EX_MEM_branchPC,*/ EX_MEM_PC,
    input [4:0] EX_MEM_wr_addr,
    input EX_MEM_lb, EX_MEM_lbu, EX_MEM_lh, EX_MEM_lhu, EX_MEM_lw,
    input EX_MEM_sw, EX_MEM_sh, EX_MEM_sb,
    input EX_MEM_memreg, EX_MEM_rwr,  EX_MEM_dmr, EX_MEM_dmw, MEM_WB_CE,
    input [2:0] EX_MEM_insn_type,
//    input [4:0] EX_MEM_rs1_addr, EX_MEM_rs2_addr,
//    input [31:0] EX_MEM_branchPC,
    output reg [31:0] MEM_WB_ALU_out, 
    output [31:0] MEM_WB_data_mem_read_out,
    output reg [4:0] MEM_WB_wr_addr,
    output reg MEM_WB_rwr, MEM_WB_memreg,
    output reg [31:0] /*MEM_WB_branchPC,*/ MEM_WB_PC,
    output reg [2:0] MEM_WB_insn_type
//    output [4:0] MEM_WB_rs1_addr, MEM_WB_rs2_addr
    );
    
    wire [31:0] MEM_data_mem_read_out;
    
     data_mem MEM_dmem_uut(.mem_addr(EX_MEM_ALU_out[9:0]),
                      .clk(clk),
                      .dmw(EX_MEM_dmw), .dmr(EX_MEM_dmr),
                      .lb(EX_MEM_lb),.lbu(EX_MEM_lbu),.lh(EX_MEM_lh),.lhu(EX_MEM_lhu),.lw(EX_MEM_lw),
                      .sw(EX_MEM_sw),.sh(EX_MEM_sh),.sb(EX_MEM_sb),
                      .mem_write_data_in(EX_MEM_rd_data2),
                      .mem_read_data_out(MEM_data_mem_read_out));

    always @(posedge clk) begin                      
        if(rst) MEM_WB_wr_addr <= 0;
        else if(~MEM_WB_CE) MEM_WB_wr_addr <= MEM_WB_wr_addr;
        else MEM_WB_wr_addr <= EX_MEM_wr_addr;  
    end
    
    always @(posedge clk) begin                      
        if(rst) MEM_WB_rwr <= 0;
        else if(~MEM_WB_CE) MEM_WB_rwr <= MEM_WB_rwr;
        else MEM_WB_rwr <= EX_MEM_rwr;  
    end 
    
    always @(posedge clk) begin                      
        if(rst) MEM_WB_memreg <= 0;
        else if(~MEM_WB_CE) MEM_WB_memreg <= MEM_WB_memreg;
        else MEM_WB_memreg <= EX_MEM_memreg;  
    end 
    
    always @(posedge clk) begin                      
        if(rst) MEM_WB_ALU_out <= 0;
        else if(~MEM_WB_CE) MEM_WB_ALU_out <= MEM_WB_ALU_out;
        else MEM_WB_ALU_out <= EX_MEM_ALU_out;  
    end 
    
//     always @(posedge clk) begin                      
//        if(rst) MEM_WB_data_mem_read_out <= 0;
//        else MEM_WB_data_mem_read_out <= MEM_data_mem_read_out;  
//    end 
    assign MEM_WB_data_mem_read_out = MEM_data_mem_read_out;
    
//    always @(posedge clk) begin
//        if(rst) MEM_WB_branchPC <= 0;
//        else MEM_WB_branchPC <= EX_MEM_branchPC;
//    end
    
    always @(posedge clk) begin
        if(rst) MEM_WB_PC <= 0;
        else if(~MEM_WB_CE) MEM_WB_PC <= MEM_WB_PC;
        else MEM_WB_PC <= EX_MEM_PC;
    end
    
    always @(posedge clk) begin
        if(rst) MEM_WB_insn_type <= 0;
        else if(~MEM_WB_CE) MEM_WB_insn_type <= MEM_WB_insn_type;
        else MEM_WB_insn_type <= EX_MEM_insn_type;
    end
    
endmodule
