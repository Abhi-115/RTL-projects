//`timescale 1ns / 1ps
 
 
module sipo_32(
    input clk,resetn,ss_n,
    input serial_in,
    input enable_sipo32,
    output reg EN,
    output [31:0] parallel_out
    );
    reg [31:0]q = 32'd0;
    integer i;
    parameter count = 5'd31;
    reg [4:0] counter = 5'd0;
//    reg EN;
    // register update of the FF chain
    always @(posedge clk) begin
        if (~resetn || ss_n) begin q <= 0; end
        else begin
            if (enable_sipo32) begin
                q[0] <= serial_in;
                for (i=1;i<32;i=i+1) begin
                    q[i] <= q[i-1];
                end
            end
        end
    end
    // generating EN signal
    always @(posedge clk) begin
        if (~resetn || ss_n) begin
            counter <= 0;
            EN <= 0;
        end
        else begin
            if (enable_sipo32) begin
                if (counter >= count)
                    counter <= 5'd0;
                else
                    counter <= counter + 1;
//                EN <= (counter == 5'd31)? 1'b1:1'b0;
            end
            else counter <= 0;
            EN <= (counter == 5'd31)? 1'b1:1'b0;
         end
    end
    assign parallel_out = {32{EN}} & q;
endmodule