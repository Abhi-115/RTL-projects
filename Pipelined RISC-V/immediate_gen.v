//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2025 12:42:54 PM
// Design Name: 
// Module Name: immediate_gen
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

// 0: R-type, 1: I-type, 2: Load-type, 3: S-type, 4: B-type, 5: J-type, 6: jalr, 7: U-type

module immediate_gen(
    input [2:0] insn_type,
    input [31:0] insn,
    output reg [31:0] immediate
    );
    
    always @(*) begin
        case(insn_type)
            3'd1: immediate[0] = insn[20];
            3'd2: immediate[0] = insn[20];
            3'd3: immediate[0] = insn[7];
            default: immediate[0] = 1'b0;    
        endcase
    end
    
    always @(*) begin
        case(insn_type)
            3'd1: immediate[4:1] = insn[24:21];
            3'd2: immediate[4:1] = insn[24:21];
            3'd3: immediate[4:1] = insn[11:8];
            3'd4: immediate[4:1] = insn[11:8];
            3'd5: immediate[4:1] = insn[24:21];
            default: immediate[4:1] = 4'd0;    
        endcase
    end
    
    always @(*) begin
        case(insn_type)
            3'd7: immediate[10:5] = 6'd0;
            default: immediate[10:5] = insn[30:25];    
        endcase
    end
    
    always @(*) begin
        case(insn_type)
            3'd1: immediate[11] = insn[31];
            3'd2: immediate[11] = insn[31];
            3'd3: immediate[11] = insn[31];
            3'd4: immediate[11] = insn[7];
            3'd5: immediate[11] = insn[20];
            3'd7: immediate[11] = 1'b0;
            default: immediate[11] = 1'b0;    
        endcase
    end
    
    always @(*) begin
        case(insn_type)
            3'd5: immediate[19:12] = insn[19:12];
            3'd7: immediate[19:12] = insn[19:12];
            default: immediate[19:12] = {8{insn[31]}};    
        endcase
    end
    
    always @(*) begin
        case(insn_type)
            3'd7: immediate[30:20] = insn[30:20];
            default: immediate[30:20] = {11{insn[31]}};    
        endcase
    end
    
    always @(*) begin
        immediate[31] = insn[31];
    end
    
endmodule
