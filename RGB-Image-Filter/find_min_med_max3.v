module find_min_med_max3(
    input [11:0] a1,
    input [11:0] a2,
    input [11:0] a3,
    output reg [11:0] min,
    output reg [11:0] med,
    output reg [11:0] max
    );
    reg [11:0] x,y,z;
    // red
     always @(*) begin
        if (a1[11:8]>a2[11:8]) begin
            x[11:8] = a2[11:8];
            y[11:8] = a1[11:8];
        end
        else begin
            x[11:8] = a1[11:8];
            y[11:8] = a2[11:8];
        end
        if (y[11:8]>a3[11:8]) begin
            max[11:8] = y[11:8];
            z[11:8] = a3[11:8];
        end
        else begin
            max[11:8] = a3[11:8];
            z[11:8] = y[11:8];
        end
        if (x[11:8]>z[11:8]) begin
            min[11:8] = z[11:8];
            med[11:8] = x[11:8];
        end
        else begin
            min[11:8] = x[11:8];
            med[11:8] = z[11:8];
        end
     end
     // green
     always @(*) begin
        if (a1[7:4]>a2[7:4]) begin
            x[7:4] = a2[7:4];
            y[7:4] = a1[7:4];
        end
        else begin
            x[7:4] = a1[7:4];
            y[7:4] = a2[7:4];
        end
        if (y[7:4]>a3[7:4]) begin
            max[7:4] = y[7:4];
            z[7:4] = a3[7:4];
        end
        else begin
            max[7:4] = a3[7:4];
            z[7:4] = y[7:4];
        end
        if (x[7:4]>z[7:4]) begin
            min[7:4] = z[7:4];
            med[7:4] = x[7:4];
        end
        else begin
            min[7:4] = x[7:4];
            med[7:4] = z[7:4];
        end
     end
     // blue
     always @(*) begin
        if (a1[3:0]>a2[3:0]) begin
            x[3:0] = a2[3:0];
            y[3:0] = a1[3:0];
        end
        else begin
            x[3:0] = a1[3:0];
            y[3:0] = a2[3:0];
        end
        if (y[3:0]>a3[3:0]) begin
            max[3:0] = y[3:0];
            z[3:0] = a3[3:0];
        end
        else begin
            max[3:0] = a3[3:0];
            z[3:0] = y[3:0];
        end
        if (x[3:0]>z[3:0]) begin
            min[3:0] = z[3:0];
            med[3:0] = x[3:0];
        end
        else begin
            min[3:0] = x[3:0];
            med[3:0] = z[3:0];
        end
     end
endmodule