`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2025 02:14:40 AM
// Design Name: 
// Module Name: cache_controller
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


module cache_controller(
    input clk, rst,
    input [31:0] addr,
    output hit_miss_bar, 
    output reg cache_en, main_imem_en
    );
    
    reg [3:0] tag_dir[15:0];
    reg [0:0] valid[15:0];
    
    assign hit_miss_bar = valid[addr[7:4]] & (tag_dir[addr[7:4]] == addr[11:8]);
//    assign valid = cache_en;
    
//    assign tag_dir[addr[7:4]] = cache_en ? addr[11:8] : 
    integer i;
    
    always @(posedge clk) begin
        if(rst) begin
            for(i=0; i<16; i=i+1) begin
                tag_dir[i] <= 4'b0;
                valid[i] <= 1'b0;
            end
        end
        else if(cache_en) begin 
                tag_dir[addr[7:4]] <= addr[11:8];
                valid[addr[7:4]] <= 1'b1;
        end
    end
    
        
    reg [1:0] next_state, present_state;
    localparam IDLE = 2'b00, MISS = 2'b01, HIT = 2'b10, FETCH = 2'b11;
    
    always @(posedge clk) begin
        if(rst) present_state <= IDLE;
        else present_state <= next_state;
    end
    
    always @(*) begin
        case(present_state)
            IDLE: begin
                    if(~hit_miss_bar) next_state = MISS;
                    else next_state = HIT;               
                  end
            MISS: begin
                    next_state = FETCH;        
                  end
            FETCH: begin
                    next_state = HIT;
                  end
            HIT:  begin
                    if(~hit_miss_bar) next_state = MISS;
                    else next_state = HIT;
                  end
         endcase
     end               
    
     always @(*) begin
        case(next_state)
            IDLE: begin
                    cache_en = 1'b0;
                    main_imem_en = 1'b0;                   
                  end
            MISS: begin
                    cache_en = 1'b0;
                    main_imem_en = 1'b1;            
                  end
            FETCH: begin
                    cache_en = 1'b1;
                    main_imem_en = 1'b1;
                  end
            HIT:  begin
                    cache_en = 1'b0;
                    main_imem_en = 1'b0;
                  end
            
        endcase
     
     end
    
endmodule
