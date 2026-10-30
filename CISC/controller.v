`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2025 11:45:00 PM
// Design Name: 
// Module Name: controller
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


module controller(
    input clk,
    input resetn,
    input [4:0] opcode,
    input [2:0] rd, rs1, rs2,
    input carry_flag, zero_flag,
    output reg regA_L, regB_L, regC_L, regD_L, regE_L, regF_L, regG_L, regH_L,
    output reg regA_en, regB_en, regC_en, regD_en, regE_en, regF_en, regG_en, regH_en,
    output reg mem_rd_bar, mem_wr_bar,
    output reg ireg_L, 
    output reg MAR_L, MAR_en,
    output reg TR1_L, TR2_L,
    output reg PC_IS, PC_L, //PC_en_to_addr_bus,
    output reg ALU_en, 
    output reg [1:0] ALU_select,
    output reg AD_S //address select btwn PC and MAR
    );
    
    localparam FETCH = 4'b0000, DECODE = 4'b0001, LD_STR = 4'b0010, JUMP_S1 = 4'b0011, JUMP_S2 = 4'b0100, ALU_LOAD_TR2 = 4'b0110, ALU_LOAD_TR1 = 4'b1000, ALU_EXEC = 4'b1001; 
    reg [3:0] present_state, next_state;
    reg [1:0] ALU_select_reg;
    always @(posedge clk) begin
        if(~resetn) begin 
            present_state <= FETCH;
        end
        else present_state <= next_state;   
    end
    
    always @(*) begin
        regA_L = 0;
        regA_en = 0;
        regB_L = 0;
        regB_en = 0;
        regC_L = 0;
        regC_en = 0;
        regD_L = 0;
        regD_en = 0;
        regE_L = 0;
        regE_en = 0;
        regF_L = 0;
        regF_en = 0;
        regG_L = 0;
        regG_en = 0;
        regH_L = 0;
        regH_en = 0;
        PC_IS = 0;
        PC_L = 0;
        mem_rd_bar = 1;
        mem_wr_bar = 1;
        ireg_L = 0;
        MAR_L = 0;
        MAR_en = 0;
        TR1_L = 0;
        TR2_L = 0;
        ALU_en = 0;
        ALU_select = ALU_select_reg;
        AD_S = 0; 
        next_state = present_state;
        case(present_state)
            FETCH: begin 
                    PC_L = 1;
                    MAR_L = 1;
                    //PC_IS = 1;
                    AD_S = 1;
                    mem_rd_bar = 0;                    
                    ireg_L = 1;
                    next_state = DECODE;
                   end
            DECODE: begin
                    if(opcode == 5'b00000 || opcode == 5'b00111) next_state = LD_STR;
                    else if(opcode == 5'b00001 || opcode == 5'b00011 || opcode == 5'b00100 || opcode == 5'b00101) next_state = ALU_LOAD_TR1;
                    else if(opcode == 5'b00010 || opcode == 5'b00110 || opcode == 5'b01000) next_state = JUMP_S1;
                    else next_state = FETCH;
                   end
            LD_STR: begin
                      AD_S = 0;
                      if(opcode == 5'b00000) begin 
                            mem_rd_bar = 0;
                            if(rd == 3'b000) regA_L = 1;
                            else if(rd == 3'b001) regB_L = 1;
                            else if(rd == 3'b010) regC_L = 1;
                            else if(rd == 3'b011) regD_L = 1;
                      end
                      else if(opcode == 5'b00111) begin
                            mem_wr_bar = 0;
                            if(rs2 == 3'b000) regA_en = 1;
                            else if(rs2 == 3'b001) regB_en = 1;
                            else if(rs2 == 3'b010) regC_en = 1;
                            else if(rs2 == 3'b011) regD_en = 1;
                      end
                      next_state = FETCH;
                    end
            ALU_LOAD_TR1: begin
                            TR1_L = 1;
                            if(opcode == 5'b00100) begin
                                if(rs1 == 3'b000) regA_en =1;
                                else if(rs1 == 3'b001) regB_en = 1;
                                else if(rs1 == 3'b010) regC_en = 1;
                                else if(rs1 == 3'b011) regD_en = 1;
                                next_state = ALU_LOAD_TR2;
                            end
                            else /*if(opcode == 5'b00001 || opcode == 5'b00011 || opcode == 5'b00101)*/ begin
                                if(rd == 3'b000) regA_en = 1;
                                else if(rd == 3'b001) regB_en = 1;
                                else if(rd == 3'b010) regC_en = 1;
                                else if(rd == 3'b011) regD_en = 1;
                                next_state = ALU_EXEC;
                            end
                          end
            ALU_EXEC: begin
                        if(opcode == 5'b00001) begin //rrc
                            ALU_select = 2'b10;
                            regB_L = 1;
                        end
                        else if(opcode == 5'b00011) begin  //shiftL
                            ALU_select = 2'b01;
                            regA_L = 1;
                        end
                        else if(opcode == 5'b00101) begin  //decr
                            ALU_select = 2'b11;
                            regC_L = 1;
                        end
                        else if(opcode == 5'b00100) begin  //add
                            ALU_select = 2'b00;
                            regD_L = 1;
                        end
                        ALU_en = 1;
                        next_state = FETCH;
                      end
            ALU_LOAD_TR2: begin
                            TR2_L =1;
                            if(rs2 == 3'b000) regA_en =1;
                            else if(rs2 == 3'b001) regB_en = 1;
                            else if(rs2 == 3'b010) regC_en = 1;
                            else if(rs2 == 3'b011) regD_en = 1;
                            next_state = ALU_EXEC;   
                          end
            
            JUMP_S1: begin
//                        PC_IS = 1;
                        if(opcode == 5'b00010) begin //JNC
                            if(~carry_flag) begin
                                MAR_en = 1;
                                PC_L = 1;
                                PC_IS = 1;
                                next_state = JUMP_S2;
                            end
                            else next_state = FETCH;
                        end
                        else if(opcode == 5'b00110) begin //JNZ
                            if(~zero_flag) begin
                                MAR_en = 1;
                                PC_L = 1;
                                PC_IS = 1;
                                next_state = JUMP_S2;
                            end
                            else next_state = FETCH;
                        end
                        else if(opcode == 5'b01000) begin //JUMP
                                MAR_en = 1;
                                PC_L = 1;
                                PC_IS = 1;
                                next_state = JUMP_S2;
                        end
                     end
            JUMP_S2: begin
                        AD_S = 0;
                        mem_rd_bar = 0;
                        next_state = FETCH;
                     end
            default: next_state = FETCH;                       
        endcase
       end
       
       always @(posedge clk) begin
            if(~resetn) ALU_select_reg <= 2'd0;
            else ALU_select_reg <= ALU_select;
            
       end
       
endmodule
