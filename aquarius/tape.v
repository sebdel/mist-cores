// tape.v

module tape(
	input clk, 
	input tape_clk,	// 1666,666 Hz (10KHz/6)
	input reset,
	
	input [7:0] data, 
	input [15:0] length,
	output reg [15:0] addr,
	output reg req,
	
	input [1:0] ctrl,
	output reg out
);

reg [1:0] state = 0;
reg [10:0] byte_reg;
reg [15:0] byte_cnt;
reg [3:0] bit_cnt;
reg [3:0] tape_state;


  
always @(posedge clk) begin
	if (reset) begin
		state <= 0;
		req <= 0;
		addr <= 0;
		out <= 0;
	end else begin
		case(state)
		// Wait for ctrl = PLAY
		0:	if (ctrl == 2'd1) begin
				state <= 1;
				req <= 1;
				byte_cnt <= length - 16'd1;
			end
		// Fetch byte to send
		1:	begin
				if (byte_cnt == 0) begin
					req <= 0;
					state <= 0;
				end else begin
					byte_reg <= { 1'b0, data, 2'b11 };
					byte_cnt <= byte_cnt - 16'd1;
					addr <= addr + 16'd1;
					bit_cnt <= 10;
					state <= 2; // START sending
				end
			end
		// Send byte
		2: begin
				if (bit_cnt == 0) begin
					state <= 1; // Fetch next byte
				end else begin
					bit_cnt <= bit_cnt - 10'd1;
					if (byte_reg[bit_cnt]) begin					
						tape_state <= 4'd0;
						state <= 3;
					end else	begin
						state <= 4;
					end	
				end	
         end
		// Send Mark. A mark is represented by 2 full cycles of square wave with period 0.6ms.
		3: if (tape_clk) begin
				tape_state <= tape_state + 4'd1;
				case(tape_state)
				0:	out <= 1'b1;
				1:	out <= 1'b0;
				2:	out <= 1'b1;
				3:	out <= 1'b0;
				4: state <= 2;
				endcase
			end
		// Send Space. A space also has 2 cycles but with a period of 1.2ms.
		4: if (tape_clk) begin
				tape_state <= tape_state + 4'd1;
				case(tape_state)
				0,1:	out <= 1'b1;
				2,3:	out <= 1'b0;
				4,5:	out <= 1'b1;
				6,7:	out <= 1'b0;
				8: state <= 2;
				endcase
			end
		endcase
	end
end

endmodule
