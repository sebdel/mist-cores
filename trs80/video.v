// video.v
//
// TRS-80 Model I
// Video controller
//
// (c) 2016 Sebastien Delestaing
//
// This source file is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This source file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

module video(
	
	input clock,
	input reset_n,

	// VRAM interface
	output [9:0] vram_addr,
	input [7:0] vram_data,
	
	output [5:0] video_r,
	output [5:0] video_g,
	output [5:0] video_b,
	output reg video_vs,
	output reg video_hs
);

reg [6:0] Hor_Cnt; // Horizontal counter
reg [4:0] Ver_Cnt; // Vertical counter

reg [2:0] ChrC_Cnt;	// Character column counter
reg [3:0] ChrR_Cnt;	// Character row counter

wire [7:0] character = vram_data;
assign vram_addr = {Ver_Cnt[3:0], Hor_Cnt[5:0]};

// Generate character adress
always @(posedge clock) begin
	if (reset_n == 0) begin
		ChrC_Cnt <= 3'd0;
		Hor_Cnt <= 7'd0;
		ChrR_Cnt <= 4'd0;
		Ver_Cnt <= 5'd0;
	end else
		if (ChrC_Cnt == 5) begin
			ChrC_Cnt <= 3'd0;
			if (Hor_Cnt == 'd111) begin
				Hor_Cnt <= 7'd0;
				if (ChrR_Cnt == 11) begin
					ChrR_Cnt <= 4'd0;
					if (Ver_Cnt == 25)
						Ver_Cnt <= 5'd0;
					else
						Ver_Cnt <= Ver_Cnt + 1;
						
				end else
					ChrR_Cnt <= ChrR_Cnt + 1;
					
			end else
				Hor_Cnt <= Hor_Cnt + 1;
		end else
			ChrC_Cnt <= ChrC_Cnt + 1;

end

// Get character
wire [10:0] Chr_Addr = {character[6:0],ChrR_Cnt[3:0]};
wire [7:0] Chr_Data;

trs_char trs_char(
	.A ( Chr_Addr ),
	.D ( Chr_Data )
);

reg [5:0] Shift;
reg Video;		// Monochrome signal
assign video_r = {6{Video}};
assign video_g = video_r;
assign video_b = video_r;

// Video shift register
always @(posedge clock) begin

	if (reset_n == 0) begin
		Shift <= 6'd0;
		Video <= 1'b0;
	end else begin
		if (ChrC_Cnt == 1)
			if (!Hor_Cnt[6] && !Ver_Cnt[4])
				if (character[7])	// pseudo graphics mode
					if (ChrR_Cnt < 4) begin
						Shift[5:3] <= {3{character[0]}};
						Shift[2:0] <= {3{character[1]}};
					end else if (ChrR_Cnt < 8) begin
						Shift[5:3] <= {3{character[2]}};
						Shift[2:0] <= {3{character[3]}};
					end else begin
						Shift[5:3] <= {3{character[4]}};
						Shift[2:0] <= {3{character[5]}};
					end
				else begin
					Shift[4:0] <= Chr_Data[7:3];
					Shift[5] <= 1'b0;
				end
			else
				Shift <= 6'd0;

		else begin
			Shift[5:1] <= Shift[4:0];
			Shift[0] <= 1'b0;
		end
		Video <= Shift[5];
	end
	
end

// Sync
always @(posedge clock) begin

	if (reset_n == 0) begin
			video_hs <= 1'b0;
			video_vs <= 1'b0;
	end else begin
		// Hor_Cnt is 1774080/1747200Hz
		if (Hor_Cnt == 64 + 7 * 3)
			video_hs <= 1'b1;
		if (Hor_Cnt == 64 + 7 * 4)
			video_hs <= 1'b0;
		// ChrR_Cnt is 15840/15600Hz
		// Ver_Cnt is 1320/1300Hz
		if (Ver_Cnt == 20) begin
			if (ChrR_Cnt == 0)
				video_vs <= 1'b1;
			if (ChrR_Cnt == 7)
				video_vs <= 1'b0;
		end
	end

end


endmodule
