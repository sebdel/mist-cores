
-------------------------------------------------------
--- Submodule Pla1.vhdl (Aquarius)
-------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity PLA1 is
port
(
    CLK            : in    std_logic;
    RST            : in    std_logic;

-- CPU interface

    DATAO          : in    std_logic_vector(7 downto 0);
    DATAI          : out   std_logic_vector(7 downto 0);
    ADDR           : in    std_logic_vector(15 downto 0);
    MEMWR          : in    std_logic;
    MEMRD          : in    std_logic;
    IOWR           : in    std_logic;
    IORD           : in    std_logic;

-- Internal memory interface

    RAM_WE         : out    std_logic;
    VIDEO_WE       : out    std_logic;
    DATA_ROM       : in     std_logic_vector(7 downto 0);
    DATA_VIDEO     : in     std_logic_vector(7 downto 0);
    DATA_ROMPACK   : in     std_logic_vector(7 downto 0);
    ROM_EN         : in     std_logic;

-- External memory interface

    OE_EXTN        : out    std_logic;
    WE_EXTN        : out    std_logic;
    CS_EXTN        : out    std_logic;
    DATA_EXT_IN    : in  std_logic_vector(7 downto 0);
    DATA_EXT_OUT   : out  std_logic_vector(7 downto 0);

-- Peripheral interface

    KEY_VALUE      : in     std_logic_vector(7 downto 0);
    LED_OUT        : out    std_logic;
    CASS_OUT       : out    std_logic;
    CASS_IN        : in     std_logic;
    VSYNC          : in     std_logic
);
end PLA1;

architecture RTL of PLA1 is

signal ram_selected        : boolean;
signal rom_selected        : boolean;
signal video_selected      : boolean;
signal color_selected      : boolean;
signal rompack_selected    : boolean;
signal kbd_swlock_selected : boolean;
signal cass_selected       : boolean;
signal ext_selected        : boolean;
signal sync_selected       : boolean;
signal led_selected        : boolean;

signal swlock : std_logic_vector(7 downto 0);

signal HOLD_CTRL0 : std_logic;

begin
     rom_selected        <= true when  ADDR(15 downto 13) = "000"                     else false;
     video_selected      <= true when  ADDR(15 downto 11) = "00110"                   else false;
     ram_selected        <= true when  ADDR(15 downto 11) = "00111"                   else false;
     rompack_selected    <= true when (ADDR(15 downto 14) = "11") and (ROM_EN = '1')  else false;
	  ext_selected        <= true when  ADDR(15 downto 14) = "01" 							  else false;
--     ext_selected        <= true when (ADDR(15) /= ADDR(14)) or ram_selected or
--                                     ((ADDR(15 downto 14) = "11") and (ROM_EN = '0')) else false;
     kbd_swlock_selected <= true when  ADDR(7 downto 0)   = X"FF"                     else false;
     led_selected        <= true when  ADDR(7 downto 0)   = X"FE"                     else false;
     sync_selected       <= true when  ADDR(7 downto 0)   = X"FD"                     else false;
     cass_selected       <= true when  ADDR(7 downto 0)   = X"FC"                     else false;

     VIDEO_WE <= '1' when (MEMWR = '1') and (video_selected = true) else '0';
     RAM_WE   <= '1' when (MEMWR = '1') and (ram_selected   = true) else '0';
         
	  DATAI <= KEY_VALUE                when (IORD = '1') and (kbd_swlock_selected = true) else
              "1111111" & CASS_IN      when (IORD = '1') and (cass_selected       = true) else
              "1111111" & VSYNC        when (IORD = '1') and (sync_selected       = true) else
				  DATA_ROM                 when (IORD = '0') and (rom_selected        = true) else
              DATA_VIDEO               when (IORD = '0') and (video_selected      = true) else
              DATA_EXT_IN              when (IORD = '0') and (ram_selected        = true) else
              DATA_ROMPACK  xor swlock when (IORD = '0') and (rompack_selected    = true) else
              DATA_EXT_IN xor swlock   when (IORD = '0') and (ext_selected        = true) else
              "00000000";
				  
	  -- Peripherals write
     CASS_OUT <= DATAO(0)                 when (IOWR = '1') and (cass_selected = true);
	  LED_OUT  <= '0'               			when (RST   = '1') else
					  DATAO(0)                 when (IOWR = '1') and (led_selected = true);
			  
     swlock   <= "00000000"               when (RST   = '1') else
                 DATAO                    when (IOWR  = '1') and (kbd_swlock_selected = true);

     DATA_EXT_OUT <= (others => 'Z') when MEMWR = '0'      else
                     (others => 'Z') when not ext_selected else
                     DATAO           when ram_selected     else
                     DATAO xor swlock;

     WE_EXTN <= (not MEMWR) or HOLD_CTRL0;
     OE_EXTN <= (not MEMRD) or HOLD_CTRL0;
     CS_EXTN <= '0' when (ext_selected = true) else '1';


    HOLD_CONTROL0: process( CLK )
    begin
       if falling_edge(CLK) then
          HOLD_CTRL0 <= '0';
       end if;
    end process;

end RTL;

