`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2025 08:12:50 PM
// Design Name: 
// Module Name: riscV_top
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


module riscV_top(
    input clk,
    input rstn,
    output [31:0] x10//, x11
    );
    
    wire [31:0] insn;
    reg [7:0] pc_next;
    wire [7:0] pc_present;
    
    wire rwr;
    wire [31:0] reg_write_data;
    wire [31:0] read_data1, read_data2;
    
    wire [31:0] ALU_in1, ALU_in2 ,ALU_out;
    wire [31:0] immediate;
    
    wire ALUsrc, memreg, is_unsigned ,ALU_zero;
    wire [1:0] PCsrc;
    wire lb,lbu,lh,lhu,lw;
    wire sw,sh,sb;
    wire [3:0] ALU_control;
    
    wire [31:0] data_mem_read_out;
    
    wire [2:0] insn_type;
    
    pc pc_uut(.clk(clk),.rstn(rstn),.pc_next(pc_next),.pc_present(pc_present));
    
    always @(*) begin
            case(PCsrc)
                2'b00: pc_next = pc_present + 1;  //normal
                2'b01: pc_next = pc_present + {{2{immediate[31]}},immediate[31:2]};  //jal or if any of the branch condition is true
                2'b10: pc_next = read_data1 + {{2{immediate[31]}},immediate[31:2]}; //immediate; //jalr
                default: pc_next = pc_present + 1; 
            endcase
    end
    
    imem imem_uut(.imem_addr(pc_present), .insn(insn));
    
    reg_bank reg_bank_uut(.clk(clk), .rstn(rstn),
                          .rd_addr1(insn[19:15]), .rd_addr2(insn[24:20]),
                          .rwr(rwr),
                          .wr_addr(insn[11:7]),
                          .wr_data(reg_write_data),
                          .rd_data1(read_data1), .rd_data2(read_data2),
                          .x10(x10)/*, .x11(x11)*/);
    
    assign ALU_in1 = read_data1;
    assign ALU_in2 = ALUsrc ? immediate : read_data2;
//    assign ALU_in2 = ALUsrc ?  {{2{immediate[31]}},immediate[31:2]} : read_data2;
    
    ALU ALU_uut(.in1(ALU_in1),
                .in2(ALU_in2),
                .ALU_control(ALU_control), 
                .is_unsigned(is_unsigned),
                .out(ALU_out),
                .zero(ALU_zero));
    
    data_mem dmem_uut(.mem_addr(ALU_out[9:0]),
                      .clk(clk),
                      .lb(lb),.lbu(lbu),.lh(lh),.lhu(lhu),.lw(lw),
                      .sw(sw),.sh(sh),.sb(sb),
                      .mem_write_data_in(read_data2),
                      .mem_read_data_out(data_mem_read_out));
                      
    assign reg_write_data = (insn_type == 3'd5)? (pc_present + 1) : (memreg ? data_mem_read_out : ALU_out);
    
    immediate_gen imm_gen_uut(.insn_type(insn_type),
                              .insn(insn),
                              .immediate(immediate));
    
    controller controller_uut(.insn(insn),
                              .zero(ALU_zero),
                              .insn_type(insn_type), // 0: R-type, 1: I-type, 2: Load-type, 3: S-type, 4: B-type, 5: J-type, 6: jalr, 7: U-type
                              .rwr(rwr), .is_unsigned(is_unsigned),
                              .ALUsrc(ALUsrc), .memreg(memreg),
                              .PCsrc(PCsrc),
                              .ALU_control(ALU_control),
                              .lb(lb),.lbu(lbu),.lh(lh),.lhu(lhu),.lw(lw),
                              .sw(sw),.sh(sh),.sb(sb));
                              
                        
endmodule
