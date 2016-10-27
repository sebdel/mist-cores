// trs80.v
//
// TRS-80 Model I
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
									  
module trs80 (
   input [1:0]	CLOCK_27,
   
	// Audio output
   output 			AUDIO_L,
   output 	 		AUDIO_R,
	
	// SDRAM interface
	output        	SDRAM_nCS, 		// SDRAM Chip Select
	
   // SPI interface to arm io controller
   output		 SPI_DO,
	input        SPI_DI,
   input        SPI_SCK,
   input 		 SPI_SS2,
   input 		 SPI_SS3,
   input 		 SPI_SS4,
	input        CONF_DATA0, 

	// VGA interface
	output 		 VGA_HS,
   output 	 	 VGA_VS,
   output [5:0] VGA_R,
   output [5:0] VGA_G,
   output [5:0] VGA_B
);

// the configuration string is returned to the io controller to allow
// it to control the menu on the OSD 
parameter CONF_STR = {
        "TRS80;;",
        "O1,Scanlines,On,Off;",
        "T2,Reset"
};

parameter CONF_STR_LEN = 7+20+8;

assign SDRAM_nCS = 1'b1;	// deactivate SDRAM

// the status register is controlled by the on screen display (OSD)
wire [7:0] status;
wire arm_reset = status[0];
wire osd_scanlines = !status[1];
wire osd_reset = status[2];

// include user_io module for arm controller communication
wire ps2_kbd_clk, ps2_kbd_data;
wire scandoubler_disable;

user_io #(.STRLEN(CONF_STR_LEN)) user_io ( 
		.conf_str   ( CONF_STR   ),

		.SPI_SCK    ( SPI_SCK    ),
      .CONF_DATA0 ( CONF_DATA0 ),
      .SPI_DO     ( SPI_DO     ),
      .SPI_DI     ( SPI_DI     ),

		.status     ( status     ),
		.scandoubler_disable ( scandoubler_disable ),
		
		// ps2 kbd interface
		.ps2_clk        ( ps2_clock      ),
		.ps2_kbd_clk    ( ps2_kbd_clk    ),
		.ps2_kbd_data   ( ps2_kbd_data   )
);

// Scandoubler
wire [5:0] sd_r, sd_g, sd_b;
wire sd_hs, sd_vs;

scandoubler scandoubler (
	.clk_in        ( pixel_clock   ),
	.clk_out       ( vga_clock     ),
   .scanlines     ( osd_scanlines ),
  
	.hs_in          ( video_hs     ),
	.vs_in          ( video_vs     ),
	.r_in           ( video_r		 ),
	.g_in           ( video_g		 ),
	.b_in           ( video_b		 ),

	.hs_out         ( sd_hs        ),
	.vs_out         ( sd_vs        ),
	.r_out          ( sd_r         ),
	.g_out          ( sd_g         ),
	.b_out          ( sd_b         )
);

assign VGA_HS = scandoubler_disable ? !(video_hs ^ video_vs) : sd_hs;
assign VGA_VS = scandoubler_disable ? 1'b1 : sd_vs;

wire osd_clk = scandoubler_disable ? pixel_clock : vga_clock;

// Feed scan-doubled or normal signal into OSD
wire osd_hs = scandoubler_disable ? video_hs : sd_hs;
wire osd_vs = scandoubler_disable ? video_vs : sd_vs;
wire [5:0] osd_r = scandoubler_disable ? video_r : sd_r;
wire [5:0] osd_g = scandoubler_disable ? video_g : sd_g;
wire [5:0] osd_b = scandoubler_disable ? video_b : sd_b;

// include the on screen display
osd #(10,0,4) osd (
   .pclk       ( osd_clk      ),

   // spi for OSD
   .sdi        ( SPI_DI       ),
   .sck        ( SPI_SCK      ),
   .ss         ( SPI_SS3      ),

   .red_in     ( osd_r        ),
   .green_in   ( osd_g        ),
   .blue_in    ( osd_b        ),
   .hs_in      ( osd_hs       ),
   .vs_in      ( osd_vs       ),

   .red_out    ( VGA_R        ),
   .green_out  ( VGA_G        ),
   .blue_out   ( VGA_B        )
);
                          
// include VGA controller
wire [5:0] video_r, video_g, video_b;
wire video_hs, video_vs;
wire [18:0] addr_pixel;
wire [7:0] data_pixel;

video video (
	.clock			( pixel_clock ),
	.reset_n			( glue_reset_n ),
	.vram_addr		( vram_b_addr ),
	.vram_data		( vram_b_dout ),
	
	// video output
	.video_hs    	( video_hs          ),
	.video_vs    	( video_vs          ),
	.video_r     	( video_r           ),
	.video_g     	( video_g           ),
	.video_b     	( video_b           )
);

// Include Z80 CPU
//
// The CPU is kept in reset for further 256 cycles after the PLL is
// generating stable clocks to make sure things like the SDRAM have
// some time to initialize
// status 0 is arm controller power up reset, status 2 is reset entry in OSD
reg [7:0] cpu_reset_cnt = 8'h00;
wire cpu_reset = (cpu_reset_cnt != 255);
always @(posedge cpu_clock) begin
	if(!pll_locked || arm_reset || osd_reset || dio_download) begin
		cpu_reset_cnt <= 8'd0;
	end else 
		if(cpu_reset_cnt != 255)
			cpu_reset_cnt <= cpu_reset_cnt + 8'd1;
end

always @(negedge dio_download) begin
	rom_loaded <= 1'b1;
end			

// CPU control signals
wire [15:0] cpu_addr;
wire [7:0] cpu_din;
wire [7:0] cpu_dout;
wire cpu_rd_n;
wire cpu_wr_n;
wire cpu_mreq_n;
wire cpu_m1_n;
wire cpu_iorq_n;

T80s T80s (
	.RESET_n  ( !cpu_reset    ),
	.CLK_n    ( cpu_clock     ),
	.WAIT_n   ( 1'b1          ),
	.INT_n    ( 1'b1          ),
	.NMI_n    ( 1'b1          ),
	.BUSRQ_n  ( 1'b1          ),
	.IORQ_n   ( cpu_iorq_n    ),
	.M1_n		 ( cpu_m1_n      ),
	.MREQ_n   ( cpu_mreq_n    ),
	.RD_n     ( cpu_rd_n      ), 
	.WR_n     ( cpu_wr_n      ),
	.A        ( cpu_addr      ),
	.DI       ( cpu_din       ),
	.DO       ( cpu_dout      )
);

// 16K RAM
wire ram_clock;
wire [7:0] ram_dout;

ram4k ram4k(
	.address	( cpu_addr[13:0]	),
	.clock	( ram_clock			),
	.data		( cpu_dout			),
	.wren		( !glue_write_n && !ram_cs_n ),
	.rden		( glue_write_n && !ram_cs_n  ),
	.q			( ram_dout			)
);

// 12.2K ROM (level2)
wire [7:0] rom_dout;

rom4k rom4k(
	.address	( cpu_addr[13:0]	),
	.clock	( ram_clock			),
	.q			( rom_dout 			)
);

// ROM download helper (unused)
wire dio_download;
wire [24:0] dio_addr;
wire [7:0] dio_data;
wire dio_write;
reg rom_loaded = 0;

data_io data_io (
	// io controller spi interface
   .sck	( SPI_SCK ),
   .ss	( SPI_SS2 ),
   .sdi	( SPI_DI  ),

	.downloading ( dio_download ),  // signal indicating an active rom download
	         
   // external ram interface
   .clk   ( cpu_clock ),
   .wr    ( dio_write ),
   .addr  ( dio_addr  ),
   .data  ( dio_data  )
);

// GLUE
wire ram_cs_n, vram_cs_n, rom_cs_n;

glue glue (
	.clock		( cpu_clock		),
	.reset_n 	( !cpu_reset	),
	
	// CPU interface
	.cpu_mreq_n	( cpu_mreq_n	),
	.cpu_wr_n	( cpu_wr_n		),
	.cpu_addr	( cpu_addr		),
	
	.ram_dout	( ram_dout		),
	.rom_dout	( rom_dout		),
	.vram_dout	( vram_dout		),
	.keyboard_dout	( keyboard_dout	),

	// outputs
	.glue_reset_n	( glue_reset_n		),
	.glue_write_n	( glue_write_n		),
	.glue_dout		( cpu_din			),

	// Chip selects (CS are active low)
	.ram_cs_n		( ram_cs_n			),
	.rom_cs_n		( rom_cs_n			),
	.vram_cs_n		( vram_cs_n			),
	.keyboard_cs_n	( keyboard_cs_n	)
);

// 1K VRAM
wire [7:0] vram_dout;
wire [9:0] vram_b_addr;
wire [7:0] vram_b_dout;

vram vram (
	.clock_a   ( cpu_clock ),
	.address_a ( cpu_addr[9:0] ),
	.wren_a    ( !glue_write_n && !vram_cs_n  ),
	.data_a    ( cpu_dout  ),
	.q_a       ( vram_dout ),

	.clock_b   ( pixel_clock  ),
	.address_b ( vram_b_addr  ),
	.wren_b    ( 1'b0         ),
	.q_b       ( vram_b_dout  )
);

// Keyboard
wire [7:0] keyboard_dout;

PS2_to_matrix PS2_to_matrix (
    .clk   ( cpu_clock ),
    .reset ( !glue_reset_n ),

	 // TRS80 interfaceseb
	 
    .sfrdatao ( keyboard_dout ),
    .addr     ( cpu_addr[7:0] ),

	 // PS2 interface
    .psdatai ( keyboard_datao ),
    .psint   ( keyboard_int  )
);


// PS2 Keyboard controller
wire [7:0] keyboard_datao;
wire keyboard_int;

keyboard keyboard ( 
    .clk   ( cpu_clock ),
    .reset ( !glue_reset_n ),

	// ps2 interface	
	.ps2_clk    ( ps2_kbd_clk  ),
	.ps2_data   ( ps2_kbd_data ),	

	// outputs
	.datao ( keyboard_datao ),
	.int   ( keyboard_int   )
);

// counter to generate various clocks from the 25MHz
reg [24:0] clk_div;
always @(posedge clock_25mhz)
	clk_div <= clk_div + 25'b1;

// vga clock @25MHz
wire vga_clock = clock_25mhz;
// pixel clock @12.5MHz
wire pixel_clock = clk_div[0];
// ps2 @12KHz
wire ps2_clock = clk_div[10];
// 3Hz for debug prurpose
wire slow_clock = clk_div[22];

// divide 32Mhz clock down to 4MHz
reg [24:0] clk32m_div;	
always @(posedge ram_clock)
	clk32m_div <= clk32m_div + 25'b1;

wire cpu_clock = clk32m_div[2];	// 4MHz	
		  
// PLL to generate 100MHz system clock, 4MHz cpu clock & 32MHz SDRAM clock
pll pll (
	 .inclk0 ( CLOCK_27[0]   ),
	 .locked ( pll_locked    ),         // PLL is running stable
	 .c0     ( clock_25mhz  ),   			// system clock@25MHz
	 .c1     ( ram_clock     ),			// RAM clock@32MHz
	 .c2     ( SDRAM_CLK     )         	// slightly phase shifted 32MHz
);

endmodule
