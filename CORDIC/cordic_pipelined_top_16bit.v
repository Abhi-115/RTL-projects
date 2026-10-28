/*

This file contains all the modules used in our design for a 16 bit pipelined CORDIC, written hierarchically from top to bottom.

*/


/*
 
 CORDIC_FINAL_PIPELINED module
 This module is used for quadrant transformation. The quad_identify module identifies the quadrant of the input angle and
 modifies this angle such that it lies in the first quadrant. These first quadrant are then fed into the cordic.v module 
 which returns the sin, cos of this first quadrant angle. Then this module uses case statements to transform this result
 to the actual values using trigonometric identities.

*/

`timescale 1ns/1ns

module cordic_final_pipelined(
      input wire clk,
      input wire rst_n,
      input wire signed [16:0]    x_i,
      input wire signed [16:0]    y_i,
      input wire signed [16:0] theta_in,
      
      output reg signed [16:0]    x_o,
      output reg signed [16:0]    y_o,
      output wire signed [16:0] theta_o
);
    wire [16:0] angle_modified;      // modified angle from quad_identify module which lies in the first quadrant
    wire [1:0] quad;                 // quadrant in which the input angle lies 
    wire signed [16:0]    x_ind;     // intermediate values from the CORDIC module which takes in "angle_modified" as input 
    wire signed [16:0]    y_ind;
    reg [1:0] quad_i;


quad_identify_pipelined UUT_QI(.angle_in(theta_in),
                     .quadrant(quad),
                     .cordic_angle(angle_modified)); 
                     

cordic_pipelined UUT_CR(.clk(clk),
              .rst_n(rst_n),
              .x_i(x_i),.y_i(y_i),.theta_i(angle_modified),
              .x_o(x_ind),.y_o(y_ind),.theta_o(theta_o));


always @(*) begin
    case (quad)
        2'b00: begin                //first quadrant
            x_o = x_ind;
            y_o = y_ind;
        end
        2'b01: begin                //second quadrant
            x_o= -y_ind;
            y_o = x_ind;
        end
        2'b10: begin                //third quadrant
            x_o = -x_ind;
            y_o = -y_ind;
        end
        2'b11: begin                //fourth quadrant
            x_o = y_ind;
            y_o = -x_ind;
        end
        default: begin              //default case: first quadrant
            x_o = x_ind;
            y_o = y_ind;
        end
    endcase
end

endmodule

/*                 
   CORDIC_PIPELINED Module:
   Uses generate statement to instantiate multiple rotator modules depending on the number of bits used to represent the sine and cosine values
                     
*/
module cordic_pipelined (
  input wire clk,
  input wire rst_n,
  input wire signed [16:0]    x_i,
  input wire signed [16:0]    y_i,
  input wire signed [16:0] theta_i,
  
  output wire signed [16:0]    x_o,
  output wire signed [16:0]    y_o,
  output wire signed [16:0] theta_o
);

/*
  LUT for arctan in radian format  16 bit + sign bit.
*/
function [16:0] tanangle;
  input [3:0] i;
  begin
    case (i)
    4'b0000: tanangle = 17'd25735 ;   //  1/1
    4'b0001: tanangle = 17'd15192;    //  1/2
    4'b0010: tanangle = 17'd8027;     //  1/4
    4'b0011: tanangle = 17'd4075;     //  1/8
    4'b0100: tanangle = 17'd2045;     //  1/16
    4'b0101: tanangle = 17'd1024;     //  1/32
    4'b0110: tanangle = 17'd512;      //  1/64
    4'b0111: tanangle = 17'd256;      //  1/128
    4'b1000: tanangle = 17'd128;      //  1/256
    4'b1001: tanangle = 17'd64;       //  1/512
    4'b1010: tanangle = 17'd32;       //  1/1024
    4'b1011: tanangle = 17'd16;       //  1/2048
    4'b1100: tanangle = 17'd8;        //  1/4096
    4'b1101: tanangle = 17'd4;        //  1/8192
    4'b1110: tanangle = 17'd2;        //  1/16k
    4'b1111: tanangle = 17'd1;        //  1/32k
    endcase
  end
endfunction

  wire signed [16:0] x [15:0];
  wire signed [16:0] y [15:0];
  wire signed [16:0] z [15:0];
  assign x[0] = x_i;
  assign y[0] = y_i;
  assign z[0] = theta_i;
  assign x_o = x[15];
  assign y_o = y[15];
  assign theta_o = z[15];

genvar i;
generate for(i=0;i<15;i=i+1) begin
  rotator_pipelined #(.iteration(i), .tangle(tanangle(i))) U (clk,rst_n,x[i],y[i],z[i],x[i+1],y[i+1],z[i+1]);
end 
endgenerate

endmodule

/*

QUAD_IDENTIFY Module:
This module is used to identify the quadrant of the input angle (0<=theta<=2pi) and it outputs a modified angle (0<=theta'<=pi/2) that can be fed into the first quadrant CORDIC

*/


module quad_identify_pipelined(
    input wire [16:0] angle_in,   // Input angle in Q1.15 format
    output reg [1:0] quadrant,    // Quadrant of the input angle (0 to 3)
    output reg [16:0] cordic_angle  // Normalized angle for the CORDIC module (0 to pi/2)
);
    reg [1:0] quad_i;
    // Constants for comparison (in Q3.13 format) in radians
    parameter [16:0] PI      = 17'd25736; // pi in Q3.13 format 
    parameter [16:0] PI_BY_2 = 17'd12868; // pi/2 in Q3.13 format
    parameter [16:0] THREE_PI_BY_2 = 17'd38604; // 3*pi/2 in Q3.13 format
    parameter [16:0] TWO_PI = 17'd51472; // 2*pi in Q3.13 format

    always @(*) begin
        if (angle_in <= PI_BY_2) begin
            // First quadrant: [0, pi/2)
             cordic_angle = angle_in<<2;
             quad_i = 2'b00;
        end else if (angle_in <= PI) begin
            // Second quadrant: [pi/2, pi)
             cordic_angle = (angle_in - PI_BY_2)<<2; 
             quad_i = 2'b01;
        end else if (angle_in <= THREE_PI_BY_2) begin
            // Third quadrant: [pi, 3*pi/2)
               cordic_angle = (angle_in - PI)<<2;
               quad_i = 2'b10;
        end else begin
            // Fourth quadrant: [3*pi/2, 2*pi)
              cordic_angle = (angle_in - THREE_PI_BY_2)<<2;
              quad_i = 2'b11;
        end
    end
    
    always @(*) begin
          #29 quadrant = quad_i;
         end

endmodule

/*
ROTATOR Module:
This module is used to perform controlled addition/subtraction for the shifter variables (x_i,y_i) depending on the value of the residual angle (z_i)
*/

module rotator_pipelined (
  input wire clk,
  input wire rst_n,
  input wire signed  [16:0]    x_i,
  input wire signed  [16:0]    y_i,
  input wire signed  [16:0]    z_i,
  input wire signed  [16:0]    x_o,
  output wire signed [16:0]    y_o,
  output wire signed [16:0]    z_o
  );
  
  parameter integer iteration = 0;
  parameter signed [16:0] tangle = 0;

  reg signed [16:0] x_1;
  reg signed [16:0] y_1;
  reg signed [16:0] z_1;
  wire signed [16:0] x_i_shifted;
  wire signed [16:0] y_i_shifted;
  signed_shifter_pipelined x_shifter(iteration,x_i,x_i_shifted);
  signed_shifter_pipelined y_shifter(iteration,y_i,y_i_shifted);

  always @ (posedge clk)
    if (~rst_n) begin
      x_1 <= 0;
      y_1 <= 0;
      z_1 <= 0;
    end else begin
      if (z_i < 0) begin
        x_1 <= x_i + y_i_shifted;
        y_1 <= y_i - x_i_shifted; 
        z_1 <= z_i + tangle;
      end else begin
        x_1 <= x_i - y_i_shifted;
        y_1 <= y_i + x_i_shifted;
        z_1 <= z_i - tangle;
      end
    end
  assign x_o = x_1;
  assign y_o = y_1;
  assign z_o = z_1;
endmodule

/*  SIGNED_SHIFTER module:
  This module does an arbitrary right shift to implement'
  the 1/2^i function on signed numbers
*/

module signed_shifter_pipelined (
  input wire [31:0] i,
  input wire signed [16:0] D,
  output reg signed [16:0] Q );
  integer j;
  always @(*) begin
    if (i <= 16)
      Q = (D >>> i); // Arithmetic right shift for signed numbers
    else
      Q = {17{D[16]}}; // If shift exceeds width, extend with the sign bit
  end
endmodule
