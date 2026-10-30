`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2025 03:00:44 PM
// Design Name: 
// Module Name: processor_top
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


module processor_top(
    input clk,
    input resetn,
    output [15:0] regD
    );
    
    wire regA_L, regB_L, regC_L, regD_L, regE_L, regF_L, regG_L, regH_L;
    wire regA_en, regB_en, regC_en, regD_en, regE_en, regF_en, regG_en, regH_en;
    wire mem_rd_bar, mem_wr_bar;
    wire ireg_L;
    wire MAR_L, MAR_en;
    wire TR1_L, TR2_L;
    wire PC_IS, PC_L; //PC_en_to_addr_bus,
    wire ALU_en;
    wire [1:0] ALU_select;
    wire AD_S; //address select btwn PC and MAR
    wire [4:0] opcode;
    wire [2:0] rd, rs1, rs2;
    wire carry_flag, zero_flag;
   // wire [15:0] regD;
    
    datapath_top datapath_top_inst(
        .clk(clk),
        .resetn(resetn),
        .regA_L(regA_L), .regB_L(regB_L), .regC_L(regC_L), .regD_L(regD_L), .regE_L(regE_L), .regF_L(regF_L), .regG_L(regG_L), .regH_L(regH_L),
        .regA_en(regA_en), .regB_en(regB_en), .regC_en(regC_en), .regD_en(regD_en), .regE_en(regE_en), .regF_en(regF_en), .regG_en(regG_en), .regH_en(regH_en),
        .mem_rd_bar(mem_rd_bar), .mem_wr_bar(mem_wr_bar),
        .ireg_L(ireg_L), 
        .MAR_L(MAR_L), .MAR_en(MAR_en),
        .TR1_L(TR1_L), .TR2_L(TR2_L),
        .PC_IS(PC_IS), .PC_L(PC_L), //PC_en_to_addr_bus,
        .ALU_en(ALU_en), 
        .ALU_select(ALU_select),
        .AD_S(AD_S), //address select btwn PC and MAR
        .opcode(opcode),
        .rd(rd), .rs1(rs1), .rs2(rs2),
        .carry_flag(carry_flag), .zero_flag(zero_flag),
        .regD_out(regD)//, .regA_out(regA)
    );
    
    controller controller_inst(
        .clk(clk),
        .resetn(resetn),
        .opcode(opcode),
        .rd(rd), .rs1(rs1), .rs2(rs2),
        .carry_flag(carry_flag), .zero_flag(zero_flag),
        .regA_L(regA_L), .regB_L(regB_L), .regC_L(regC_L), .regD_L(regD_L), .regE_L(regE_L), .regF_L(regF_L), .regG_L(regG_L), .regH_L(regH_L),
        .regA_en(regA_en), .regB_en(regB_en), .regC_en(regC_en), .regD_en(regD_en), .regE_en(regE_en), .regF_en(regF_en), .regG_en(regG_en), .regH_en(regH_en),
        .mem_rd_bar(mem_rd_bar), .mem_wr_bar(mem_wr_bar),
        .ireg_L(ireg_L), 
        .MAR_L(MAR_L), .MAR_en(MAR_en),
        .TR1_L(TR1_L), .TR2_L(TR2_L),
        .PC_IS(PC_IS), .PC_L(PC_L), //PC_en_to_addr_bus,
        .ALU_en(ALU_en), 
        .ALU_select(ALU_select),
        .AD_S(AD_S) //address select btwn PC and MAR
    );
    
endmodule
