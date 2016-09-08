// Aquarius for the MiST
// (c) 2016 Sebastien Delestaing
									  
module Pads (
	input       clk,
	input       reset,
	input [7:0] joy0_in,
	input [7:0] joy1_in,

	output reg [7:0] pad0_out,
	output reg [7:0] pad1_out
);

always @(posedge clk) begin
	if ( reset ) begin

		pad0_out <= 8'hff;
		pad1_out <= 8'hff;
	end else begin
	
		pad0_out <= (8'hfd | {8{~joy0_in[0]}}) &	// right -> P1
						(8'hf7 | {8{~joy0_in[1]}}) &	// left  -> P9
						(8'hfe | {8{~joy0_in[2]}}) &	// down  -> P5
						(8'hfb | {8{~joy0_in[3]}}) &	// up    -> P13
						(8'hbf | {8{~joy0_in[4]}}) &	// A     -> K1
						(8'hdf | {8{~joy0_in[5]}}) &	// B     -> K4
						(8'h5f | {8{~joy0_in[6]}}) &	// X     -> K3
						(8'h7b | {8{~joy0_in[7]}});  	// Y     -> K2
						
		pad1_out <= (8'hfd | {8{~joy1_in[0]}}) &	// right -> P1
						(8'hf7 | {8{~joy1_in[1]}}) &	// left  -> P9
						(8'hfe | {8{~joy1_in[2]}}) &	// down  -> P5
						(8'hfb | {8{~joy1_in[3]}}) &	// up    -> P13
						(8'hbf | {8{~joy1_in[4]}}) &	// A     -> K1
						(8'hdf | {8{~joy1_in[5]}}) &	// B     -> K4
						(8'h5f | {8{~joy1_in[6]}}) &	// X     -> K3
						(8'h7b | {8{~joy1_in[7]}});  	// Y     -> K2
	 
	end
end

endmodule

