`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2025 02:51:45 PM
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
    input [31:0] insn,
    input zero,
    output reg [2:0] insn_type, // 0: R-type, 1: I-type, 2: Load-type, 3: S-type, 4: B-type, 5: J-type, 6: jalr, 7: U-type
    output rwr, is_unsigned,
//    output [3:0] dmw,
    output ALUsrc, memreg,
    output reg [1:0] PCsrc,
    output reg [3:0] ALU_control,
    output lb,lbu,lh,lhu,lw,
    output sw,sh,sb
//    output reg [2:0] branch_type
    );
    
    wire [6:0] opcode = insn[6:0];
    wire [2:0] func3  = insn[14:12];
//    wire [6:0] func7  = insn[31:25];
   
    always @(*) begin
        case(opcode)
            7'b0110011: insn_type = 3'd0; //R-type
            7'b0010011: insn_type = 3'd1; //I-type
            7'b0000011: insn_type = 3'd2; //load-type
            7'b0100011: insn_type = 3'd3; //S-type
            7'b1100011: insn_type = 3'd4; //B-type
            7'b1101111: insn_type = 3'd5; //J-type
            7'b1100111: insn_type = 3'd6; //jalr
            7'b0110111: insn_type = 3'd7; //U-type
            default: insn_type = 3'd0;
        endcase
    end
    
    assign lb = (insn_type == 3'd2) & (func3 == 3'd0);
    assign lh = (insn_type == 3'd2) & (func3 == 3'd1);
    assign lw = (insn_type == 3'd2) & (func3 == 3'd2);
    assign lbu = (insn_type == 3'd2) & (func3 == 3'd4);
    assign lhu = (insn_type == 3'd2) & (func3 == 3'd5);
    
    assign sb = (insn_type == 3'd3) & (func3 == 3'd0);
    assign sh = (insn_type == 3'd3) & (func3 == 3'd1);
    assign sw = (insn_type == 3'd3) & (func3 == 3'd2);
    
       
   assign ALUsrc = ((insn_type == 3'd1) || (insn_type == 3'd2) || (insn_type == 3'd3)) ? 1'b1: 1'b0;
   assign memreg = (insn_type == 3'd2) ? 1'b1 : 1'b0; 
   assign rwr = ((insn_type == 3'd0) || (insn_type == 3'd1) || (insn_type == 3'd2)) ? 1'b1: 1'b0;
   assign is_unsigned = (((insn_type == 3'd0) || (insn_type == 3'd1)) && (func3 == 3'd3)) | ((insn_type == 3'd4) & (func3[2:1]==2'b11));
   
   always @(*) begin
        case(insn_type) 
            3'd2: ALU_control = 4'b0010;  //load requires only addition in ALU
            3'd1: begin                   //I-type
                      if(func3 == 3'd0) ALU_control = 4'b0010;   //addi
                      else if(func3 == 3'd6) ALU_control = 4'b0001;  //ori
                      else if(func3 == 3'd7) ALU_control = 4'b0000;  //andi
                      else ALU_control = 4'b0000; //need to think what to give here
                  end
            3'd3: ALU_control = 4'b0010;        //s-type requires only addition in ALU
            3'd0: begin                         //r-type
                      if(func3==3'd0) begin
                        if(insn[30] == 1'b1) ALU_control = 4'b0110; //sub
                        else ALU_control = 4'b0010;                 //add
                      end
                      else if(func3 == 3'd6) ALU_control = 4'b0001; //or
                      else if(func3 == 3'd7) ALU_control = 4'b0000; //and
                      else ALU_control = 4'b0000;
                  end
            3'd4: begin     //b-type
                      if(func3==3'd0 || func3==3'd1) ALU_control = 4'b0110;   //subtract and check 'zero' output  
                      else ALU_control = 4'b0111; //subtract and check 'carry' output, if carry == 1, a>=b, else a<b
                  end
            default: ALU_control = 4'b0000;
        endcase
   end
   
   always @(*) begin
        if(insn_type == 3'd5) PCsrc = 2'b01; //j-type
        else if(insn_type == 3'd6) PCsrc = 2'b10; //jalr
        else if(insn_type == 3'd4) begin
            case(func3)
                3'b0: PCsrc = (zero == 1); // beq
                3'b1: PCsrc = (zero == 0); // bne
                3'd4: PCsrc = (zero == 0); // blt
                3'd5: PCsrc = (zero == 1); // bge
                3'd6: PCsrc = (zero == 0); // bltu
                3'd7: PCsrc = (zero == 1); // bgeu
                default: PCsrc = 2'b00;
            endcase
        end
        else PCsrc = 2'b00;
    end
       
       
endmodule
