module led(
	input clock,
	input led_cs_n,
	input led_we,
	input led_oe
	
	input led_din,
	
	output led_dout
);

reg state;

always @(posedge clock) begin

	if (led_cs_n == 0) begin
		
	end
	
end

endmodule

