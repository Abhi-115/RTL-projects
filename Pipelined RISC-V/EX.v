`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2025 11:15:57 PM
// Design Name: 
// Module Name: EX
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


module EX(
    input clk, rst,
    input [31:0] ID_EX_rd_data1, ID_EX_rd_data2,
    input [4:0] ID_EX_wr_addr,
    input [31:0] ID_EX_immediate,
    input [2:0] ID_EX_insn_type,
    input [3:0] ID_EX_ALU_control, 
    input ID_EX_lb, ID_EX_lbu, ID_EX_lh, ID_EX_lhu, ID_EX_lw,
    input ID_EX_sw, ID_EX_sh, ID_EX_sb,
    input [2:0] ID_EX_func3,
    input ID_EX_ALUsrc, ID_EX_memreg, ID_EX_is_unsigned, ID_EX_rwr, ID_EX_dmr, ID_EX_dmw, EX_MEM_CE,
//    input [4:0] ID_EX_rs1_addr, ID_EX_rs2_addr,
    input [31:0] ID_EX_pc,
    input [1:0] FA, FB,
    input [31:0] WB_FIN_data1, WB_data1, EX_MEM_data1,
//    input [31:0] WB_FIN_data2, WB_data2, EX_MEM_data2,
    output reg [31:0] EX_MEM_rd_data2, EX_MEM_ALU_out,
    output reg [4:0] EX_MEM_wr_addr,
//    output reg [31:0] EX_MEM_immediate,
    output reg [2:0] EX_MEM_insn_type,
    output reg EX_MEM_lb, EX_MEM_lbu, EX_MEM_lh, EX_MEM_lhu, EX_MEM_lw,
    output reg EX_MEM_sw, EX_MEM_sh, EX_MEM_sb,
    output reg EX_MEM_memreg, EX_MEM_rwr, EX_MEM_dmr, EX_MEM_dmw, 
//    output reg [4:0] EX_MEM_rs1_addr, EX_MEM_rs2_addr,
    output reg [31:0] /*EX_MEM_branchPC,*/ EX_MEM_PC,
    output [1:0] EX_PCsrc,
    output reg [31:0] EX_branchPC
    );
    
    reg [31:0] EX_ALU_in1, EX_ALU_in2_temp;
    wire [31:0] EX_ALU_in2 , EX_ALU_out;
//    reg [31:0] WB_FIN_data1, WB_data1, EX_MEM_data1;
//    reg [31:0] WB_FIN_data2, WB_data2, EX_MEM_data2;
//    wire [31:0] EX_branchPC;
    
    ALU EX_ALU_uut(.in1(EX_ALU_in1),
                .in2(EX_ALU_in2),
                .ALU_control(ID_EX_ALU_control), 
                .is_unsigned(ID_EX_is_unsigned),
                .out(EX_ALU_out),
                .zero(EX_ALU_zero));
                
    PCsrc_gen EX_PCsrc_gen_uut(.insn_type(ID_EX_insn_type), .func3(ID_EX_func3),
                               .zero(EX_ALU_zero), .PCsrc(EX_PCsrc));
                               
                               
                
    always @(*) begin
        case(FA)
            2'b00: EX_ALU_in1 = ID_EX_rd_data1;
            2'b01: EX_ALU_in1 = WB_FIN_data1;
            2'b10: EX_ALU_in1 = WB_data1;
            2'b11: EX_ALU_in1 = EX_MEM_data1;
        endcase
    end
    
    always @(*) begin
        case(FB)
            2'b00: EX_ALU_in2_temp = ID_EX_rd_data2;
            2'b01: EX_ALU_in2_temp = WB_FIN_data1;
            2'b10: EX_ALU_in2_temp = WB_data1;
            2'b11: EX_ALU_in2_temp = EX_MEM_data1;
        endcase
    end
    
    assign EX_ALU_in2 = ID_EX_ALUsrc ? ID_EX_immediate : EX_ALU_in2_temp;
    
    always @(posedge clk) begin
        if(rst) begin
           EX_MEM_wr_addr <= 0; 
        end
        else if(~EX_MEM_CE) EX_MEM_wr_addr <= EX_MEM_wr_addr;
        else begin
           EX_MEM_wr_addr <= ID_EX_wr_addr;
        end
    end
    
    always @(posedge clk) begin
        if(rst) begin
           EX_MEM_lb <= 0; 
           EX_MEM_lbu <= 0; 
           EX_MEM_lh <= 0; 
           EX_MEM_lhu <= 0;
           EX_MEM_lw <= 0;
        end
        else if(~EX_MEM_CE) begin
           EX_MEM_lb <= EX_MEM_lb; 
           EX_MEM_lbu <= EX_MEM_lbu; 
           EX_MEM_lh <= EX_MEM_lh; 
           EX_MEM_lhu <= EX_MEM_lhu;
           EX_MEM_lw <= EX_MEM_lw;
        end
        else begin
           EX_MEM_lb <= ID_EX_lb; 
           EX_MEM_lbu <= ID_EX_lbu; 
           EX_MEM_lh <= ID_EX_lh; 
           EX_MEM_lhu <= ID_EX_lhu;
           EX_MEM_lw <= ID_EX_lw;
        end
    end
    
    always @(posedge clk) begin
        if(rst) begin
           EX_MEM_sw <= 0;
           EX_MEM_sh <= 0; 
           EX_MEM_sb <= 0; 
        end
        else if(~EX_MEM_CE) begin
           EX_MEM_sw <= EX_MEM_sw;
           EX_MEM_sh <= EX_MEM_sh; 
           EX_MEM_sb <= EX_MEM_sb; 
        end
        else begin
           EX_MEM_sw <= ID_EX_sw;
           EX_MEM_sh <= ID_EX_sh; 
           EX_MEM_sb <= ID_EX_sb; 
        end
    end
    
    always @(posedge clk) begin
        if(rst) begin 
            EX_MEM_rwr <= 0;
            EX_MEM_dmr <= 0;
            EX_MEM_dmw <= 0;
        end
        else if(~EX_MEM_CE) begin
           EX_MEM_rwr <= EX_MEM_rwr;
           EX_MEM_dmr <= EX_MEM_dmr; 
           EX_MEM_dmw <= EX_MEM_dmw; 
        end
        else begin
            EX_MEM_rwr <= ID_EX_rwr;
            EX_MEM_dmr <= ID_EX_dmr;
            EX_MEM_dmw <= ID_EX_dmw;
        end
    end
    
//    always @(posedge clk) begin
//        if(rst) begin
//            EX_MEM_rs1_addr <= 0;
//            EX_MEM_rs2_addr <= 0;
//        end
//        else begin
//            EX_MEM_rs1_addr <= ID_EX_rs1_addr;
//            EX_MEM_rs2_addr <= ID_EX_rs2_addr;
//        end
//    end
    
//    assign EX_branchPC = ((ID_EX_insn_type == 3'd5))? ID_EX_pc + ID_EX_immediate : (ID_EX_insn_type == 3'd6) ? ;
    
    always @(*) begin
        case(ID_EX_insn_type)
            3'd6: EX_branchPC = EX_ALU_in1 + ID_EX_immediate;
            3'd5: EX_branchPC = {{{24'b0},ID_EX_pc[7:0]}} + ID_EX_immediate;
            3'd4: EX_branchPC = {{{24'b0},ID_EX_pc[7:0]}} + ID_EX_immediate;
            default: EX_branchPC = 0;
        endcase
    end
    
    always @(posedge clk) begin
        if(rst) EX_MEM_PC <= 0;
        else if(~EX_MEM_CE) EX_MEM_PC <= EX_MEM_PC;
        else EX_MEM_PC <= ID_EX_pc;
    end
    
//    always @(posedge clk) begin
//        if(rst) EX_MEM_branchPC <= 0;
//        else EX_MEM_branchPC <= EX_branchPC;
//    end
    
    always @(posedge clk) begin
        if(rst) EX_MEM_rd_data2 <= 0;
        else if(~EX_MEM_CE) EX_MEM_rd_data2 <= EX_MEM_rd_data2;
        else EX_MEM_rd_data2 <= EX_ALU_in2_temp;
    end
    
    always @(posedge clk) begin
        if(rst) EX_MEM_memreg <= 0;
        else if(~EX_MEM_CE) EX_MEM_memreg <= EX_MEM_memreg;
        else EX_MEM_memreg <= ID_EX_memreg;
    end
    
    always @(posedge clk) begin
        if(rst) EX_MEM_ALU_out <= 0;
        else if(~EX_MEM_CE) EX_MEM_ALU_out <= EX_MEM_ALU_out;
        else EX_MEM_ALU_out <= EX_ALU_out;
    end
    
    
    always @(posedge clk) begin
        if(rst) EX_MEM_insn_type <= 0;
        else if(~EX_MEM_CE) EX_MEM_insn_type <= EX_MEM_insn_type;
        else EX_MEM_insn_type <= ID_EX_insn_type;
    end
    
endmodule
