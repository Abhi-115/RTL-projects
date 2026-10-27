module image_load_filter (
//    input wire clk_100MHz,  // System clock
    input wire clk_25MHz,   // Enable signal for VGA pixel updates
    input wire reset,
    input wire [1:0] sel,
    input wire [9:0] hcount,
    input wire [9:0] vcount,
    output reg [11:0] pixel_data
);
    localparam HEIGHT = 122;
    localparam WIDTH = 162;
    localparam SIZE = HEIGHT*WIDTH;
    // Memory declaration for 320x240 image, 12-bit per pixel
    reg [11:0] image_mem_array [0:(SIZE - 1)]; // 322 * 242 = 77924 pixels
    // Load image from file
    initial begin
        $readmemh("salty_noisy_gpt160.mem", image_mem_array);
    end
    // Define the offset to center the image (for a 640x480 display)
    localparam H_OFFSET = (640 - (WIDTH - 2))/2; // (640 - 320) / 2
    localparam V_OFFSET = (480 - (HEIGHT - 2))/2; // (480 - 240) / 2
    reg [9:0] x=0, y=0;
    reg [11:0] a1,a2,a3,a4,a5,a6,a7,a8,a9, middle_value;
    wire [11:0] min_value, med_value, max_value;
    window_3x3_med uut_window(a1,a2,a3,a4,a5,a6,a7,a8,a9,min_value, med_value, max_value);
    always @(posedge clk_25MHz) begin
        if (reset) begin
            pixel_data <= 12'd0; // Reset to black
        end 
        else /*if (clk_25MHz)*/ begin
            // Check if the pixel is inside the 320x240 image area
            if ((hcount >= H_OFFSET && hcount < H_OFFSET + (WIDTH - 2)) &&
                (vcount >= V_OFFSET && vcount < V_OFFSET + (HEIGHT - 2))) begin
                // Map VGA hcount/vcount to image memory index
                x = hcount - H_OFFSET; // Adjust for image offset
                y = vcount - V_OFFSET;
//                pixel_data <= image_mem_array[y * 320 + x]; // Fetch pixel
                pixel_data <= middle_value;
            end
            else begin
                x = 0;
                y = 0;
                pixel_data <= 12'd0; // Set to black for areas outside the image
            end
        end
    end
    always @(*) begin
            if ((hcount >= H_OFFSET+1 && hcount <= H_OFFSET + (WIDTH - 2)) &&
                (vcount >= V_OFFSET+1 && vcount <= V_OFFSET + (HEIGHT - 2))) begin
                a1 = image_mem_array[y * WIDTH + x];
                a2 = image_mem_array[y * WIDTH + x + 1];
                a3 = image_mem_array[y * WIDTH + x + 2];
                a4 = image_mem_array[(y+1) * WIDTH + x];
                a5 = image_mem_array[(y+1) * WIDTH + x + 1];
                a6 = image_mem_array[(y+1) * WIDTH + x + 2];
                a7 = image_mem_array[(y+2) * WIDTH + x];
                a8 = image_mem_array[(y+2) * WIDTH + x + 1];
                a9 = image_mem_array[(y+2) * WIDTH + x + 2];
            end
            else begin
                a1 = 0;
                a2 = 0;
                a3 = 0;
                a4 = 0;
                a5 = 0;
                a6 = 0;
                a7 = 0;
                a8 = 0;
                a9 = 0;
            end
        end
 
    always @(*) begin
        case (sel)
            2'd0: middle_value = a5;
            2'd1: middle_value = min_value;
            2'd2: middle_value = med_value;
            2'd3: middle_value = max_value;
        endcase
    end
endmodule