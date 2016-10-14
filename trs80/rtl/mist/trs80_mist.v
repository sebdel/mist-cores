// TRS-80 model I for the MiST
// (c) 2016 Sebastien Delestaing
									  
module Debugger(input clk, input reset_n,
                output reg [15:0] mem_addr, output [7:0] mem_data, 
					 output reg mem_req_n, output reg mem_write_n);
					 
  reg [1:0] state = 0;
  reg [9:0] counter;
  
  assign mem_data = counter[7:0];
  
  always @(posedge clk) begin
    if (reset_n == 0) begin
      state <= 0;
      counter <= 0;
      mem_addr <= 'h3c00;  // Screen address
		mem_write_n <= 1;
		mem_req_n <= 1;
    end else begin
	  counter <= counter + 1;

	  case(state)
      // Write 1024 characters
      0: begin
           mem_addr <= mem_addr + 1;
			  mem_write_n <= 0;
			  mem_req_n <= 0;
           if (counter == 10'h3ff)
             state <= 1;
         end
      1: begin
				mem_addr <= 0;
				mem_write_n <= 1;
				mem_req_n <= 1;
				if (counter == 10'h3ff)
					state <= 2;
			end
		2: begin
				state <= 3;
         end
      endcase
    end
  end
endmodule

									  
module trs80_mist (

	input [1:0]  CLOCK_27,
	
	// SDRAM interface
	inout	[15:0]  	SDRAM_DQ, 		// SDRAM Data bus 16 Bits
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

wire pal = 1;	// 50/60Hz

// clocks
wire cpu_clock;
wire ram_clock;

// OSD menu
parameter CONF_STR = {
        "TRS-80 Model I;;",
        "O1,Scanlines,On,Off;",
        "T2,Reset"
};
parameter CONF_STR_LEN = 16+20+8;

// the status register is controlled by the on screen display (OSD)
wire [7:0] status;
wire arm_reset = status[0];
wire osd_scanlines = !status[1];
wire osd_reset = status[2];

// user IO
wire ps2_kbd_clk, ps2_kbd_data;
wire scandoubler_disable;

// User IO
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

// VGA controller

wire [7:0] video_dout;
wire video_hs, video_vs;
wire video;

trs_vid trs_vid (
	.Rst_n	( glue_reset_n_s 	),
	.Clk		( pixel_clock 		),
	.Tick		( 1 					),
	.Eur		( pal 				),
	.CS_n		( glue_video_cs_n ),
	.Wr_n		( glue_write_n 	),
	.Addr		( cpu_addr[9:0] 	),	// 1KB VRAM
	.DI		( cpu_dout 			),
	.DO		( video_dout 		),
	.HSync	( video_hs 			),
	.VSync	( video_vs 			),
	.Video	( video 				)
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
	.r_in           ( {6{video}}   ),
	.g_in           ( {6{video}}   ),
	.b_in           ( {6{video}}   ),

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
wire [5:0] osd_r = scandoubler_disable ? {6{video}} : sd_r;
wire [5:0] osd_g = scandoubler_disable ? {6{video}} : sd_g;
wire [5:0] osd_b = scandoubler_disable ? {6{video}} : sd_b;

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

// Z80 CPU
//
// The CPU is kept in reset for further 256 cycles after the PLL is
// generating stable clocks to make sure things like the SDRAM have
// some time to initialize
reg [7:0] cpu_reset_cnt = 8'h00;
wire cpu_reset = (cpu_reset_cnt != 255);
always @(posedge cpu_clock) begin
	if(!pll_locked || arm_reset || osd_reset) begin
		cpu_reset_cnt <= 8'd0;
	end else 
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
wire cpu_iorq_n;
/*
T80s T80s (
	.RESET_n  ( glue_reset_n_s	),
	.CLK_n    ( cpu_clock     	),
	.WAIT_n   ( 1'b1          	),
	.INT_n    ( 1'b1          	),
	.NMI_n    ( 1'b1          	),
	.BUSRQ_n  ( 1'b1          	),
	.IORQ_n   ( cpu_iorq_n    	),
	.MREQ_n   ( cpu_mreq_n    	),
	.RD_n     ( cpu_rd_n      	), 
	.WR_n     ( cpu_wr_n      	),
	.A        ( cpu_addr      	),
	.DI       ( cpu_din			),
	.DO       ( cpu_dout      	)
);
*/
Debugger debugger(cpu_clock, glue_reset_n_s,
                cpu_addr, cpu_dout, cpu_mreq_n, cpu_wr_n);

// SDRAM 2K

assign SDRAM_CKE = 1'b0;

wire [7:0] ram_dout;
wire ram_rden = !glue_ram_cs_n;
wire ram_wren = !glue_write_n && !glue_ram_cs_n;

//sdram sdram (
//	// interface to the MT48LC16M16 chip
//   .sd_data        ( SDRAM_DQ                  ),
//   .sd_addr        ( SDRAM_A                   ),
//   .sd_dqm         ( {SDRAM_DQMH, SDRAM_DQML}  ),
//   .sd_cs          ( SDRAM_nCS                 ),
//   .sd_ba          ( SDRAM_BA                  ),
//   .sd_we          ( SDRAM_nWE                 ),
//   .sd_ras         ( SDRAM_nRAS                ),
//   .sd_cas         ( SDRAM_nCAS                ),
//
//   // system interface
//   .clk            ( ram_clock                 ),
//   .clkref         ( cpu_clock                 ),
//   .init           ( !pll_locked               ),
//
//   // cpu/chipset interface
//   .din            ( cpu_dout                  ),
//   .addr           ( { 14'd0, cpu_addr[10:0] } ),	// 2KB RAM
//   .we             ( ram_wren 					  ),
//   .oe         	 ( ram_rden						  ),
//   .dout           ( ram_dout              	  )
//);


// RAM (2K)
ram2k ram2k (
	.clock 	( cpu_clock			),
	.wren		( ram_wren			),
	.address	( cpu_addr[10:0] 	),	// 2KB RAM
	.data		( cpu_dout			),
	.q			( ram_dout			)
);

// Level 1 ROM (4k)
wire [7:0] rom_dout;

rom1 rom1 (
	.clock   ( cpu_clock      ),
	.address ( cpu_addr[11:0] ),	// 4KB ROM
	.q       ( rom_dout		  )
);

wire glue_reset_n_s;
wire glue_tick1us;
wire glue_write_n;
wire glue_ram_cs_n;
wire glue_video_cs_n;

trs_glue #(.RAMWidth (11)) trs_glue(
	.Rst_n 		( !cpu_reset 		),
	.Clk			( cpu_clock 		),
	.Rd_n			( cpu_rd_n 			),
	.Wr_n			( cpu_wr_n 			),
	.MReq_n		( cpu_mreq_n 		),
	.IORq_n		( cpu_iorq_n 		),
	.A				( cpu_addr[15:0] 	),	// 64KB adressable space
	.DO_RAM		( ram_dout 			),
	.DO_ROM		( rom_dout 			),
	.DO_Vid		( video_dout 		),
	.DO_Key		( keyboard_dout 	),
	.DI_CPU		( cpu_din 			),
	.Rst_n_s		( glue_reset_n_s 	),
	.Tick1us		( glue_tick1us 	),
	.MWr_n		( glue_write_n 	),
	.RAMCS_n		( glue_ram_cs_n 	),
	.VidCS_n		( glue_video_cs_n )
);

wire [7:0] keyboard_dout;

trs_ps2 trs_ps2 (
	.Rst_n		( glue_reset_n_s	),
	.Clk			( cpu_clock 		),
	.Tick1us		( glue_tick1us		),
	.PS2_Clk		( ps2_kbd_clk		),
	.PS2_Data	( ps2_kbd_data 	),
	.Key_Addr	( cpu_addr[7:0] 	),	// 256 bytes
	.Key_Data	( keyboard_dout 	)
);

// ps2 clock = 1.77MHz/128 ~ 14KHz 
wire ps2_clock = clk_div[6];
reg [7:0] clk_div;

always @(posedge cpu_clock) begin	
	clk_div <= clk_div + 8'b1;
end	

// vga clock @25MHz
wire vga_clock = ram_clock;
reg pixel_clock;

always @(posedge vga_clock)
	pixel_clock <= !pixel_clock;
		
// PLL to generate 1.77MHz cpu clock & 25MHz SDRAM clock
wire pll_locked;

pll pll (
	 .inclk0 ( CLOCK_27[0]   ),
	 .locked ( pll_locked    ),         // PLL is running stable
	 .c0     ( cpu_clock     ),     		// CPU clock@1.77MHz
	 .c1     ( ram_clock     ),        	// RAM clock@25MHz
	 .c2     ( SDRAM_CLK     )         	// slightly phase shifted 25MHz
);

endmodule

