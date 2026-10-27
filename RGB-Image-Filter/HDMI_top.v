module HDMI_top(
    input clk_125MHz,//clk_25MHz,
    input reset,
    input [1:0] sel,
    output [2:0] TMDSp, TMDSn,
	output TMDSp_clock, TMDSn_clock//,
//	output hSync, vSync, DrawArea,
//	output [7:0] red, green, blue//,
//	output clk_25MHz
    );

    wire [9:0] CounterX, CounterY;
    wire [11:0] pixel_data;
//    wire hSync, vSync, DrawArea;
//	wire [7:0] red, green, blue;
	wire clk_25MHz;
	wire clk_100MHz;
    HDMI_controller uut_hdmi(
        .clk(clk_125MHz),  // 125MHz
        .reset(reset),
        .pixel_data(pixel_data),
        .clk_100MHz(clk_100MHz), 
        .pixclk(clk_25MHz), //25MHz
        .hcount(CounterX),.vcount(CounterY),
        .TMDSp(TMDSp), .TMDSn(TMDSn),
        .TMDSp_clock(TMDSp_clock), .TMDSn_clock(TMDSn_clock)//,
//        .hSync(hSync), .vSync(vSync), .DrawArea(DrawArea),
//        .red(red), .green(green), .blue(blue)
    );
//    image_bram uut_img_bram(
//        .clk_25MHz(clk_25MHz),   // Enable signal for VGA pixel updates
//        .reset(reset),
//        .hcount(CounterX),
//        .vcount(CounterY),
//        .pixel_data(pixel_data)
//    );
    image_load_filter uut_img_filter(
        .clk_25MHz(clk_25MHz),   // Enable signal for VGA pixel updates
        .reset(reset),
        .sel(sel),
        .hcount(CounterX),
        .vcount(CounterY),
        .pixel_data(pixel_data)
    );
//    image_load_bv_filter uut_img_filter(
//        .clk_100MHz(clk_100MHz),
//        .clk_25MHz(clk_25MHz),   // Enable signal for VGA pixel updates
//        .reset(reset),
//        .hcount(CounterX),
//        .vcount(CounterY),
//        .pixel_data(pixel_data)
//    );
endmodule