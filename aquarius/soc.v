// Aquarius for the MiST
// (c) 2016 Sebastien Delestaing
									  
module soc (
   input [1:0]  CLOCK_27,
   
	// for debug
	output reg   LED,
	
	// Audio output
   output 			AUDIO_L,
   output 	 		AUDIO_R,
	
	// SDRAM interface
	inout [15:0]  	SDRAM_DQ, 		// SDRAM Data bus 16 Bits
	output [12:0] 	SDRAM_A, 		// SDRAM Address bus 13 Bits
	output        	SDRAM_DQML, 	// SDRAM Low-byte Data Mask
	output        	SDRAM_DQMH, 	// SDRAM High-byte Data Mask
	output        	SDRAM_nWE, 		// SDRAM Write Enable
	output       	SDRAM_nCAS, 	// SDRAM Column Address Strobe
	output        	SDRAM_nRAS, 	// SDRAM Row Address Strobe
	output        	SDRAM_nCS, 		// SDRAM Chip Select
	output [1:0]  	SDRAM_BA, 		// SDRAM Bank Address
	output 			SDRAM_CLK, 		// SDRAM Clock
	output        	SDRAM_CKE, 		// SDRAM Clock Enable
	
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

// clocks
wire pixel_clock;
wire clock_100mhz;
wire cpu_clock;

// the configuration string is returned to the io controller to allow
// it to control the menu on the OSD 
parameter CONF_STR = {
        "AQUARIUS;;",
        "O1,Scanlines,On,Off;",
        "T2,Reset"
};

parameter CONF_STR_LEN = 10+20+8;

// the status register is controlled by the on screen display (OSD)
wire [7:0] status;
// the MiST emulates a PS2 keyboard and mouse
wire ps2_kbd_clk, ps2_kbd_data;

// include user_io module for arm controller communication
user_io #(.STRLEN(CONF_STR_LEN)) user_io ( 
		.conf_str   ( CONF_STR   ),

		.SPI_CLK    ( SPI_SCK    ),
      .SPI_SS_IO  ( CONF_DATA0 ),
      .SPI_MISO   ( SPI_DO     ),
      .SPI_MOSI   ( SPI_DI     ),

		.status     ( status     ),
		
		// ps2 kbd interface
		.ps2_clk        ( ps2_clock      ),
		.ps2_kbd_clk    ( ps2_kbd_clk    ),
		.ps2_kbd_data   ( ps2_kbd_data   )
);

// include the on screen display
osd #(0,0,4) osd (
   .pclk       ( pixel_clock  ),

   // spi for OSD
   .sdi        ( SPI_DI       ),
   .sck        ( SPI_SCK      ),
   .ss         ( SPI_SS3      ),

   .red_in     ( video_r      ),
   .green_in   ( video_g      ),
   .blue_in    ( video_b      ),
   .hs_in      ( video_hs     ),
   .vs_in      ( video_vs     ),

   .red_out    ( VGA_R        ),
   .green_out  ( VGA_G        ),
   .blue_out   ( VGA_B        ),
   .hs_out     ( VGA_HS       ),
   .vs_out     ( VGA_VS       )
);
                          
// include VGA controller
wire [5:0] video_r, video_g, video_b;
wire video_hs, video_vs;
wire [18:0] addr_pixel;
wire [7:0] data_pixel;

vga vga (
	.pclk       ( pixel_clock ),	 
	.addr_pixel ( addr_pixel  ),
	.data       ( data_pixel  ),
	.scanlines  ( !status[1]  ),
	
	// video output as fed into the VGA outputs
	.hs    	( video_hs          ),
	.vs    	( video_vs          ),
	.r     	( video_r           ),
	.g     	( video_g           ),
	.b     	( video_b           )
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
	if ( dio_download )
		rom_loaded <= 1'b1;
	if(!pll_locked || status[0] || status[2] || dio_download)
		cpu_reset_cnt <= 8'd0;
	else 
		if(cpu_reset_cnt != 255)
			cpu_reset_cnt <= cpu_reset_cnt + 8'd1;
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

// include SDRAM (64k, because why not ?)
// control signals
wire ram_clock;
wire ram_rden, ram_wren;

// during ROM download, data_io writes to the ram. Otherwise it's the CPU.
wire [7:0] sdram_din = dio_download ? dio_data : extram_data;
wire [24:0] sdram_addr = dio_download ? { 2'b11, dio_addr[13:0] } : { 9'd0, cpu_addr[15:0] };
wire sdram_wr = dio_download ? dio_write : !ram_wren;
wire sdram_oe = dio_download ? 1'b1 : !ram_rden;

assign SDRAM_CKE = 1'b1;

sdram sdram (
	// interface to the MT48LC16M16 chip
   .sd_data        ( SDRAM_DQ                  ),
   .sd_addr        ( SDRAM_A                   ),
   .sd_dqm         ( {SDRAM_DQMH, SDRAM_DQML}  ),
   .sd_cs          ( SDRAM_nCS                 ),
   .sd_ba          ( SDRAM_BA                  ),
   .sd_we          ( SDRAM_nWE                 ),
   .sd_ras         ( SDRAM_nRAS                ),
   .sd_cas         ( SDRAM_nCAS                ),

   // system interface
   .clk            ( ram_clock                 ),
   .clkref         ( cpu_clock                 ),
   .init           ( !pll_locked               ),

   // cpu/chipset interface
   .din            ( sdram_din                 ),
   .addr           ( sdram_addr					  ),
   .we             ( sdram_wr 					  ),
   .oe         	 ( sdram_oe  					  ),
   .dout           ( extram_q              	  )
);

// include ROM download helper
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

// inclue AQUARIUS Pla1
wire video_we;
wire [7:0] extram_q;
wire [7:0] extram_data;
wire cass_in, cass_out;

Pla1 Pla1 (
    .CLK   ( cpu_clock ),
    .RST   ( cpu_reset ),
    .DATAO ( cpu_dout  ),
	 
    .DATAI    ( cpu_din  ),
    .ADDR     ( cpu_addr ),
    .MEMWR    ( !cpu_wr_n ), 
    .MEMRD    ( !cpu_rd_n ), 
    .IOWR     ( (!cpu_iorq_n && cpu_m1_n) && !cpu_wr_n ),
    .IORD     ( (!cpu_iorq_n && cpu_m1_n) && !cpu_rd_n ),

    .VIDEO_WE     ( video_we          ),
    .DATA_ROM     ( aquarius_rom_data ),
    .DATA_VIDEO   ( vram_dout         ),
    .DATA_ROMPACK ( extram_q          ),
    .ROM_EN       ( rom_loaded        ),

    .OE_EXT       ( ram_rden    ),
    .WE_EXT       ( ram_wren    ),
    .DATA_EXT_IN  ( extram_q    ),
    .DATA_EXT_OUT ( extram_data ),

    .KEY_VALUE ( key_value ),
	 .LED_OUT   ( LED       ),
    .CASS_OUT  ( cass_out  ),
    .CASS_IN   ( cass_in   ),
    .VSYNC     ( video_vs  )
);

// inclue AQUARIUS Pla2
wire [7:0] vd_in;
wire [7:0] vd_out;
wire [10:0] vd_addr;
wire vd_we;

Pla2 Pla2 (
    .CLK ( clock_100mhz ),
    .RST ( cpu_reset ),

    .VGA_CLK        ( pixel_clock ),
    .VGA_DATA       ( data_pixel  ),
    .VGA_ADDR_PIXEL ( addr_pixel  ),

    .ROM_DATA ( character_rom_data ),
    .ROM_ADDR ( character_rom_addr ),

	 .VD_IN   ( vd_in   ),
    .VD_OUT  ( vd_out  ),
    .VD_ADDR ( vd_addr ),
    .VD_WE   ( vd_we   )
);

// include aquarius rom (8k)
wire [7:0] aquarius_rom_data;

aquarius_rom aquarius_rom (
//diag_rom diag_rom (
	.clock   ( cpu_clock         ),
	.address ( cpu_addr[12:0]    ),
	.q       ( aquarius_rom_data )
);

// include character rom (2k)
wire [7:0] character_rom_data;
wire [10:0] character_rom_addr;

character_rom character_rom (
	.clock   ( clock_100mhz       ),
	.address ( character_rom_addr ),
	.q       ( character_rom_data )
);

// include vram (2k)
wire [7:0] vram_dout;

vram2k vram2k (
	.clock_a   ( cpu_clock ),
	.address_a ( cpu_addr[10:0] ),
	.wren_a    ( video_we  ),
	.data_a    ( cpu_dout  ),
	.q_a       ( vram_dout ),

	.clock_b   ( clock_100mhz ),
	.address_b ( vd_addr      ),
	.wren_b    ( vd_we        ),
	.data_b    ( vd_out       ),
	.q_b       ( vd_in        )
);

// include sound codec
wire speaker;
assign AUDIO_L = speaker;
assign AUDIO_R = speaker;

CodecDriver_DAC CodecDriver_DAC (
	.CLK ( cpu_clock   ),
   .RST ( cpu_reset   ), 

    // Pla1 Interface
   .CASS_IN  ( cass_in  ),
   .CASS_OUT ( cass_out ),

   // Speaker

   .SPEAKER ( speaker ),
   .MUTE    ( 1'b0 )
);

// include keyboard decoder
wire [7:0] key_value; // Pla1 <-> PS2_to_matrix

PS2_to_matrix PS2_to_matrix (
    .clk   ( cpu_clock ),
    .reset ( cpu_reset ),

	 // Pla1 interface
    .sfrdatao ( key_value      ),
    .addr     ( cpu_addr[15:8] ),
    .kbd_leds ( 3'd0           ),
    .sensible ( 1'b0           ),

	 // PS2 keyboard interface
    .psdatai ( keyboard_datao ),
    .psbusy  ( 1'b0           ),
    .psint   ( keyboard_int   )
);

wire [7:0] keyboard_datao;
wire keyboard_int;

keyboard keyboard ( 
    .clk   ( cpu_clock ),
    .reset ( cpu_reset ),

	// ps2 interface	
	.ps2_clk    ( ps2_kbd_clk  ),
	.ps2_data   ( ps2_kbd_data ),	

	// outputs
	.datao ( keyboard_datao ),
	.int   ( keyboard_int   )
);

// derive 12KHz ps2 clock from 100Mhz clock (and a ~3Hz clock for dbg purpose)
wire ps2_clock = clk_div[12];
wire slow_clock = clk_div[24];
reg [24:0] clk_div;

always @(posedge clock_100mhz) begin	
	clk_div <= clk_div + 25'b1;
end	
		  
// PLL to generate 100MHz system clock, 4MHz cpu clock & 32MHz SDRAM clock
pll pll (
	 .inclk0 ( CLOCK_27[0]   ),
	 .locked ( pll_locked    ),         // PLL is running stable
	 .c0     ( clock_100mhz  ),   		// system clock@100MHz
	 .c1     ( cpu_clock     ),     		// CPU clock@4MHz
	 .c2     ( ram_clock     ),        	// RAM clock@2 MHz
	 .c3     ( SDRAM_CLK     )         	// slightly phase shifted 32 MHz
);

endmodule
