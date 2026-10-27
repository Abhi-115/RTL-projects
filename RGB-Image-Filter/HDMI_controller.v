module HDMI_controller(
	input clk,  // 125MHz
	input reset,
	input [11:0] pixel_data,
	output clk_100MHz, 
	output pixclk, //25MHz
	output [9:0] hcount, vcount,
	output [2:0] TMDSp, TMDSn,
	output TMDSp_clock, TMDSn_clock//,
//	output reg hSync, vSync, DrawArea,
//	output reg [7:0] red, green, blue
);
 
wire MMCM_pix_clock,clk_in_100MHz;//, pixclk;
wire clk_TMDS, DCM_TMDS_CLKFX;
wire clkfb_in, clkfb_out;
 
MMCME2_BASE #(
      .BANDWIDTH("OPTIMIZED"),   // Jitter programming (OPTIMIZED, HIGH, LOW)
      .CLKFBOUT_MULT_F(8.0),     // Multiply value for all CLKOUT (2.000-64.000).
      .CLKFBOUT_PHASE(0.0),      // Phase offset in degrees of CLKFB (-360.000-360.000).
      .CLKIN1_PERIOD(12.0),       // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      .CLKOUT1_DIVIDE(40),   //9/(30*15n) = 20
      .CLKOUT2_DIVIDE(4),    //9/(3*15n) = 200
      .CLKOUT3_DIVIDE(1),
      .CLKOUT4_DIVIDE(1),
      .CLKOUT5_DIVIDE(1),
      .CLKOUT6_DIVIDE(1),
      .CLKOUT0_DIVIDE_F(7.5),    // Divide amount for CLKOUT0 (1.000-128.000). //9/(7.5*15n) = 80
      // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT1_DUTY_CYCLE(0.5),
      .CLKOUT2_DUTY_CYCLE(0.5),
      .CLKOUT3_DUTY_CYCLE(0.5),
      .CLKOUT4_DUTY_CYCLE(0.5),
      .CLKOUT5_DUTY_CYCLE(0.5),
      .CLKOUT6_DUTY_CYCLE(0.5),
      // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
      .CLKOUT0_PHASE(0.0),
      .CLKOUT1_PHASE(0.0),
      .CLKOUT2_PHASE(0.0),
      .CLKOUT3_PHASE(0.0),
      .CLKOUT4_PHASE(0.0),
      .CLKOUT5_PHASE(0.0),
      .CLKOUT6_PHASE(0.0),
      .CLKOUT4_CASCADE("FALSE"), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
      .DIVCLK_DIVIDE(1),         // Master division value (1-106)
      .REF_JITTER1(0.0),         // Reference input jitter in UI (0.000-0.999).
      .STARTUP_WAIT("FALSE")     // Delays DONE until MMCM is locked (FALSE, TRUE)
   )
   MMCME2_BASE_inst (
      // Clock Outputs: 1-bit (each) output: User configurable clock outputs
      .CLKOUT0(clk_in_100MHz),     // 1-bit output: CLKOUT0
      .CLKOUT0B(CLKOUT0B),   // 1-bit output: Inverted CLKOUT0
      .CLKOUT1(MMCM_pix_clock),     // 1-bit output: CLKOUT1
      .CLKOUT1B(CLKOUT1B),   // 1-bit output: Inverted CLKOUT1
      .CLKOUT2(DCM_TMDS_CLKFX),     // 1-bit output: CLKOUT2
      .CLKOUT2B(CLKOUT2B),   // 1-bit output: Inverted CLKOUT2
      .CLKOUT3(CLKOUT3),     // 1-bit output: CLKOUT3
      .CLKOUT3B(CLKOUT3B),   // 1-bit output: Inverted CLKOUT3
      .CLKOUT4(CLKOUT4),     // 1-bit output: CLKOUT4
      .CLKOUT5(CLKOUT5),     // 1-bit output: CLKOUT5
      .CLKOUT6(CLKOUT6),     // 1-bit output: CLKOUT6
      // Feedback Clocks: 1-bit (each) output: Clock feedback ports
      .CLKFBOUT(clkfb_in),   // 1-bit output: Feedback clock
      .CLKFBOUTB(CLKFBOUTB), // 1-bit output: Inverted CLKFBOUT
      // Status Ports: 1-bit (each) output: MMCM status ports
      .LOCKED(LOCKED),       // 1-bit output: LOCK
      // Clock Inputs: 1-bit (each) input: Clock input
      .CLKIN1(clk),       // 1-bit input: Clock
      // Control Ports: 1-bit (each) input: MMCM control ports
      .PWRDWN(PWRDWN),       // 1-bit input: Power-down
      .RST(reset),             // 1-bit input: Reset
      // Feedback Clocks: 1-bit (each) input: Clock feedback ports
      .CLKFBIN(clkfb_out)      // 1-bit input: Feedback clock
   );

 
BUFG BUFG_clk_100M (
      .O(clk_100MHz), // 1-bit output: Clock output
      .I(clk_in_100MHz)  // 1-bit input: Clock input
   );
 
   BUFG BUFG_pixclk (
      .O(pixclk), // 1-bit output: Clock output
      .I(MMCM_pix_clock)  // 1-bit input: Clock input
   );

BUFG BUFG_TMDSp (
      .O(clk_TMDS), // 1-bit output: Clock output
      .I(DCM_TMDS_CLKFX)  // 1-bit input: Clock input
   );
 
BUFG BUFG_CLKFB (
      .O(clkfb_out), // 1-bit output: Clock output
      .I(clkfb_in)  // 1-bit input: Clock input
   );
 
reg [9:0] CounterX = 0, CounterY = 0;
 
assign hcount = CounterX;
assign vcount = CounterY;
 
reg hSync=0, vSync=0, DrawArea=0;
 
always @(posedge pixclk)
    begin
        if(reset) begin
            DrawArea <=0;
            CounterX <= 0;
            CounterY <= 0;
        end  
        else begin
            DrawArea <= (CounterX<640) && (CounterY<480);           // define picture dimensions for 640x480 (off-screen data 800x525)
            CounterX <= (CounterX==799) ? 0 : CounterX+1;           // horizontal counter (including off-screen horizontal 160 pixels) total of 800 pixels 
            if(CounterX==799) 
                CounterY <= (CounterY==524) ? 0 : CounterY+1;       /* vertical counter (including off-screen vertical 45 pixels) total of 525 pixels
                                                                       only counts up 1 count after horizontal finishes. */   
        end                                                                                                                  
        hSync <= (CounterX>=656) && (CounterX<752);         // hsync high for 96 counts                                                 
        vSync <= (CounterY>=490) && (CounterY<492);         // vsync high for 2 counts
    end
 
reg [7:0] red=0, green=0, blue=0;
 
always @(posedge pixclk) 
//    red <= ({CounterX[5:0] & {6{CounterY[4:3]==~CounterX[4:3]}}, 2'b00} | W) & ~A;
    if (reset) red <= 0;
    else  red <= {pixel_data[11:8],pixel_data[11:8]};
always @(posedge pixclk) 
//    green <= (CounterX[7:0] & {8{CounterY[6]}} | W) & ~A;
    if (reset) green <= 0;
    else green <= {pixel_data[7:4],pixel_data[7:4]};    
always @(posedge pixclk) 
//    blue <= CounterY[7:0] | W | A;
    if (reset) blue <= 0;
    else blue <= {pixel_data[3:0],pixel_data[3:0]};
 
wire [9:0] TMDS_red, TMDS_green, TMDS_blue;
 
// instantiate TMDS encoders (TMDS_encoder.vhd file from github)
TMDS_encoder encode_R(.clk(pixclk), .reset(reset), .VD(red  ), .CD(2'b00)        , .VDE(DrawArea), .TMDS(TMDS_red));
TMDS_encoder encode_G(.clk(pixclk), .reset(reset), .VD(green), .CD(2'b00)        , .VDE(DrawArea), .TMDS(TMDS_green));
TMDS_encoder encode_B(.clk(pixclk), .reset(reset), .VD(blue ), .CD({vSync,hSync}), .VDE(DrawArea), .TMDS(TMDS_blue));   // I think HDMI standard says both "sync" signals are sent over the "blue" line control inputs
// end 8b/10b encoding

reg [3:0] TMDS_mod10=0;  // modulus 10 counter
reg [9:0] TMDS_shift_red=0, TMDS_shift_green=0, TMDS_shift_blue=0;
reg TMDS_shift_load=0;
 
always @(posedge clk_TMDS) 
    if (reset) TMDS_shift_load <= 0;
    else TMDS_shift_load <= (TMDS_mod10==4'd9);  // shift load is high only if mod ten counter is done
 
always @(posedge clk_TMDS)
    begin
        if (reset) begin
            TMDS_shift_red <= 0;
            TMDS_shift_green <= 0;
            TMDS_shift_blue <= 0;
            TMDS_mod10 <= 0;
        end
        else begin
            TMDS_shift_red   <= TMDS_shift_load ? TMDS_red   : TMDS_shift_red  [9:1];  // only if all the old data has been serialized, then start shifting new data
            TMDS_shift_green <= TMDS_shift_load ? TMDS_green : TMDS_shift_green[9:1];  // kind of a wierd way of shifting but it works. replacing the last shift data with the MSB:LSB+1
            TMDS_shift_blue  <= TMDS_shift_load ? TMDS_blue  : TMDS_shift_blue [9:1];	
            TMDS_mod10 <= (TMDS_mod10==4'd9) ? 4'd0 : TMDS_mod10+4'd1;                 // increase counter or reset after 10 counts
        end
    end
 
OBUFDS #(
      .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
   ) OBUFDS_red (
      .O(TMDSp[2]),     // Diff_p output (connect directly to top-level port)
      .OB(TMDSn[2]),   // Diff_n output (connect directly to top-level port)
      .I(TMDS_shift_red[0])      // Buffer input
   );

OBUFDS #(
      .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
   ) OBUFDS_green (
      .O(TMDSp[1]),     // Diff_p output (connect directly to top-level port)
      .OB(TMDSn[1]),   // Diff_n output (connect directly to top-level port)
      .I(TMDS_shift_green[0])      // Buffer input
   );

OBUFDS #(
      .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
   ) OBUFDS_blue (
      .O(TMDSp[0]),     // Diff_p output (connect directly to top-level port)
      .OB(TMDSn[0]),   // Diff_n output (connect directly to top-level port)
      .I(TMDS_shift_blue[0])      // Buffer input
   );
 
OBUFDS #(
      .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
   ) OBUFDS_clock (
      .O(TMDSp_clock),     // Diff_p output (connect directly to top-level port)
      .OB(TMDSn_clock),   // Diff_n output (connect directly to top-level port)
      .I(pixclk)      // Buffer input
   );
 
endmodule