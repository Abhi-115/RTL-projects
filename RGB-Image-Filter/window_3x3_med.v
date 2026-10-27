module window_3x3_med(
    input [11:0] a1, 
    input [11:0] a2, 
    input [11:0] a3, 
    input [11:0] a4,
    input [11:0] a5,
    input [11:0] a6,
    input [11:0] a7,
    input [11:0] a8,
    input [11:0] a9,
    output [11:0] min,
    output [11:0] med,
    output [11:0] max   
    );
    wire [11:0] min1, med1, max1;
    wire [11:0] min2, med2, max2;
    wire [11:0] min3, med3, max3;
    wire [11:0] min_Max, max_Min, med_Med, min_Med, max_Med;
    wire [11:0] min_op, max_op;
//    wire [11:0] min, max;
    //[min1,med1,max1] = find_min_med_max([A(1),A(2),A(3)]);
    find_min_med_max3 uut_med1(
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .min(min1),
        .med(med1),
        .max(max1)
    );
//    [min2,med2,max2] = find_min_med_max([A(4),A(5),A(6)]);
    find_min_med_max3 uut_med2(
        .a1(a4),
        .a2(a5),
        .a3(a6),
        .min(min2),
        .med(med2),
        .max(max2)
    );
//    [min3,med3,max3] = find_min_med_max([A(7),A(8),A(9)]);
    find_min_med_max3 uut_med3(
        .a1(a7),
        .a2(a8),
        .a3(a9),
        .min(min3),
        .med(med3),
        .max(max3)
    );
//     min_Max = find_min([max1,max2,max3]);
    find_min3 uut_min_Max(
        .a1(max1),
        .a2(max2),
        .a3(max3),
        .min(min_Max)
    );
//    max_Min = find_max([min1,min2,min3]);
    find_max3 uut_max_Min(
        .a1(min1),
        .a2(min2),
        .a3(min3),
        .max(max_Min)
    );
//    [~,med_Med,~] = find_min_med_max([med1,med2,med3]);
    find_min_med_max3 uut_med_Med(
        .a1(med1),
        .a2(med2),
        .a3(med3),
        .min(min_Med),
        .med(med_Med),
        .max(max_Med)
    );
//    [~,final_value,~] = find_min_med_max([min_Max,max_Min,med_Med]);
    find_min_med_max3 uut_med_output(
        .a1(min_Max),
        .a2(med_Med),
        .a3(max_Min),
        .min(min_op),
        .med(med),
        .max(max_op)
    );
    find_max3 uut_max_Max(
        .a1(max1),
        .a2(max2),
        .a3(max3),
        .max(max)
    );
    find_min3 uut_min_Min (
        .a1(min1),
        .a2(min2),
        .a3(min3),
        .min(min)
    );
 
endmodule