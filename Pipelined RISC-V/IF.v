`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2025 06:51:40 PM
// Design Name: 
// Module Name: IF
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


module IF(
    input clk, rst,
    input [1:0] EX_PCsrc,
    input [31:0] EX_branchPC, 
    input IF_ID_CE, PC_CE, insert_nop,
    output reg [31:0] IF_ID_pc,
    output reg [31:0] IF_ID_insn,
    output IF_hit_miss_bar
    );
    
     wire [31:0] IF_pc_present;
     reg [31:0] IF_pc_next;
     wire [31:0] IF_insn, IF_insn_from_imem;
     
     pc ID_pc_uut(.clk(clk),.rstn(~rst),.pc_next(IF_pc_next),.pc_present(IF_pc_present), .pc_ce(PC_CE));
     
//     imem ID_imem_uut(.imem_addr(IF_pc_present), .insn(IF_insn_from_imem));
     
     cache_imem_top cache_imem_top_uut(
        .clk(clk), .rst(rst),
        .insn_addr(IF_pc_present),
        .hit_miss_bar(IF_hit_miss_bar),
        .insn(IF_insn_from_imem)
     );
          
     assign IF_insn = insert_nop ? 32'h00000013: IF_insn_from_imem;
     
     always @(*) begin
            case(EX_PCsrc)
                2'b00: IF_pc_next = IF_pc_present + 4;  //normal
                2'b01: IF_pc_next = EX_branchPC; //pc_present + {{2{immediate[31]}},immediate[31:2]};  //jal or if any of the branch condition is true
                2'b10: IF_pc_next = EX_branchPC; //jalr
                default: IF_pc_next = IF_pc_present + 4; 
            endcase
    end
    
    always @(posedge clk) begin
        if(rst) IF_ID_pc <= 0;
        else if(~IF_ID_CE) IF_ID_pc <= IF_ID_pc;
        else IF_ID_pc <= IF_pc_present;
    end
    
    always @(posedge clk) begin
        if(rst) IF_ID_insn <= 0;
        else if(~IF_ID_CE) IF_ID_insn <= IF_ID_insn;
        else IF_ID_insn <= IF_insn;
    end
    
endmodule
