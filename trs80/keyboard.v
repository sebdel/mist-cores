// keyboard.v
//
// TRS-80 Model I
// PS2 interface passthrough
// Note: that doesn't do much, we could get rid of this
//
// io controller writable ram for the MiST board
// http://code.google.com/p/mist-board/
//
// ZX Spectrum adapted version
//
// Copyright (c) 2015 Till Harbaum <till@harbaum.org>
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

module keyboard ( 
	input clk,
	input reset,

	// ps2 interface	
	input ps2_clk,
	input ps2_data,
	
	// outputs
	output reg [7:0] datao,
	output int
);

wire [7:0] byte;
wire valid;
wire error;

reg [3:0] int_counter;
assign int = (int_counter != 0);

always @(posedge clk) begin
	if(reset) begin
		datao <= 8'h00;
		int_counter <= 4'd0;
	end else
		// ps2 decoder has received a valid byte
		if(valid) begin
				// send it
				int_counter <= 4'd1;
				datao <= byte;
		end else
			if (int_counter > 0)
				int_counter <= int_counter - 4'd1;

end

// the ps2 decoder has been taken from the zx spectrum core
ps2_intf ps2_keyboard (
	.CLK		 ( clk             ),
	.nRESET	 ( !reset          ),
	
	// PS/2 interface
	.PS2_CLK  ( ps2_clk         ),
	.PS2_DATA ( ps2_data        ),
	
	// Byte-wide data interface - only valid for one clock
	// so must be latched externally if required
	.DATA		  ( byte   ),
	.VALID	  ( valid  ),
	.ERROR	  ( error  )
);

endmodule
