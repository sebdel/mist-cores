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
	
	 if ( joy0_in[0] ) 		// right
	  pad0_out <= 8'hfd;		// P1
	 else if ( joy0_in[1] )	// left
	  pad0_out <= 8'hf7;		// P9
	 else if ( joy0_in[2] )	// down
	  pad0_out <= 8'hfe;		// P5
	 else if ( joy0_in[3] )	// up
	  pad0_out <= 8'hfb;		// P13
	 else if ( joy0_in[4] )	// button1 (A)
	  pad0_out <= 8'hbf;		// K1
	 else if ( joy0_in[5] )	// button2 (B)
	  pad0_out <= 8'h7b;		// K2
	 else if ( joy0_in[6] )	// button3 (X)
	  pad0_out <= 8'h5f;		// K3
	 else if ( joy0_in[7] )	// button4 (Y)
	  pad0_out <= 8'hdf;		// K4	  
	 else
	  pad0_out <= 8'hff;
	 
	 if ( joy1_in[0] ) 		// right
	  pad1_out <= 8'hfd;		// P1
	 else if ( joy1_in[1] )	// left
	  pad1_out <= 8'hf7;		// P9
	 else if ( joy1_in[2] )	// down
	  pad1_out <= 8'hfe;		// P5
	 else if ( joy1_in[3] )	// up
	  pad1_out <= 8'hfb;		// P13
	 else if ( joy1_in[4] )	// button1 (A)
	  pad1_out <= 8'hbf;		// K1
	 else if ( joy1_in[5] )	// button2 (B)
	  pad1_out <= 8'h7b;		// K2
	 else if ( joy1_in[6] )	// button3 (X)
	  pad1_out <= 8'h5f;		// K3
	 else if ( joy1_in[7] )	// button4 (Y)
	  pad1_out <= 8'hdf;		// K4	  
	 else
	  pad1_out <= 8'hff;
	 
	end
end

endmodule

