`timescale 1ns / 1ps
module HDMI_top_tb;
 
    // Testbench Signals
    reg clk_125MHz;
    reg clk_25MHz;
    reg vsync_seen;
    reg [1:0] sel;
    reg reset;
    wire [2:0] TMDSp, TMDSn;
    wire [7:0] red, green, blue;
	wire TMDSp_clock, TMDSn_clock;
	wire hSync, DrawArea;
	wire vSync;
 
    // File for writing pixel values
    integer file;
    HDMI_top HDMI_uut(
        .clk_125MHz(clk_125MHz),//.clk_25MHz(clk_25MHz),
        .sel(sel),.reset(reset),
        .TMDSp(TMDSp), .TMDSn(TMDSn),
        .TMDSp_clock(TMDSp_clock),.TMDSn_clock(TMDSn_clock)//,
//        .hSync(hSync),.vSync(vSync),.DrawArea(DrawArea),
//        .red(red), .green(green), .blue(blue)//,
//        .clk_25MHz(clk_25MHz)
    );

 
    // Clock Generation (100 MHz and 25 MHz)
    always #4 clk_125MHz = ~clk_125MHz;
    always #20 clk_25MHz = ~clk_25MHz;
 
    // Test Sequence
    initial begin
        // Initialize signals
        clk_125MHz = 0;
        reset = 1;
        clk_25MHz = 0;
        vsync_seen = 0;
        sel = 2'd3;
        #150 reset = 0;
        // Open file to save output pixels
        file = $fopen("C:/Users/user/Abhinava/Coursework/FPGA/Project/outputhdmi_gpt160_max.mem", "w");
        if (file == 0) begin
            $display("Error opening file!");
            $finish;
        end
    end
 
    // Monitor VGA signals and save pixel data until the first vsync pulse
    always @(posedge clk_25MHz) begin
        if (!reset & !vsync_seen) begin
            $fwrite(file, "%02X%02X%02X\n", red, green, blue);
        end
 
        // Check for first vsync pulse
        if (vSync && !vsync_seen) begin
            vsync_seen = 1;
            $display("First vsync detected. Stopping file write.");
            $fclose(file);
            $stop; // Stop simulation
        end
    end
 
endmodule


