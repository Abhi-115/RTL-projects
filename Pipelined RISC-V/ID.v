`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2025 06:52:37 PM
// Design Name: 
// Module Name: ID
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


module ID(
    input clk, rst,
    input [31:0] IF_ID_insn,
    input [31:0] IF_ID_pc,
    input ID_disc, MEM_WB_rwr, ID_EX_CE,
    input [31:0] MEM_WB_wr_data,
    input [4:0] MEM_WB_wr_addr,
    output reg [31:0] ID_EX_rd_data1, ID_EX_rd_data2,
    output reg [4:0] ID_EX_wr_addr,
    output reg [31:0] ID_EX_immediate,
    output reg [2:0] ID_EX_insn_type,
    output reg [3:0] ID_EX_ALU_control, 
    output reg ID_EX_lb, ID_EX_lbu, ID_EX_lh, ID_EX_lhu, ID_EX_lw,
    output reg ID_EX_sw, ID_EX_sh, ID_EX_sb,
    output reg ID_EX_ALUsrc, ID_EX_memreg, ID_EX_is_unsigned, ID_EX_rwr, ID_EX_dmr, ID_EX_dmw,
    output reg [4:0] ID_EX_rs1_addr, ID_EX_rs2_addr,
    output reg [2:0] ID_EX_func3,
    output reg [31:0] ID_EX_pc,
    output [4:0] ID_rs1_addr, ID_rs2_addr,
    output [2:0] ID_insn_type,
    output [31:0] x4
    );
    
    wire ID_rwr, ID_dmr, ID_dmw, ID_rwr_stall;
    wire [31:0] ID_rd_data1, ID_rd_data2; 
    wire [2:0] ID_func3;
    wire [31:0] ID_immediate;
    wire [3:0] ID_ALU_control;
    wire ID_lb, ID_lbu, ID_lh, ID_lhu, ID_lw;
    wire ID_sw, ID_sh, ID_sb;
    wire ID_ALUsrc, ID_memreg, ID_is_unsigned;
    
    assign ID_rs1_addr = IF_ID_insn[19:15];
    assign ID_rs2_addr = IF_ID_insn[24:20];
    
    reg_bank ID_reg_bank_uut(.clk(clk), .rstn(~rst),
                             .rd_addr1(ID_rs1_addr), .rd_addr2(ID_rs2_addr),
                             .rwr(MEM_WB_rwr),
                             .wr_addr(MEM_WB_wr_addr),
                             .wr_data(MEM_WB_wr_data), .x4(x4),
                             .rd_data1(ID_rd_data1), .rd_data2(ID_rd_data2));
                             
    immediate_gen ID_immediate_gen_uut( .insn_type(ID_insn_type),
                                        .insn(IF_ID_insn),
                                        .immediate(ID_immediate)
                                      );
    
    controller ID_controller_uut( .insn(IF_ID_insn),
                                  .insn_type(ID_insn_type), // 0: R-type, 1: I-type, 2: Load-type, 3: S-type, 4: B-type, 5: J-type, 6: jalr, 7: U-type
                                  .rwr(ID_rwr), .is_unsigned(ID_is_unsigned), 
                                  .ALUsrc(ID_ALUsrc), .memreg(ID_memreg),
                                  .dmr(ID_dmr), .dmw(ID_dmw),
                                  .ALU_control(ID_ALU_control),
                                  .lb(ID_lb),.lbu(ID_lbu),.lh(ID_lh),.lhu(ID_lhu),.lw(ID_lw),
                                  .sw(ID_sw),.sh(ID_sh),.sb(ID_sb),
                                  .func3(ID_func3) 
                                );
                                      
    always @(posedge clk) begin
        if(rst) begin
           ID_EX_rd_data1 <= 0;
           ID_EX_rd_data2 <= 0; 
        end
        else if(~ID_EX_CE) begin
           ID_EX_rd_data1 <= ID_EX_rd_data1;
           ID_EX_rd_data2 <= ID_EX_rd_data2;
        end
        else begin
           ID_EX_rd_data1 <= ID_rd_data1;
           ID_EX_rd_data2 <= ID_rd_data2;
        end
    end
    
    always @(posedge clk) begin
        if(rst) begin
           ID_EX_wr_addr <= 0; 
        end
        else if(~ID_EX_CE) begin
           ID_EX_wr_addr <= ID_EX_wr_addr;
        end
        else begin
           ID_EX_wr_addr <= IF_ID_insn[11:7];
        end
    end
    
    always @(posedge clk) begin
        if(rst) begin
           ID_EX_immediate <= 0; 
        end
        else if(~ID_EX_CE) begin
           ID_EX_immediate <= ID_EX_immediate;
        end
        else begin
           ID_EX_immediate <= ID_immediate;
        end
    end
    
    always @(posedge clk) begin
        if(rst | ID_disc) begin
           ID_EX_insn_type <= 0; 
        end
        else if(~ID_EX_CE) begin
           ID_EX_insn_type <= ID_EX_insn_type;
        end
        else begin
           ID_EX_insn_type <= ID_insn_type;
        end
    end
    
    always @(posedge clk) begin
        if(rst | ID_disc) begin
           ID_EX_ALU_control <= 0; 
           ID_EX_lb <= 0; 
           ID_EX_lbu <= 0; 
           ID_EX_lh <= 0; 
           ID_EX_lhu <= 0;
           ID_EX_lw <= 0;
        end
        else if(~ID_EX_CE) begin
           ID_EX_ALU_control <= ID_EX_ALU_control;
           ID_EX_lb <= ID_EX_lb; 
           ID_EX_lbu <= ID_EX_lbu; 
           ID_EX_lh <= ID_EX_lh; 
           ID_EX_lhu <= ID_EX_lhu;
           ID_EX_lw <= ID_EX_lw;
        end
        else begin
           ID_EX_ALU_control <= ID_ALU_control;
           ID_EX_lb <= ID_lb; 
           ID_EX_lbu <= ID_lbu; 
           ID_EX_lh <= ID_lh; 
           ID_EX_lhu <= ID_lhu;
           ID_EX_lw <= ID_lw;
        end
    end
    
    always @(posedge clk) begin
        if(rst | ID_disc) begin
           ID_EX_sw <= 0;
           ID_EX_sh <= 0; 
           ID_EX_sb <= 0; 
        end
        else if(~ID_EX_CE) begin
           ID_EX_sw <= ID_EX_sw;
           ID_EX_sh <= ID_EX_sh; 
           ID_EX_sb <= ID_EX_sb; 
        end
        else begin
           ID_EX_sw <= ID_sw;
           ID_EX_sh <= ID_sh; 
           ID_EX_sb <= ID_sb; 
        end
    end
    
    always @(posedge clk) begin
        if(rst | ID_disc) begin
           ID_EX_ALUsrc <= 0;
           ID_EX_memreg <= 0; 
           ID_EX_is_unsigned <= 0;
        end
        else if(~ID_EX_CE) begin
           ID_EX_ALUsrc <= ID_EX_ALUsrc;
           ID_EX_memreg <= ID_EX_memreg; 
           ID_EX_is_unsigned <= ID_EX_is_unsigned; 
        end
        else begin
           ID_EX_ALUsrc <= ID_ALUsrc;
           ID_EX_memreg <= ID_memreg; 
           ID_EX_is_unsigned <= ID_is_unsigned;
        end
    end
    always @(posedge clk) begin
        if(rst) ID_EX_rwr <= 0;
        else if(~ID_EX_CE) ID_EX_rwr <= ID_EX_rwr;
        else ID_EX_rwr <= ID_rwr_stall;
    end
    
    
    always @(posedge clk) begin
        if(rst | ID_disc) begin
            ID_EX_dmr <= 0;
            ID_EX_dmw <= 0;
        end
        else if(~ID_EX_CE) begin
            ID_EX_dmr <= ID_EX_dmr;
            ID_EX_dmw <= ID_EX_dmw;
        end   
        else begin  
            ID_EX_dmr <= ID_dmr;
            ID_EX_dmw <= ID_dmw;
        end   
    end
    
    assign ID_rwr_stall = ID_disc ? 1'b0 : ID_rwr;
    
    always @(posedge clk) begin
        if(rst) begin
            ID_EX_rs1_addr <= 0;
            ID_EX_rs2_addr <= 0;
        end
        else if(~ID_EX_CE) begin
            ID_EX_rs1_addr <= ID_EX_rs1_addr;
            ID_EX_rs2_addr <= ID_EX_rs2_addr;
        end   
        else begin
            ID_EX_rs1_addr <= ID_rs1_addr;
            ID_EX_rs2_addr <= ID_rs2_addr;
        end
    end
    
    always @(posedge clk) begin
        if(rst | ID_disc) ID_EX_func3 <= 0;
        else if(~ID_EX_CE) ID_EX_func3 <= ID_EX_func3;
        else ID_EX_func3 <= ID_func3;
    end
    
    always @(posedge clk) begin
        if(rst) ID_EX_pc <= 0;
        else if(~ID_EX_CE) ID_EX_pc <= ID_EX_pc;
        else ID_EX_pc <= IF_ID_pc;
    end
    
    
    
endmodule
