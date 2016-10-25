// TRS80 Model I (level1)
// (c) 2016 Sebastien Delestaing
									  
module trs80 (
   input [1:0]	CLOCK_27,
   
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
wire clock_100mhz;

// the configuration string is returned to the io controller to allow
// it to control the menu on the OSD 
parameter CONF_STR = {
        "TRS80;;",
        "O1,Scanlines,On,Off;",
        "T2,Reset"
};

parameter CONF_STR_LEN = 7+20+8;

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

// include SDRAM (64k, because why not ?)
wire ram_clock;
wire [7:0] sdram_dout;

// during ROM download, data_io writes to the ram. Otherwise it's the CPU.
wire [7:0] sdram_din = dio_download ? dio_data : cpu_dout;
wire [24:0] sdram_addr = dio_download ? { 13'd0, dio_addr[11:0] } : { 9'd0, cpu_addr[15:0] };
wire sdram_wr = dio_download ? dio_write : (!glue_write_n && !ram_cs_n && rom_cs_n);

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
   .oe         	 ( 1'b1		  					  ),	// doesn't matter, this will be sorted out in the GLUE
   .dout           ( sdram_dout             	  )
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

// GLUE
wire ram_cs_n, vram_cs_n, rom_cs_n;

glue glue (
	.clock		( cpu_clock		),
	.reset_n 	( !cpu_reset	),
	
	// CPU interface
	.cpu_mreq_n	( cpu_mreq_n	),
	.cpu_wr_n	( cpu_wr_n		),
	.cpu_addr	( cpu_addr		),
	
	.ram_dout	( sdram_dout	),
	.rom_dout	( sdram_dout	),
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

// include vram (2k), use only 1KB
wire [7:0] vram_dout;
wire [9:0] vram_b_addr;
wire [7:0] vram_b_dout;

vram2k vram2k (
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

	 // TRS80 interface
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
