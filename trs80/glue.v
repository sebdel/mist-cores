module glue(
	input clock,
	input reset_n,
	
	// CPU interface
	input cpu_mreq_n,
	input cpu_wr_n,
	input [15:0] cpu_addr,
	
	input [7:0] ram_dout,
	input [7:0] rom_dout,
	input [7:0] vram_dout,
	input [7:0] keyboard_dout,

	// outputs
	output glue_reset_n,
	output glue_write_n,
	output [7:0] glue_dout,

	// Chip selects (CS are active low)
	output ram_cs_n,
	output rom_cs_n,
	output vram_cs_n,
	output led_cs_n,
	output keyboard_cs_n

);

// sync reset_n
reg reset_n_i;
assign glue_reset_n = reset_n_i;

always @(posedge clock) begin
	if (reset_n == 0)
		reset_n_i <= 1'b0;
	else
		reset_n_i <= 1'b1;
end

// Beware, everything is active low here; make sure CPU can't write to ROM
assign glue_write_n = cpu_mreq_n || cpu_wr_n || !rom_cs_n;

// $0000-$0FFF : ROM (4KB)
assign rom_cs_n = !(cpu_addr[15:12] == 4'b0000);

// $3C00-$3FFF : VRAM (1KB)
assign vram_cs_n = !(cpu_addr[15:10] == 6'b001111);

// $4000-$47FF : RAM (2KB)
assign ram_cs_n = !(cpu_addr[15:11] == 5'b01000);

// $3800-3BFF : Keyboard
assign keyboard_cs_n = !(cpu_addr[15:10] == 6'b001110);

assign glue_dout = !ram_cs_n ? ram_dout :
						 !rom_cs_n ? rom_dout :
						 !vram_cs_n ? vram_dout :
						 !keyboard_cs_n ? keyboard_dout :
						 8'b1111_1111;

endmodule
