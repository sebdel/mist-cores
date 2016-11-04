// VGA controller

// (c) 2016 Sebastien Delestaing
// (c) 2015 Till Harbaum

// VGA controller generating 320x240 pixels. The VGA mode used is 640x480,
// combining every 2 row and column

// http://tinyvga.com/vga-timing/640x480@60Hz

module vga (
   // reset and pixel clock
   input  reset,
   input  pclk,
	
	// CPU interface (write only!)
	input  cpu_clk,
	input  cpu_wr,
	input [14:0] cpu_addr,
	input [7:0] cpu_data,

	// enable/disable scanlines
	input scanlines,
	
	// output to VGA screen
   output reg	hs,
   output reg 	vs,
   output [5:0] r,
   output [5:0] g,
   output [5:0] b
);
					
// 640x480 60HZ VESA according to  http://tinyvga.com/vga-timing/640x480@60Hz
/*
Scanline part		Pixels		Time [µs]
Visible area		640		25.422045680238
Front porch			16			0.63555114200596
Sync pulse			96			3.8133068520357
Back porch			48			1.9066534260179
Whole line			800		31.777557100298

Vertical timing (frame)
Frame part			Lines			Time [ms]
Visible area		480		15.253227408143
Front porch			10			0.31777557100298
Sync pulse			2			0.063555114200596
Back porch			33			1.0486593843098
Whole frame			525		16.683217477656
*/
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

// both counters count from the begin of the visibla area

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

// 19200 bytes of internal video memory for 320*240 pixels at 2 bits
reg [7:0] vmem [160*120-1:0];

reg [14:0] video_counter;
reg [7:0] pixel;
reg dark_pix;

// hardware cursor (sprite)
reg [7:0] cursor_mask[8];
reg [7:0] cursor_data[8];
reg [7:0] cursor_col_0, cursor_col_1;
reg [3:0] cursor_hot_x, cursor_hot_y;
reg [7:0] cursor_x_low;
reg [8:0] cursor_x;
reg [7:0] cursor_y;

// VGA controller interface
// 
// $0000-$4AFF: VRAM
// $7EFB: CURSOR_COL_0
// $7EFC: CURSOR_COL_1
// $7EFD: CURSOR_HOT_POINT {4'hX,4'hY}
// $7EFE: CURSOR_X_LOW
// $7EFF: CURSOR_X_HIGH
// $7F00: CURSOR_Y
// $7F10-$7F17: CURSOR_DATA
// $7F18-$7F1F: CURSOR_MASK

always @(posedge cpu_clk) begin
	if(reset)
		cursor_x <= 9'd320;   // cursor outside visible area
	else begin
		if(cpu_wr) begin
			if(cpu_addr < 'h4b00)
				vmem[cpu_addr] <= cpu_data;
			else if(cpu_addr == 15'h7efb)
				cursor_col_0 <= cpu_data;
			else if(cpu_addr == 15'h7efc)
				cursor_col_1 <= cpu_data;
			else if(cpu_addr == 15'h7efd) begin
				cursor_hot_x <= cpu_data[7:4];
				cursor_hot_y <= cpu_data[3:0];
			end else if(cpu_addr == 15'h7efe)
				cursor_x_low <= cpu_data;
			else if(cpu_addr == 15'h7eff)
				cursor_x <= { cpu_data[0], cursor_x_low };
			else if(cpu_addr == 15'h7f00)
				cursor_y <= cpu_data;
			else if((cpu_addr >= 15'h7f10) && (cpu_addr < 15'h7f18))
				cursor_data[cpu_addr[2:0]] <= cpu_data;
			else if((cpu_addr >= 15'h7f18) && (cpu_addr < 15'h7f20))
				cursor_mask[cpu_addr[2:0]] <= cpu_data;
		end
	end
end


// add hot spot info to cursor position 
wire [8:0] cursor_map_x = cursor_x - { 5'h0, cursor_hot_x } /* synthesis keep */;
wire [7:0] cursor_map_y = cursor_y - { 4'h0, cursor_hot_y } /* synthesis keep */;
wire [7:0] cursor_data_byte = cursor_data[v_cnt[8:1] - cursor_map_y];
wire cursor_data_pix = cursor_data_byte[cursor_map_x - h_cnt[9:1] - 9'd1];
wire [7:0] cursor_mask_byte = cursor_mask[v_cnt[8:1] - cursor_map_y];
wire cursor_mask_pix = cursor_mask_byte[cursor_map_x - h_cnt[9:1] - 9'd1];

wire [7:0] vmem_byte = vmem[video_counter];

wire [15:0] line_length = 15'd80;

// Fixed color palette
reg [7:0] palette[3:0];
initial begin
	palette[0] = 8'b000_000_00;
	palette[1] = 8'b010_010_01;
	palette[2] = 8'b100_100_10;
	palette[3] = 8'b111_111_11;
end

// read VRAM for video generation
always@(posedge pclk) begin
   // The video counter is being reset at the begin of each vsync.
   // Otherwise it's increased every fourth pixel in the visible area.
   // At the end of the first three of four lines the counter is
   // decreased by the total line length to display the same contents
   // for four lines so 100 different lines are displayed on the 400
   // VGA lines.

   // visible area?
	if((v_cnt < V) && (h_cnt < H)) begin
		// increase video counter every 8 VGA pixels (i.e. every 4 pixels)
		if(h_cnt[2:0] == 3'd7)
			video_counter <= video_counter + 15'd1;

		case(h_cnt[2:1])
			2'b00: pixel <= palette[vmem_byte[1:0]];
			2'b01: pixel <= palette[vmem_byte[3:2]];
			2'b10: pixel <= palette[vmem_byte[5:4]];
			2'b11: pixel <= palette[vmem_byte[7:6]];
		endcase

		dark_pix <= 1'b0;
		
		// draw cursor
		if(((cursor_map_y + 8'd8) > v_cnt[8:1]) && 
			 (cursor_map_y <= v_cnt[8:1]) &&
			((cursor_map_x + 9'd8) > h_cnt[9:1]) && 
			 (cursor_map_x <= h_cnt[9:1])  ) begin

				if(cursor_mask_pix) begin
					pixel <= cursor_data_pix ? cursor_col_1 : cursor_col_0;
				end else if(cursor_data_pix) begin
					dark_pix <= 1'b1;
				end
		end
	end else begin
		// video counter is manipulated at the end of a line outside
	   // the visible area
		if(h_cnt == H+HFP) begin
			// the video counter is reset at the begin of the vsync
			if(v_cnt == V+VFP)
				video_counter <= 15'd0;
			// every even line is repeated to get a vertical resolution of 240 lines
			else if((v_cnt < V) && (v_cnt[0] != 1'b1))
				video_counter <= video_counter - line_length;
		end
		
		pixel <= 8'h00;   // color outside visible area: black
		dark_pix <= 1'b0;
	end
end

// split the 8 rgb bits into the three base colors. Every second line is
// darker when scanlines are enabled
wire dark = (scanlines && v_cnt[0]) || dark_pix;
wire [5:0] r_col = { pixel[7:5], pixel[7:5] };
wire [5:0] g_col = { pixel[4:2], pixel[4:2] };
wire [5:0] b_col = { pixel[1:0], pixel[1:0], pixel[1:0] };

assign r = (!dark)?{ r_col }:{ 1'b0, r_col[5:1] };
assign g = (!dark)?{ g_col }:{ 1'b0, g_col[5:1] };
assign b = (!dark)?{ b_col }:{ 1'b0, b_col[5:1] };

endmodule
