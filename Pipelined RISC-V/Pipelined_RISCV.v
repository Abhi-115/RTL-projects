`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2025 01:10:18 AM
// Design Name: 
// Module Name: Pipelined_RISCV
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


module Pipelined_RISCV(
    input clk, rst,
    output [31:0] x4
    );
    /**** IF ****/
    wire [1:0] EX_PCsrc;
    wire [31:0] EX_branchPC;
    wire [31:0] IF_ID_pc, IF_ID_insn;
    wire IF_ID_CE, PC_CE, insert_nop, IF_hit_miss_bar;
    wire ID_EX_CE, EX_MEM_CE, MEM_WB_CE, WB_FIN_CE;
    
    /**** ID ****/
    wire [4:0] MEM_WB_wr_addr;
    wire [31:0] ID_EX_rd_data1, ID_EX_rd_data2;
    wire [4:0] ID_EX_wr_addr;
    wire ID_disc;
    wire [31:0] ID_EX_immediate;
    wire [2:0] ID_EX_insn_type;//, ID_insn_type;
    wire [3:0] ID_EX_ALU_control;
    wire ID_EX_lb, ID_EX_lbu, ID_EX_lh, ID_EX_lhu, ID_EX_lw;
    wire ID_EX_sw, ID_EX_sh, ID_EX_sb;
    wire ID_EX_ALUsrc, ID_EX_memreg, ID_EX_is_unsigned, ID_EX_rwr, ID_EX_dmr, ID_EX_dmw;
    wire [4:0] ID_EX_rs1_addr, ID_EX_rs2_addr;
    wire [2:0] ID_EX_func3;
    wire [7:0] ID_EX_pc;
    wire [4:0] ID_rs1_addr, ID_rs2_addr;
    
    /**** EX ****/
    wire [1:0] FA, FB;
    wire [31:0] EX_MEM_rd_data2, EX_MEM_ALU_out, EX_MEM_PC;
    wire [4:0] EX_MEM_wr_addr;
    wire [2:0] EX_MEM_insn_type;
    wire EX_MEM_lb, EX_MEM_lbu, EX_MEM_lh, EX_MEM_lhu, EX_MEM_lw;
    wire EX_MEM_sw, EX_MEM_sh, EX_MEM_sb;
    wire EX_MEM_memreg, EX_MEM_rwr, EX_MEM_dmr, EX_MEM_dmw;
    
    /**** MEM ****/
    wire [31:0] MEM_WB_ALU_out, MEM_WB_data_mem_read_out, MEM_WB_PC;
    wire [2:0] MEM_WB_insn_type;
    wire MEM_WB_rwr, MEM_WB_memreg;
    
    /**** WB ****/
    wire [31:0] WB_data_out;
    wire [31:0] WB_FIN_data_out;
    wire WB_FIN_rwr;
    wire [4:0] WB_FIN_wr_addr;
    
    IF IF_uut(.clk(clk), .rst(rst),
              .EX_PCsrc(EX_PCsrc),
              .EX_branchPC(EX_branchPC), 
              .IF_ID_pc(IF_ID_pc),
              .IF_ID_insn(IF_ID_insn), .IF_hit_miss_bar(IF_hit_miss_bar),
              .IF_ID_CE(IF_ID_CE), .PC_CE(PC_CE), .insert_nop(insert_nop));
             
    ID ID_uut(.clk(clk), .rst(rst),
              .IF_ID_insn(IF_ID_insn), .ID_EX_CE(ID_EX_CE),
              .IF_ID_pc(IF_ID_pc), .ID_disc(ID_disc),
              .MEM_WB_wr_data(WB_data_out),
              .MEM_WB_wr_addr(MEM_WB_wr_addr),
              .ID_EX_rd_data1(ID_EX_rd_data1), .ID_EX_rd_data2(ID_EX_rd_data2),
              .ID_EX_wr_addr(ID_EX_wr_addr),
              .ID_EX_immediate(ID_EX_immediate),
              .ID_EX_insn_type(ID_EX_insn_type),
              .ID_EX_ALU_control(ID_EX_ALU_control), .ID_EX_lb(ID_EX_lb), .ID_EX_lbu(ID_EX_lbu), .ID_EX_lh(ID_EX_lh), .ID_EX_lhu(ID_EX_lhu), .ID_EX_lw(ID_EX_lw),
              .ID_EX_sw(ID_EX_sw), .ID_EX_sh(ID_EX_sh), .ID_EX_sb(ID_EX_sb),
              .ID_EX_ALUsrc(ID_EX_ALUsrc), .ID_EX_memreg(ID_EX_memreg), .ID_EX_is_unsigned(ID_EX_is_unsigned), .ID_EX_rwr(ID_EX_rwr), .ID_EX_dmr(ID_EX_dmr), .ID_EX_dmw(ID_EX_dmw),
              .ID_EX_rs1_addr(ID_EX_rs1_addr), .ID_EX_rs2_addr(ID_EX_rs2_addr),
              .ID_EX_func3(ID_EX_func3), .MEM_WB_rwr(MEM_WB_rwr),
              .ID_EX_pc(ID_EX_pc), .x4(x4),
              .ID_rs1_addr(ID_rs1_addr),.ID_rs2_addr(ID_rs2_addr));
    
    EX EX_uut(.clk(clk), .rst(rst),
              .ID_EX_rd_data1(ID_EX_rd_data1), .ID_EX_rd_data2(ID_EX_rd_data2),
              .ID_EX_wr_addr(ID_EX_wr_addr),
              .ID_EX_immediate(ID_EX_immediate),
              .ID_EX_insn_type(ID_EX_insn_type),
              .ID_EX_ALU_control(ID_EX_ALU_control), .ID_EX_lb(ID_EX_lb), .ID_EX_lbu(ID_EX_lbu), .ID_EX_lh(ID_EX_lh), .ID_EX_lhu(ID_EX_lhu), .ID_EX_lw(ID_EX_lw),
              .ID_EX_sw(ID_EX_sw), .ID_EX_sh(ID_EX_sh), .ID_EX_sb(ID_EX_sb),
              .ID_EX_func3(ID_EX_func3),
              .ID_EX_ALUsrc(ID_EX_ALUsrc), .ID_EX_memreg(ID_EX_memreg), .ID_EX_is_unsigned(ID_EX_is_unsigned), .ID_EX_rwr(ID_EX_rwr), .ID_EX_dmr(ID_EX_dmr), .ID_EX_dmw(ID_EX_dmw),
//              .ID_EX_rs1_addr(ID_EX_rs1_addr), .ID_EX_rs2_addr(ID_EX_rs2_addr),
              .ID_EX_pc(ID_EX_pc),
              .FA(FA), .FB(FB),
              .WB_FIN_data1(WB_FIN_data_out), .WB_data1(WB_data_out), .EX_MEM_data1(EX_MEM_ALU_out),
              //.WB_FIN_data2(WB_FIN_data_out), .WB_data2(WB_data_out), .EX_MEM_data2(EX_MEM_data2),
              .EX_MEM_rd_data2(EX_MEM_rd_data2), .EX_MEM_ALU_out(EX_MEM_ALU_out),
              .EX_MEM_wr_addr(EX_MEM_wr_addr),
              .EX_MEM_lb(EX_MEM_lb), .EX_MEM_lbu(EX_MEM_lbu), .EX_MEM_lh(EX_MEM_lh), .EX_MEM_lhu(EX_MEM_lhu), .EX_MEM_lw(EX_MEM_lw),
              .EX_MEM_sw(EX_MEM_sw), .EX_MEM_sh(EX_MEM_sh), .EX_MEM_sb(EX_MEM_sb),
              .EX_MEM_memreg(EX_MEM_memreg), .EX_MEM_rwr(EX_MEM_rwr), .EX_MEM_dmr(EX_MEM_dmr), .EX_MEM_dmw(EX_MEM_dmw), 
              .EX_MEM_insn_type(EX_MEM_insn_type), .EX_MEM_CE(EX_MEM_CE),
              .EX_MEM_PC(EX_MEM_PC),
              .EX_PCsrc(EX_PCsrc),
              .EX_branchPC(EX_branchPC)
              );
    
    MEM MEM_uut(.clk(clk), .rst(rst),
                .EX_MEM_rd_data2(EX_MEM_rd_data2), .EX_MEM_ALU_out(EX_MEM_ALU_out),
                .EX_MEM_wr_addr(EX_MEM_wr_addr),
                .EX_MEM_insn_type(EX_MEM_insn_type),
                .EX_MEM_PC(EX_MEM_PC),
                .EX_MEM_lb(EX_MEM_lb), .EX_MEM_lbu(EX_MEM_lbu), .EX_MEM_lh(EX_MEM_lh), .EX_MEM_lhu(EX_MEM_lhu), .EX_MEM_lw(EX_MEM_lw),
                .EX_MEM_sw(EX_MEM_sw), .EX_MEM_sh(EX_MEM_sh), .EX_MEM_sb(EX_MEM_sb),
                .EX_MEM_memreg(EX_MEM_memreg), .EX_MEM_rwr(EX_MEM_rwr), .EX_MEM_dmr(EX_MEM_dmr), .EX_MEM_dmw(EX_MEM_dmw),
                .MEM_WB_ALU_out(MEM_WB_ALU_out), .MEM_WB_data_mem_read_out(MEM_WB_data_mem_read_out),
                .MEM_WB_wr_addr(MEM_WB_wr_addr),
                .MEM_WB_rwr(MEM_WB_rwr), .MEM_WB_memreg(MEM_WB_memreg), .MEM_WB_CE(MEM_WB_CE),
                .MEM_WB_PC(MEM_WB_PC), .MEM_WB_insn_type(MEM_WB_insn_type)
                );
    
    WB WB_uut(.clk(clk), .rst(rst),
              .MEM_WB_ALU_out(MEM_WB_ALU_out), .MEM_WB_data_mem_read_out(MEM_WB_data_mem_read_out),
              .MEM_WB_wr_addr(MEM_WB_wr_addr), 
              .MEM_WB_rwr(MEM_WB_rwr), .MEM_WB_memreg(MEM_WB_memreg),
              .MEM_WB_PC(MEM_WB_PC), .MEM_WB_insn_type(MEM_WB_insn_type),
              .WB_data_out(WB_data_out),
              .WB_FIN_data_out(WB_FIN_data_out),
              .WB_FIN_rwr(WB_FIN_rwr), .WB_FIN_CE(WB_FIN_CE),
              .WB_FIN_wr_addr(WB_FIN_wr_addr)
              );
              
     Forwarding_Unit FU_uut(.EX_MEM_rwr(EX_MEM_rwr), .MEM_WB_rwr(MEM_WB_rwr), .WB_FIN_rwr(WB_FIN_rwr),
                            .EX_MEM_wr_addr(EX_MEM_wr_addr), .MEM_WB_wr_addr(MEM_WB_wr_addr), .WB_FIN_wr_addr(WB_FIN_wr_addr),
                            .ID_EX_rs1_addr(ID_EX_rs1_addr), .ID_EX_rs2_addr(ID_EX_rs2_addr),
                            .FA(FA), .FB(FB)
                            );
                            
     stall_unit SU_uut(.ID_EX_dmr(ID_EX_dmr), .IF_hit_miss_bar(IF_hit_miss_bar),
                       .ID_EX_wr_addr(ID_EX_wr_addr),.EX_PCsrc(EX_PCsrc),
                       .ID_rs1_addr(ID_rs1_addr), .ID_rs2_addr(ID_rs2_addr), //.ID_insn_type(ID_insn_type),
                       .ID_disc(ID_disc), .IF_ID_CE(IF_ID_CE), .PC_CE(PC_CE), .insert_nop(insert_nop),
                       .ID_EX_CE(ID_EX_CE), .EX_MEM_CE(EX_MEM_CE), .MEM_WB_CE(MEM_WB_CE), .WB_FIN_CE(WB_FIN_CE));
    
endmodule
