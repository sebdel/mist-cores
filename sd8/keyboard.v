module keyboard ( 
	input clk,
	input reset,

	// ps2 interface	
	input ps2_clk,
	input ps2_data,
	
	// decodes keys
	output reg [7:0] keys
);

wire [7:0] byte;
wire valid;
wire error;

reg key_released;
reg key_extended;

always @(posedge clk) begin
	if(reset) begin
		keys <= 8'h00;
      key_released <= 1'b0;
      key_extended <= 1'b0;
	end else begin
		// ps2 decoder has received a valid byte
		if(valid) begin
			if(byte == 8'he0) 
				// extended key code
            key_extended <= 1'b1;
         else if(byte == 8'hf0)
				// release code
            key_released <= 1'b1;
         else begin
				key_extended <= 1'b0;
				key_released <= 1'b0;
				
				case(byte)
					8'h1D:  keys[0] <= !key_released;   // W
					8'h22:  keys[1] <= !key_released;   // X
					8'h21:  keys[2] <= !key_released;   // C
					8'h2A:  keys[3] <= !key_released;   // V
					8'h32:  keys[4] <= !key_released;   // B
					8'h31:  keys[5] <= !key_released;   // N
					8'h41:  keys[6] <= !key_released;   // ,
					8'h4C:  keys[7] <= !key_released;   // ;
				endcase
			end
		end
	end
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
