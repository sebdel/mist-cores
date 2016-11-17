module keyboard ( 
	input clk,
	input reset,

	// ps2 interface	
	input ps2_clk,
	input ps2_data,
	
	// outputs
	output reg [7:0] datao,
	output interrupt
);

wire [7:0] byte;
wire valid;
wire error;

reg [3:0] int_counter;
assign interrupt = (int_counter != 0);

always @(posedge clk) begin
	if(reset) begin
		datao <= 8'h00;
		int_counter <= 4'd0;
	end else
		// ps2 decoder has received a valid byte
		if(valid) begin
				// send it
				int_counter <= 4'd13;
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
