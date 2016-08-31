// A simple system-on-a-chip (SoC) for the MiST
// (c) 2015 Till Harbaum

// VGA controller generating 160x100 pixles. The VGA mode ised is 640x400
// combining every 4 row and column

// http://tinyvga.com/vga-timing/640x400@70Hz

module vga (
   // pixel clock
   input  pclk,
	
	// Pla2 interface
	input [7:0] data,
	output [18:0] addr_pixel,
	
	// enable/disable scanlines
	input scanlines,
	
	// output to VGA screen
   output reg	hs,
   output reg 	vs,
   output [5:0] r,
   output [5:0] g,
   output [5:0] b
);
					
// 640x480@60HZ VESA according to  http://tinyvga.com/vga-timing/640x480@60Hz
parameter H   = 640;    // width of visible area
parameter HFP = 16;     // unused time before hsync
parameter HS  = 96;     // width of hsync
parameter HBP = 48;     // unused time after hsync

parameter V   = 480;    // height of visible area
parameter VFP = 10;     // unused time before vsync
parameter VS  = 2;      // width of vsync
parameter VBP = 33;     // unused time after vsync

reg[9:0]  h_cnt;        // horizontal pixel counter
reg[9:0]  v_cnt;        // vertical pixel counter

// both counters count from the begin of the visible area

// horizontal pixel counter
always@(posedge pclk) begin
	if(h_cnt==H+HFP+HS+HBP-1)   h_cnt <= 10'd0;
	else                        h_cnt <= h_cnt + 10'd1;

        // generate negative hsync signal
	if(h_cnt == H+HFP)    hs <= 1'b0;
	if(h_cnt == H+HFP+HS) hs <= 1'b1;
end

// veritical pixel counter
always@(posedge pclk) begin
        // the vertical counter is processed at the begin of each hsync
	if(h_cnt == H+HFP) begin
		if(v_cnt==VS+VBP+V+VFP-1)  v_cnt <= 10'd0; 
		else								v_cnt <= v_cnt + 10'd1;

               // generate positive vsync signal
 		if(v_cnt == V+VFP)    vs <= 1'b1;
		if(v_cnt == V+VFP+VS) vs <= 1'b0;
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
		pixel <= data;
	end else begin
		if(h_cnt == H+HFP) begin
			// the video counter is reset at the begin of the vsync
			if(v_cnt == V+VFP)
				video_counter <= 19'd0;
		end
			
		pixel <= 8'h00;   // color outside visible area: black
	end
end

// split the 8 rgb bits into the three base colors. Every second line is
// darker when scanlines are enabled
wire scanline = scanlines && v_cnt[0];
assign r = (!scanline)?{ pixel[5:4], 4'b0000 }:{ 1'b0, pixel[5:4], 3'b000 };
assign g = (!scanline)?{ pixel[3:2], 4'b0000 }:{ 1'b0, pixel[3:2], 3'b000 };
assign b = (!scanline)?{ pixel[1:0], 4'b0000 }:{ 1'b0, pixel[1:0], 3'b000 };

assign addr_pixel = video_counter;

endmodule