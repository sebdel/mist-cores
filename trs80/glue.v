// glue.v
//
// TRS-80 Model I 
// GLUE
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

// This implements the following memory map,  taken from this page:
// http://www.classiccmp.org/cpmarchives/trs80/mirrors/kjsl/www.kjsl.com/trs80/mod1intern.html
//
// Address (hex) 	Description
//
// 0000-2FFF 	Level II ROM
// 3000-37DF 	Unused
// 37E0-37FF 	Memory Mapped I/O
// 3800-38FF 	Keyboard map
// 3900-3BFF 	(Keyboard 'shadow'ed here)
// 3C00-3FFF 	1kb Video RAM
// 4000-41FF 	RAM used by the ROM routines
// 4200-7FFF 	Usable RAM in a 16K machine
// 8000-BFFF 	Additional RAM in a 32K machine
// C000-FFFF 	Still more in a 48K machine
//
// Port				Description
//
// E8-EB			Serial
// FF				Cassette interface	

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

// Beware, everything is active low here
assign glue_write_n = cpu_mreq_n || cpu_wr_n;

// $0000-$2FFF : ROM (12KB)
assign rom_cs_n = !((cpu_addr[15:14] == 2'b00) && !(cpu_addr[13] & cpu_addr[12] == 1'b1));


// $3C00-$3FFF : VRAM (1KB)
assign vram_cs_n = !(cpu_addr[15:10] == 6'b001111);

// $4000-$4FFF : RAM (16KB)
assign ram_cs_n = !(cpu_addr[15:14] == 2'b01);

// 37E0-37FF 	Memory Mapped I/O
// $3800-3BFF : Keyboard
assign keyboard_cs_n = !(cpu_addr[15:10] == 6'b001110);

assign glue_dout = !ram_cs_n ? ram_dout :
						 !rom_cs_n ? rom_dout :
						 !vram_cs_n ? vram_dout :
						 !keyboard_cs_n ? keyboard_dout :
						 8'b1111_1111;

endmodule
