`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2025 01:30:21 AM
// Design Name: 
// Module Name: datapath_top
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


module datapath_top(
    input clk,
    input resetn,
    input regA_L, regB_L, regC_L, regD_L, regE_L, regF_L, regG_L, regH_L,
    input regA_en, regB_en, regC_en, regD_en, regE_en, regF_en, regG_en, regH_en,
    input mem_rd_bar, mem_wr_bar,
    input ireg_L, 
    input MAR_L, MAR_en,
    input TR1_L, TR2_L,
    input PC_IS, PC_L, //PC_en_to_addr_bus,
    input ALU_en, 
    input [1:0] ALU_select,
    input AD_S, //address select btwn PC and MAR
    output [4:0] opcode,
    output [2:0] rd, rs1, rs2,
    output carry_flag, zero_flag,
    output [15:0] regD_out//, regA_out
    );
    
    reg [15:0] data_bus, data_bus_reg;
    wire [15:0] TR1_data_out, TR2_data_out;
    wire [15:0] insn;
    wire [5:0] MAR_addr_bus_out;
    wire [4:0] MAR_data_bus_out;
    wire [5:0] PC_addr_bus_out;
    wire [15:0] ALU_data_bus_out;
    wire [15:0] regA_out, regB_out, regC_out,/* regD_out,*/ regE_out, regF_out, regG_out, regH_out;
    wire [5:0] addr;
    wire [10:0] data_bus_enable;
    wire [15:0] mem_out_data_bus;
    
    cpureg regA(.clk(clk), .resetn(resetn), .reg_latch(regA_L), .data_in(data_bus), .data_out(regA_out));
    cpureg regB(.clk(clk), .resetn(resetn), .reg_latch(regB_L), .data_in(data_bus), .data_out(regB_out));
    cpureg regC(.clk(clk), .resetn(resetn), .reg_latch(regC_L), .data_in(data_bus), .data_out(regC_out));
    cpureg regD(.clk(clk), .resetn(resetn), .reg_latch(regD_L), .data_in(data_bus), .data_out(regD_out));
    cpureg regE(.clk(clk), .resetn(resetn), .reg_latch(regE_L), .data_in(data_bus), .data_out(regE_out));
    cpureg regF(.clk(clk), .resetn(resetn), .reg_latch(regF_L), .data_in(data_bus), .data_out(regF_out));
    cpureg regG(.clk(clk), .resetn(resetn), .reg_latch(regG_L), .data_in(data_bus), .data_out(regG_out));
    cpureg regH(.clk(clk), .resetn(resetn), .reg_latch(regH_L), .data_in(data_bus), .data_out(regH_out));
    
//    insn_reg ireg();
    cpureg ireg(.clk(clk), .resetn(resetn), .reg_latch(ireg_L), .data_in(data_bus), .data_out(insn));    

    idmem mem64x16(.clk(clk), /*.resetn(resetn), .rd_bar(mem_rd_bar),*/ .wr_bar(mem_wr_bar), .addr(addr), .data_in(data_bus), .data_out(mem_out_data_bus));
    
    mem_addr_reg MAR(.clk(clk), .resetn(resetn), .mar_latch(MAR_L), .mem_addr(data_bus[4:0]), .mem_addr_to_addr_bus(MAR_addr_bus_out), .mem_addr_to_data_bus(MAR_data_bus_out));
    
    prog_counter PC(.clk(clk), .resetn(resetn), .pc_is(PC_IS), .pc_latch(PC_L), /*.pc_en(PC_en_to_addr_bus),*/ .pc_addr_in(data_bus[4:0]), .pc_addr_out(PC_addr_bus_out));
    
    cpureg ALU_TR1(.clk(clk), .resetn(resetn), .reg_latch(TR1_L), .data_in(data_bus), .data_out(TR1_data_out));
    cpureg ALU_TR2(.clk(clk), .resetn(resetn), .reg_latch(TR2_L), .data_in(data_bus), .data_out(TR2_data_out));
    
    ALU alu_inst(/*.clk(clk), .resetn(resetn),*/ .alu_sel(ALU_select), .tr_1_data(TR1_data_out), .tr_2_data(TR2_data_out), .alu_out(ALU_data_bus_out), .carry_flag(carry_flag), .zero_flag(zero_flag));
        
    assign data_bus_enable = {regA_en, regB_en, regC_en, regD_en, regE_en, regF_en, regG_en, regH_en, MAR_en, ALU_en, ~mem_rd_bar};
    always @(*) begin
        case(data_bus_enable)
            11'b10000000000: data_bus = regA_out;
            11'b01000000000: data_bus = regB_out;
            11'b00100000000: data_bus = regC_out;
            11'b00010000000: data_bus = regD_out;            
            11'b00001000000: data_bus = regE_out;
            11'b00000100000: data_bus = regF_out;
            11'b00000010000: data_bus = regG_out;
            11'b00000001000: data_bus = regH_out;
            11'b00000000100: data_bus = {11'b0,MAR_data_bus_out};
            11'b00000000010: data_bus = ALU_data_bus_out;        
            11'b00000000001: data_bus = mem_out_data_bus;
            default: data_bus = data_bus_reg;
        endcase
    end
    always @(posedge clk) begin
        if(~resetn) data_bus_reg <= 16'b0;
        else data_bus_reg <= data_bus;    
    end
    
    assign addr = AD_S ? PC_addr_bus_out : MAR_addr_bus_out;
    
    assign opcode = insn[15:11];
    assign rd = insn[10:8];
    assign rs2 = insn[7:5];
    assign rs1 = insn[4:2];
    
endmodule
