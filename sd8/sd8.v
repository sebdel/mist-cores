// Seb Z80 based system
// (c) 2016 Sebastien Delestaing
									  
module sd8 ( 
   input [1:0] 	CLOCK_27,
	
	output			LED,
	
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
   output      	SPI_DO,
	input       	SPI_DI,
   input       	SPI_SCK,
   input 			SPI_SS2,
   input 			SPI_SS3,
   input 			SPI_SS4,
	input       	CONF_DATA0, 

	// Audio output
   output 			AUDIO_L,
   output 	 		AUDIO_R,
	
	// VGA interface
   output 			VGA_HS,
   output 	 		VGA_VS,
   output [5:0] 	VGA_R,
   output [5:0] 	VGA_G,
   output [5:0] 	VGA_B
);

wire pixel_clock;
wire [7:0] joystick_0;
wire [7:0] joystick_1;

// the configuration string is returned to the io controller to allow
// it to control the menu on the OSD 
parameter CONF_STR = {
        "SD8;;",
        "O1,Scanlines,On,Off;",
        "T2,Reset"
};

parameter CONF_STR_LEN = 5+20+8;

// the status register is controlled by the on screen display (OSD)
wire [7:0] status;

// conections between user_io (implementing the SPIU communication 
// to the io controller) and the legacy 
wire [31:0] sd_lba;
wire sd_rd;
wire sd_wr;
wire sd_ack;
wire sd_conf;
wire sd_sdhc; 
wire [7:0] sd_dout;
wire sd_dout_strobe;
wire [7:0] sd_din;
wire sd_din_strobe;

// include user_io module for arm controller communication
user_io #(.STRLEN(CONF_STR_LEN)) user_io ( 
		.conf_str   ( CONF_STR   ),

		.SPI_CLK    ( SPI_SCK    ),
      .SPI_SS_IO  ( CONF_DATA0 ),
      .SPI_MISO   ( SPI_DO     ),
      .SPI_MOSI   ( SPI_DI     ),

		.status     ( status     ),

		// interface to embedded legacy sd card wrapper
		.sd_lba     ( sd_lba),
		.sd_rd      ( sd_rd),
		.sd_wr      ( sd_wr),
		.sd_ack     ( sd_ack),
		.sd_conf    ( sd_conf),
		.sd_sdhc    ( sd_sdhc),
		.sd_dout    ( sd_dout),
		.sd_dout_strobe (sd_dout_strobe),
		.sd_din     ( sd_din),
		.sd_din_strobe (sd_din_strobe),
		
		// ps2 interface
		.ps2_clk        ( ps2_clock      ),
		.ps2_kbd_clk    ( ps2_kbd_clk    ),
		.ps2_kbd_data   ( ps2_kbd_data   ),
		.ps2_mouse_clk  ( ps2_mouse_clk  ),
		.ps2_mouse_data ( ps2_mouse_data ),
		 
		.joystick_0 ( joystick_0 ),
      .joystick_1 ( joystick_1 )
);

sd_card sd_card (
	// connection to io controller
   .io_lba (sd_lba ),
   .io_rd  (sd_rd),
   .io_wr  (sd_wr),
   .io_ack (sd_ack),
   .io_conf (sd_conf),
   .io_sdhc (sd_sdhc),
   .io_din (sd_dout),
   .io_din_strobe (sd_dout_strobe),
   .io_dout (sd_din),
   .io_dout_strobe ( sd_din_strobe),
 
   .allow_sdhc ( 1'b1),   // esxdos supports SDHC

   // connection to local CPU
   .sd_cs   ( sd_ss    ),
   .sd_sck  ( sd_sck   ),
   .sd_sdi  ( sd_sdi   ),
   .sd_sdo  ( sd_sdo   )
);

// the MiST emulates a PS2 keyboard and mouse
wire ps2_kbd_clk, ps2_kbd_data;
wire ps2_mouse_clk, ps2_mouse_data;

// a very simple keyboard implementation which only decodes
// a few keys (SPACE, S, ...)
wire kbd_sel = !cpu_iorq_n && cpu_m1_n && ({ cpu_addr[7:1], 1'b0} == 8'h20 );
wire [7:0] keys;
keyboard keyboard (
	.reset    ( cpu_reset    ),
	.clk      ( cpu_clock    ),

	.ps2_clk  ( ps2_kbd_clk  ),
	.ps2_data ( ps2_kbd_data ),
	
	.keys     ( keys         )
);

// a very simple mouse implementation. It accumulates mouse movement 
// internally until the cpu reads the values which in turn clears the
// hardware counters
wire [7:0] mouse_dout = 
	(cpu_addr[1:0]==2'd0)?mouse_x:
	(cpu_addr[1:0]==2'd1)?mouse_y:
	{6'b000000, mouse_b};
wire [7:0] mouse_x;
wire [7:0] mouse_y;
wire [1:0] mouse_b;
wire mouse_sel = !cpu_iorq_n && cpu_m1_n && ({ cpu_addr[7:2], 2'b00} == 8'h30 );
mouse mouse (
	.reset    ( cpu_reset      ),
	.clk      ( cpu_clock      ),

	.ps2_clk  ( ps2_mouse_clk  ),
	.ps2_data ( ps2_mouse_data ),
	
	.x        ( mouse_x        ),
	.clr_x    ( mouse_sel && !cpu_rd_n && (cpu_addr[1:0] == 2'd0)),
	.y        ( mouse_y        ),
	.clr_y    ( mouse_sel && !cpu_rd_n && (cpu_addr[1:0] == 2'd1)),
	.b        ( mouse_b        )
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
                          
wire [5:0] video_r, video_g, video_b;
wire video_hs, video_vs;
		  
// include VGA controller
vga vga (
   .reset    ( cpu_reset        ),
	.pclk     ( pixel_clock      ),
	 
	.cpu_clk  ( cpu_clock        ),
	// Writing to 0-32000 writes to VGA controller
	.cpu_wr   ( !cpu_wr_n && !cpu_mreq_n && !cpu_addr[15] ),
	.cpu_addr ( cpu_addr[14:0]   ),
	.cpu_data ( cpu_dout         ),

	.scanlines ( !status[1]      ),
	
	// video output as fed into the on screen display engine
	.hs    	( video_hs          ),
	.vs    	( video_vs          ),
	.r     	( video_r           ),
	.g     	( video_g           ),
	.b     	( video_b           )
);

// The CPU is kept in reset for further 256 cycles after the PLL is generating stable clocks
// to make sure things like the SDRAM have some time to initialize
// status 0 is arm controller power up reset, status 2 is reset entry in OSD
reg [7:0] cpu_reset_cnt = 8'h00;
wire cpu_reset = (cpu_reset_cnt != 255);
always @(posedge cpu_clock) begin
	if(!pll_locked || status[0] || status[2] || dio_download)
		cpu_reset_cnt <= 8'd0;
	else 
		if(cpu_reset_cnt != 255)
			cpu_reset_cnt <= cpu_reset_cnt + 8'd1;
end
			
// SDRAM control signals
wire ram_clock;
assign SDRAM_CKE = 1'b1;

// during ROM download data_io writes the ram. Otherwise the CPU
wire [7:0] sdram_din = dio_download ? dio_data : cpu_dout;
wire [24:0] sdram_addr = dio_download ? dio_addr : { 9'd0, cpu_addr[15:0] };
wire sdram_wr = dio_download ? dio_write : (!cpu_wr_n && !cpu_mreq_n && cpu_addr[15]);
wire sdram_oe = dio_download ? 1'b1 : (!cpu_rd_n && !cpu_mreq_n);

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

   // cpu interface
   .din            ( sdram_din                 ),
   .addr           ( sdram_addr                ),
   .we             ( sdram_wr                  ),
   .oe         	 ( sdram_oe                  ),
   .dout           ( ram_data_out              )
);
	
// CPU control signals
wire [15:0] cpu_addr;
wire [7:0] cpu_din;
wire [7:0] cpu_dout;
wire cpu_rd_n;
wire cpu_wr_n;
wire cpu_mreq_n;
wire cpu_m1_n;
wire cpu_iorq_n;

// include Z80 CPU
T80s T80s (
	.RESET_n  ( !cpu_reset    ),
	.CLK_n    ( cpu_clock     ),
	.WAIT_n   ( 1'b1          ),
	.INT_n    ( irq_n         ),
	.NMI_n    ( 1'b1          ),
	.BUSRQ_n  ( 1'b1          ),
	.MREQ_n   ( cpu_mreq_n    ),
	.M1_n     ( cpu_m1_n      ),
	.IORQ_n   ( cpu_iorq_n    ),
	.RD_n     ( cpu_rd_n      ), 
	.WR_n     ( cpu_wr_n      ),
	.A        ( cpu_addr      ),
	.DI       ( cpu_din       ),
	.DO       ( cpu_dout      )
);

// de-multiplex the IO data sources
wire [7:0] io_dout = spi_sel ? spi_dout:
							psg_sel ? psg_dout:
							ym2151_sel ? ym2151_dout:
							kbd_sel ? keys:
							mouse_sel ? mouse_dout:
							8'h00;

// SPI controller uses IO addresses 0 and 1
wire sd_ss, sd_sck, sd_sdi, sd_sdo;
wire spi_sel = !cpu_iorq_n && cpu_m1_n && ({ cpu_addr[7:1], 1'b0} == 8'h00 );
wire [7:0] spi_dout;

spi spi ( 
	.reset   ( cpu_reset   ),
	.clk     ( cpu_clock   ),

	// CPU interface
   .sel     ( spi_sel     ),
   .wr      ( !cpu_wr_n   ),
   .addr    ( cpu_addr[0] ),
   .din     ( cpu_dout    ),
   .dout    ( spi_dout    ),

	// SPI/SD card interface
	.spi_ss  ( sd_ss       ),
	.spi_sck ( sd_sck      ),
	.spi_sdo ( sd_sdi      ),
	.spi_sdi ( sd_sdo      )
);	

// Clock to generate the 50Hz interrupt.
reg clk50hz;
reg [15:0] count_50hz;
always @(posedge cpu_clock) begin
	if(cpu_reset)
		count_50hz <= 16'd0;
	else begin
		if(count_50hz < 16'd39999)
			count_50hz <= count_50hz + 16'd1;
		else begin
			count_50hz <= 16'd0;
			clk50hz <= !clk50hz;
		end
	end
end
	
// irq is asserted until cpu acknowledges it
reg irqD, irqD2;
reg irq_n;
reg [7:0] vector_dout;
always @(posedge cpu_clock) begin
	irqD <= clk50hz;
	irqD2 <= irqD;

	if(cpu_reset) begin
		irq_n <= 1'b1;
		vector_dout <= 8'b0;
	end else begin
		if(video_vs) begin
				irq_n <= 1'b0;
				vector_dout <= 8'h30;
		end else begin
			if(irqD && !irqD2) begin 
				irq_n <= 1'b0;
				vector_dout <= 8'h20;
			end
		end
		if(!cpu_iorq_n && !cpu_m1_n)
			irq_n <= 1'b1;
	end
end

// map 32k SDRAM into upper half of the address space (A15=1)
// map ROM (now also placed in SDRAM) into the lower half (A15=0)
// or Mode 2 interrupt vector
wire [7:0] ram_data_out;
assign cpu_din = (!cpu_iorq_n) ? ((!cpu_m1_n) ? vector_dout : io_dout) : ram_data_out;

wire dio_download;
wire [24:0] dio_addr;
wire [7:0] dio_data;
wire dio_write;

// include ROM download helper
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

wire [7:0] psg_dout;
// YM2149 port base adress = 0x10
wire psg_sel = !cpu_iorq_n && cpu_m1_n && ({ cpu_addr[7:1], 1'b0} == 8'h10 );
wire [7:0] psg_audio_out;
 
YM2149 ym2149 (
	.I_DA    ( cpu_dout                ),
   .O_DA    ( psg_dout                ),

   // control
   .I_A9_L  ( 1'b0                    ),
   .I_A8    ( 1'b1                    ),
   .I_BDIR  ( psg_sel && !cpu_wr_n    ),
   .I_BC2   ( 1'b1                    ),
   .I_BC1   ( psg_sel && !cpu_addr[0] ),
   .I_SEL_L ( 1'b1                    ),

   .O_AUDIO ( psg_audio_out           ),
 
   //
   .ENA     ( 1'b1                    ), 
   .RESET_L ( !cpu_reset              ),
   .CLK     ( clk2m                   ),      // 2 MHz
   .CLK8    ( cpu_clock               )       // 4 MHz CPU bus clock
);


wire [7:0] ym2151_dout;
// YM2151 port adress = 0x40 (addr), 0x41 (data)
wire ym2151_sel = !cpu_iorq_n && cpu_m1_n && ({ cpu_addr[7:1], 1'b0} == 8'h40 );
wire [15:0] ym2151_audio_l;
wire [15:0] ym2151_audio_r;
wire led;

assign LED = !led;
 
 jt51 ym2151 (
	.clk		( clk4m			),	// main clock @4MHZ
	.rst		( cpu_reset		),	// reset
	.cs_n		( !ym2151_sel	),	// chip select
	.wr_n		( !(ym2151_sel && !cpu_wr_n)		),	// write
	.a0		( !(ym2151_sel && !cpu_addr[0])	),	// adress @ 0, data @ 1 (a0=0 to select adress)
	.d_in 	( cpu_dout		), // data in	
	.d_out 	( ym2151_dout	), // data out
	.ct1		( led				),
//	.ct2,
//	.irq_n,	// I do not synchronize this signal
//	.p1,
	// unsigned outputs for sigma delta converters, full resolution
	.dacleft		( ym2151_audio_l ),
	.dacright	( ym2151_audio_r )
);

wire [13:0] ym2149_audio = { psg_audio_out, 7'h00 } - 15'h4000;
//wire [14:0] audio_l = ym2149_audio + ym2151_audio_l[15:2];
//wire [14:0] audio_r = ym2149_audio + ym2151_audio_r[15:2];

wire [14:0] audio_l = ym2151_audio_l[15:1] - 15'h4000;
wire [14:0] audio_r = ym2151_audio_r[15:1] - 15'h4000;

sigma_delta_dac sigma_delta_dac (
   .clk      ( ram_clock	),
	.left     ( AUDIO_L		),
	.right    ( AUDIO_R		),
	.ldatasum ( audio_l		),
	.rdatasum ( audio_r		)
);

// divide 32Mhz sdram clock down to 2MHz
reg clk2m;	
always @(posedge clk4m)
	clk2m <= !clk2m;

wire cpu_clock = clk4m;
reg clk4m;	
always @(posedge clk8m)
	clk4m <= !clk4m;

reg clk8m;	
always @(posedge clk16m)
	clk8m <= !clk8m;

reg clk16m;	
always @(posedge ram_clock)
	clk16m <= !clk16m;

// derive 15kHz ps2 clock from 32Mhz sdram clock
wire ps2_clock = clk_div[10];
reg [13:0] clk_div;
always @(posedge ram_clock)
   clk_div <= clk_div + 14'd1;

// PLL to generate 32Mhz ram clock and 25Mhz video clock from MiSTs 27Mhz on board clock
wire pll_locked;
pll pll (
	 .inclk0 ( CLOCK_27[0]   ),
	 .locked ( pll_locked    ),        // PLL is running stable
	 .c0     ( pixel_clock   ),        // 25.175 MHz
	 .c1     ( ram_clock     ),        // 32 MHz
	 .c2     ( SDRAM_CLK     )         // 32 MHz slightly phase shiftet
);

endmodule
