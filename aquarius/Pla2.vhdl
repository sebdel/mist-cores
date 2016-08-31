
-------------------------------------------------------
--- Submodule Pla2.vhdl (Aquarius)
-------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity PLA2 is
port
(
    CLK            : in    std_logic;
    RST            : in    std_logic;

-- VGA configuration parameters

    VGA_RES        : out   std_logic;
    VGA_CMOD       : out   std_logic_vector(1 downto 0);
    VGA_DIPSIZE_H  : out   std_logic_vector(9 downto 0);
    VGA_DIPSIZE_V  : out   std_logic_vector(9 downto 0);

-- VGA communication interface

    VGA_CLK        : out    std_logic;
    VGA_RD         : in     std_logic;
    VGA_DATA       : out    std_logic_vector(7 downto 0);
    VGA_ADDR_PIXEL : in     std_logic_vector(18 downto 0);

-- Character ROM interface

    ROM_DATA       : in     std_logic_vector(7 downto 0);
    ROM_ADDR       : out    std_logic_vector(10 downto 0);

-- Video memory interface

    VD_IN          : in     std_logic_vector(7 downto 0);
    VD_OUT         : out    std_logic_vector(7 downto 0);
    VD_ADDR        : out    std_logic_vector(10 downto 0);
    VD_WE          : out    std_logic
);
end PLA2;

architecture RTL of PLA2 is

-- VGA configuration constants

Constant VgaRes800x600: std_logic := '0';                               -- 800 x 600 (SVGA)
Constant VgaRes640x480: std_logic := '1';                               -- 640 x 480 (VGA)

Constant VgaCmodBW : std_logic_vector(1 downto 0) := "00";              -- Black & White
Constant VgaCmodC16: std_logic_vector(1 downto 0) := "01";              -- 16 Colors
Constant VgaCmodC64: std_logic_vector(1 downto 0) := "10";              -- 64 Colors

Constant VgaDipSize640: std_logic_vector(9 downto 0) := "1010000000";   -- 640
Constant VgaDipSize480: std_logic_vector(9 downto 0) := "0111100000";   -- 480

signal x_pos : std_logic_vector(2 downto 0);
signal y_pos : std_logic_vector(2 downto 0);

begin
    -- Set VGA configuration parameters

    VGA_RES       <= VgaRes640x480;           -- 640 x 480 (VGA)
    VGA_CMOD      <= VgaCmodC64;              -- 64 Colors
    VGA_DIPSIZE_H <= VgaDipSize640;           -- Number of pixels per line (640)
    VGA_DIPSIZE_V <= VgaDipSize480;           -- Number of lines (480)

    VD_OUT <= "00000000";
    VD_WE <= '0';

    VGA1:process

    Variable mem_off: std_logic_vector(10 downto 0);
    Variable color: std_logic_vector(3 downto 0);
    Variable pixel_x: std_logic_vector(9 downto 0);
    Variable pixel_y: std_logic_vector(9 downto 0);
    Variable tmp: std_logic_vector(12 downto 0);

    Type states is
      (
        state1,
        state2,
        state3,
        state4
      );
    variable state : states;

    begin
         wait until CLK = '1';

         if RST = '1' then
               state := state1;
         end if;

         case state is

          when state1 =>

            VGA_CLK <= '1';

            if (ROM_DATA(conv_integer(not(x_pos))) = '0') then
              color := VD_IN(3 downto 0);
            else
              color := VD_IN(7 downto 4);
            end if;

            case color is
              when "0000" => VGA_DATA <= "00000000";   -- Black
              when "0001" => VGA_DATA <= "00110000";   -- Red
              when "0010" => VGA_DATA <= "00001100";   -- Green
              when "0011" => VGA_DATA <= "00111100";   -- Yellow
              when "0100" => VGA_DATA <= "00000011";   -- Blue
              when "0101" => VGA_DATA <= "00100010";   -- Violet
              when "0110" => VGA_DATA <= "00101111";   -- Light Blue-Green
              when "0111" => VGA_DATA <= "00111111";   -- White
              when "1000" => VGA_DATA <= "00101010";   -- Light Gray
              when "1001" => VGA_DATA <= "00001111";   -- Blue-Green
              when "1010" => VGA_DATA <= "00110011";   -- Magenta
              when "1011" => VGA_DATA <= "00000010";   -- Dark Blue
              when "1100" => VGA_DATA <= "00111110";   -- Light Yellow
              when "1101" => VGA_DATA <= "00101110";   -- Light Green
              when "1110" => VGA_DATA <= "00111000";   -- Orange
              when "1111" => VGA_DATA <= "00010101";   -- Dark Gray
              when others => VGA_DATA <= "00000000";
            end case;

            VD_ADDR  <= "00000000000";
            state := state2;

          when state2 =>

            tmp := VGA_ADDR_PIXEL (18 downto 6);  -- divide by 64
            pixel_y := (others => '0');

            if (tmp(12 downto 10) >=  "101" ) then tmp(12 downto 10) := tmp(12 downto 10) -  "101"; pixel_y( 9) := '1'; end if;
            if (tmp(12 downto  9) >= "0101" ) then tmp(12 downto  9) := tmp(12 downto  9) - "0101"; pixel_y( 8) := '1'; end if;
            if (tmp(11 downto  8) >= "0101" ) then tmp(11 downto  8) := tmp(11 downto  8) - "0101"; pixel_y( 7) := '1'; end if;
            if (tmp(10 downto  7) >= "0101" ) then tmp(10 downto  7) := tmp(10 downto  7) - "0101"; pixel_y( 6) := '1'; end if;
            if (tmp( 9 downto  6) >= "0101" ) then tmp( 9 downto  6) := tmp( 9 downto  6) - "0101"; pixel_y( 5) := '1'; end if;
            if (tmp( 8 downto  5) >= "0101" ) then tmp( 8 downto  5) := tmp( 8 downto  5) - "0101"; pixel_y( 4) := '1'; end if;

            -- We run out of time. The most important part, Pixel_y(9 downto 4), is already known, so remaining
            -- part of the divide is done in the next state / clock cycle

            if pixel_y(9 downto 4) < 2 then
                mem_off := "00000000000";
            elsif pixel_y(9 downto 4) >= 27 then
                mem_off := "00000000000";
            else
                pixel_y(9 downto 4) := pixel_y(9 downto 4) - 2;
                mem_off := ("00000" & pixel_x(9 downto 4)) + (pixel_y(9 downto 4) & "00000") + ("00" & pixel_y(9 downto 4) & "000");
            end if;

            VD_ADDR <= "0" & mem_off(9 downto 0);

            state := state3;

          when state3 =>

            VGA_CLK <= '0';

            if (tmp( 7 downto 4) >= "0101" ) then tmp( 7 downto 4) := tmp( 7 downto 4) - "0101"; pixel_y( 3) := '1'; end if;
            if (tmp( 6 downto 3) >= "0101" ) then tmp( 6 downto 3) := tmp( 6 downto 3) - "0101"; pixel_y( 2) := '1'; end if;
            if (tmp( 5 downto 2) >= "0101" ) then tmp( 5 downto 2) := tmp( 5 downto 2) - "0101"; pixel_y( 1) := '1'; end if;
            if (tmp( 4 downto 1) >= "0101" ) then tmp( 4 downto 1) := tmp( 4 downto 1) - "0101"; pixel_y( 0) := '1'; end if;

            pixel_x := tmp( 3 downto 0) & VGA_ADDR_PIXEL (5 downto 0);

            x_pos <= pixel_x(3 downto 1);
            y_pos <= pixel_y(3 downto 1);

            -- Predict the next value of pixel_x
            pixel_x := pixel_x + 1; -- HS  Oops! Pixel_x will never be zero! Is this a problem?

            VD_ADDR <= "1" & mem_off(9 downto 0);

            state := state4;

          when state4 =>

            VD_ADDR  <= "00000000000";

            state := state1;

         end case;

    end process;

    ROM_ADDR <= VD_IN & y_pos;

end RTL;

