// VGA controller 640x400

module vga (
   // pixel clock
   input  pclk,
	
	// Input
	input data,
	input pal,
	
	// output to VGA screen
   output reg	hs,
   output reg 	vs,
   output [5:0] r,
   output [5:0] g,
   output [5:0] b
);
					
// PAL timing: 
// 864 pixel total horizontal @ 13.5 Mhz = 15.625 kHz
// 312 lines vertically @ 15.625 kHz = 50.08 Hz

// NTSC timing: 
// 858 pixel total horizontal @ 13.5 Mhz = 15.735 kHz
// 262 lines vertically @ 15.735 kHz = 60.05 Hz

parameter H   = 640;         // width of visible area
wire [9:0] hfp = pal?51:56;  // unused time before hsync
wire [9:0] hsw = pal?63:63;  // width of hsync
wire [9:0] hbp = pal?110:99; // unused time after hsync

parameter V   = 200;         // height of visible area
wire [9:0] vfp = pal?46:23;  // unused time before vsync
wire [9:0] vsw = pal?2:3;    // width of vsync
wire [9:0] vbp = pal?64:36;  // unused time after vsync

reg[9:0]  h_cnt;        // horizontal pixel counter
reg[9:0]  v_cnt;        // vertical pixel counter

// both counters count from the begin of the visible area

// horizontal pixel counter
always@(posedge pclk) begin
	if(h_cnt==H+hfp+hsw+hbp-1)  h_cnt <= 10'd0;
	else                        h_cnt <= h_cnt + 10'd1;

        // generate negative hsync signal
	if(h_cnt == H+hfp)     hs <= 1'b0;
	if(h_cnt == H+hfp+hsw) hs <= 1'b1;
end

// veritical pixel counter
always@(posedge pclk) begin
        // the vertical counter is processed at the begin of each hsync
	if(h_cnt == H+hfp) begin
		if(v_cnt==vsw+vbp+V+vfp-1)  v_cnt <= 10'd0; 
		else							 	 v_cnt <= v_cnt + 10'd1;

               // generate positive vsync signal
 		if(v_cnt == V+vfp)     vs <= 1'b1;
		if(v_cnt == V+vfp+vsw) vs <= 1'b0;
	end
end

reg [18:0] video_counter;
reg [7:0] pixel;

always@(posedge pclk) begin
   // The video counter is being reset at the begin of each vsync.

   // visible area?
	if((v_cnt < V) && (h_cnt < H)) begin
		// increase video counter after each pixel
		video_counter <= video_counter + 19'd1;		
		pixel <= data ?  8'hff: 8'h00;
	end else begin
		if(h_cnt == H+hfp) begin
			// the video counter is reset at the begin of the vsync
			if(v_cnt == V+vfp)
				video_counter <= 19'd0;
		end
			
		pixel <= 8'h03;   // color outside visible area: blue
	end
end

assign r = { pixel[5:4], 4'b0000 };
assign g = { pixel[3:2], 4'b0000 };
assign b = { pixel[1:0], 4'b0000 };

endmodule
