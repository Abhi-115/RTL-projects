// `timescale 1ns / 1ps
 
module piso_32(
    input clk,
    input resetn,ss_n,
    input enable_piso32,
    input [31:0] parallel_in,
    output reg EN,
    output serial_out
    );
    reg [31:0] q;
    parameter count = 5'd31;
    reg [4:0] counter = 5'd0;
    reg LD;
    integer i;
    // generating LD signal
    always @(posedge clk) begin
        if (~resetn || ss_n) begin counter <= 0; EN <= 0; LD <=0; end
        else begin
            if (enable_piso32) begin
                if (counter >= count)
                    counter <= 5'd0;
                else
                    counter <= counter + 1;
                LD <= (counter == 5'd2)? 1'b1:1'b0;
//                EN <= (counter == 5'd31)? 1'b1:1'b0;
            end
            else begin
                counter <= 0; LD <= 0;
            end
            EN <= (counter == 5'd31)? 1'b1:1'b0;
        end
    end
//    assign LD = (counter == 5'd0)? 1'b1:1'b0;
    always @(posedge clk) begin
        if (~resetn || ss_n) q <= 0;
        else begin
            if (enable_piso32) begin
                q[0] <= parallel_in[0];
                for (i=1;i<32;i=i+1) begin
                    if (LD) q[i] <= parallel_in[i];
                    else q[i] <= q[i-1];
                end
            end
            else q <= 0;
        end
    end
    assign serial_out = q[31];
endmodule