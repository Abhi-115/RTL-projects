//`timescale 1ns / 1ps
 
 
module sipo_8(
    input clk,resetn,ss_n,
    input serial_in,
    input enable_sipo8,
    output reg EN,
    output [7:0] parallel_out
    );
    reg [7:0]q = 8'd0;
    integer i;
    parameter count = 3'd7;
    reg [2:0] counter = 3'd0;
    // register update of the FF chain
    always @(posedge clk) begin
        if (~resetn || ss_n) begin
            q <= 0;
        end
        else begin
            if (enable_sipo8) begin
                q[0] <= serial_in;
                for (i=1;i<8;i=i+1) begin
                    q[i] <= q[i-1];
                end
            end
        end
    end
    // generating EN signal
    always @(posedge clk) begin
        if (~resetn || ss_n) begin
            counter <= 3'd0;
            EN <= 0;
        end
        else begin
            if (enable_sipo8) begin
                if (counter >= count)
                    counter <= 3'd0;
                else
                    counter <= counter + 1;
//                EN <= (counter == 3'd7)? 1'b1:1'b0;
            end
            else counter <= 0;
            EN <= (counter == 3'd7)? 1'b1:1'b0;
        end
   end
    assign parallel_out = {8{EN}} & q;
endmodule