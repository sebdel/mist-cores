-- PS2_to_matrix.vhdl
-- 
-- TRS-80 Model I 
-- PS2 to Keyboard Matrix decoder
--  
-- (c) 2016 Sebastien Delestaing
-- 
-- This source file is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published
-- by the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This source file is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

 
library IEEE;
use IEEE.std_logic_1164.all;

entity PS2_to_matrix is port
    (
    clk      : in  std_logic;
    reset    : in  std_logic;

    sfrdatao : out std_logic_vector(7 downto 0);
    addr     : in  std_logic_vector(7 downto 0);

    psdatai  : in  std_logic_vector(7 downto 0);
    psint    : in  std_logic
    );
end PS2_to_matrix;

architecture behavioral of PS2_to_matrix is

    Constant KEY_A:             std_logic_vector (7 downto 0) := X"1C";
    Constant KEY_B:             std_logic_vector (7 downto 0) := X"32";
    Constant KEY_C:             std_logic_vector (7 downto 0) := X"21";
    Constant KEY_D:             std_logic_vector (7 downto 0) := X"23";
    Constant KEY_E:             std_logic_vector (7 downto 0) := X"24";
    Constant KEY_F:             std_logic_vector (7 downto 0) := X"2B";
    Constant KEY_G:             std_logic_vector (7 downto 0) := X"34";
    Constant KEY_H:             std_logic_vector (7 downto 0) := X"33";
    Constant KEY_I:             std_logic_vector (7 downto 0) := X"43";
    Constant KEY_J:             std_logic_vector (7 downto 0) := X"3B";
    Constant KEY_K:             std_logic_vector (7 downto 0) := X"42";
    Constant KEY_L:             std_logic_vector (7 downto 0) := X"4B";
    Constant KEY_M:             std_logic_vector (7 downto 0) := X"3A";
    Constant KEY_N:             std_logic_vector (7 downto 0) := X"31";
    Constant KEY_O:             std_logic_vector (7 downto 0) := X"44";
    Constant KEY_P:             std_logic_vector (7 downto 0) := X"4D";
    Constant KEY_Q:             std_logic_vector (7 downto 0) := X"15";
    Constant KEY_R:             std_logic_vector (7 downto 0) := X"2D";
    Constant KEY_S:             std_logic_vector (7 downto 0) := X"1B";
    Constant KEY_T:             std_logic_vector (7 downto 0) := X"2C";
    Constant KEY_U:             std_logic_vector (7 downto 0) := X"3C";
    Constant KEY_V:             std_logic_vector (7 downto 0) := X"2A";
    Constant KEY_W:             std_logic_vector (7 downto 0) := X"1D";
    Constant KEY_X:             std_logic_vector (7 downto 0) := X"22";
    Constant KEY_Y:             std_logic_vector (7 downto 0) := X"35";
    Constant KEY_Z:             std_logic_vector (7 downto 0) := X"1A";
    Constant KEY_0:             std_logic_vector (7 downto 0) := X"45";
    Constant KEY_1:             std_logic_vector (7 downto 0) := X"16";
    Constant KEY_2:             std_logic_vector (7 downto 0) := X"1E";
    Constant KEY_3:             std_logic_vector (7 downto 0) := X"26";
    Constant KEY_4:             std_logic_vector (7 downto 0) := X"25";
    Constant KEY_5:             std_logic_vector (7 downto 0) := X"2E";
    Constant KEY_6:             std_logic_vector (7 downto 0) := X"36";
    Constant KEY_7:             std_logic_vector (7 downto 0) := X"3D";
    Constant KEY_8:             std_logic_vector (7 downto 0) := X"3E";
    Constant KEY_9:             std_logic_vector (7 downto 0) := X"46";
    Constant KEY_APOSTROPHE:    std_logic_vector (7 downto 0) := X"0E";
    Constant KEY_MINUS:         std_logic_vector (7 downto 0) := X"4E";
    Constant KEY_EQUAL:         std_logic_vector (7 downto 0) := X"55";
    Constant KEY_BACK_SLASH:    std_logic_vector (7 downto 0) := X"5D";
    Constant KEY_BKSP:          std_logic_vector (7 downto 0) := X"66";
    Constant KEY_SPACE:         std_logic_vector (7 downto 0) := X"29";
    Constant KEY_TAB:           std_logic_vector (7 downto 0) := X"0D";
    Constant KEY_CAPS:          std_logic_vector (7 downto 0) := X"58";
    Constant KEY_L_SHFT:        std_logic_vector (7 downto 0) := X"12";
    Constant KEY_L_CTRL:        std_logic_vector (7 downto 0) := X"14";
    Constant KEY_L_ALT:         std_logic_vector (7 downto 0) := X"11";
    Constant KEY_R_SHFT:        std_logic_vector (7 downto 0) := X"59";
    Constant KEY_ENTER:         std_logic_vector (7 downto 0) := X"5A";
    Constant KEY_ESC:           std_logic_vector (7 downto 0) := X"76";
    Constant KEY_F1:            std_logic_vector (7 downto 0) := X"05";
    Constant KEY_F2:            std_logic_vector (7 downto 0) := X"06";
    Constant KEY_F3:            std_logic_vector (7 downto 0) := X"04";
    Constant KEY_F4:            std_logic_vector (7 downto 0) := X"0C";
    Constant KEY_F5:            std_logic_vector (7 downto 0) := X"03";
    Constant KEY_F6:            std_logic_vector (7 downto 0) := X"0B";
    Constant KEY_F7:            std_logic_vector (7 downto 0) := X"83";
    Constant KEY_F8:            std_logic_vector (7 downto 0) := X"0A";
    Constant KEY_F9:            std_logic_vector (7 downto 0) := X"01";
    Constant KEY_F10:           std_logic_vector (7 downto 0) := X"09";
    Constant KEY_F11:           std_logic_vector (7 downto 0) := X"78";
    Constant KEY_F12:           std_logic_vector (7 downto 0) := X"07";
    Constant KEY_SCROLL:        std_logic_vector (7 downto 0) := X"7E";
    Constant KEY_RIGHT_BRACKET: std_logic_vector (7 downto 0) := X"54";
    Constant KEY_NUM:           std_logic_vector (7 downto 0) := X"77";
    Constant KEY_KP_ASTERISK:   std_logic_vector (7 downto 0) := X"7C";
    Constant KEY_KP_MINUS:      std_logic_vector (7 downto 0) := X"7B";
    Constant KEY_KP_PLUS:       std_logic_vector (7 downto 0) := X"79";
    Constant KEY_KP_PERIOD:     std_logic_vector (7 downto 0) := X"71";
    Constant KEY_KP_0:          std_logic_vector (7 downto 0) := X"70";
    Constant KEY_KP_1:          std_logic_vector (7 downto 0) := X"69";
    Constant KEY_KP_2:          std_logic_vector (7 downto 0) := X"72";
    Constant KEY_KP_3:          std_logic_vector (7 downto 0) := X"7A";
    Constant KEY_KP_4:          std_logic_vector (7 downto 0) := X"6B";
    Constant KEY_KP_5:          std_logic_vector (7 downto 0) := X"73";
    Constant KEY_KP_6:          std_logic_vector (7 downto 0) := X"74";
    Constant KEY_KP_7:          std_logic_vector (7 downto 0) := X"6C";
    Constant KEY_KP_8:          std_logic_vector (7 downto 0) := X"75";
    Constant KEY_KP_9:          std_logic_vector (7 downto 0) := X"7D";
    Constant KEY_LEFT_BRACKET:  std_logic_vector (7 downto 0) := X"5B";
    Constant KEY_SEMI_COLON:    std_logic_vector (7 downto 0) := X"4C";
    Constant KEY_ACCENT:        std_logic_vector (7 downto 0) := X"52";
    Constant KEY_COMMA:         std_logic_vector (7 downto 0) := X"41";
    Constant KEY_PERIOD:        std_logic_vector (7 downto 0) := X"49";
    Constant KEY_SLASH:         std_logic_vector (7 downto 0) := X"4A";

    -- Extended keys

    Constant E_KEY_KP_ENTER:    std_logic_vector (7 downto 0) := X"5A";
    Constant E_KEY_KP_SLASH:    std_logic_vector (7 downto 0) := X"4A";
    Constant E_KEY_R_ARROW:     std_logic_vector (7 downto 0) := X"74";
    Constant E_KEY_D_ARROW:     std_logic_vector (7 downto 0) := X"72";
    Constant E_KEY_L_ARROW:     std_logic_vector (7 downto 0) := X"6B";
    Constant E_KEY_U_ARROW:     std_logic_vector (7 downto 0) := X"75";
    Constant E_KEY_PG_DN:       std_logic_vector (7 downto 0) := X"7A";
    Constant E_KEY_END:         std_logic_vector (7 downto 0) := X"69";
    Constant E_KEY_DELETE:      std_logic_vector (7 downto 0) := X"71";
    Constant E_KEY_PG_UP:       std_logic_vector (7 downto 0) := X"7D";
    Constant E_KEY_HOME:        std_logic_vector (7 downto 0) := X"6C";
    Constant E_KEY_INSERT:      std_logic_vector (7 downto 0) := X"70";
    Constant E_KEY_APPS:        std_logic_vector (7 downto 0) := X"2F";
    Constant E_KEY_R_ALT:       std_logic_vector (7 downto 0) := X"11";
    Constant E_KEY_R_GUI:       std_logic_vector (7 downto 0) := X"27";
    Constant E_KEY_R_CTRL:      std_logic_vector (7 downto 0) := X"14";
    Constant E_KEY_L_GUI:       std_logic_vector (7 downto 0) := X"1F";

    -- Commands from PS2

    Constant C_KEY_EXTENSION:   std_logic_vector (7 downto 0) := X"E0";
    Constant C_KEY_BREAK:       std_logic_vector (7 downto 0) := X"F0";
    Constant C_KEY_ACKNOWLEDGE: std_logic_vector (7 downto 0) := X"FA";
    Constant C_KEY_RST_FAILED:  std_logic_vector (7 downto 0) := X"AA";
    Constant C_KEY_RST_PASSED:  std_logic_vector (7 downto 0) := X"FC";

    -- Commands from Host

    Constant C_KEY_RESET:       std_logic_vector (7 downto 0) := X"FF";
    Constant C_KEY_SCAN_CODE:   std_logic_vector (7 downto 0) := X"F0";
    Constant C_KEY_SET_LEDS:    std_logic_vector (7 downto 0) := X"ED";

begin

  proc_scan : process

  variable key_matrix : std_logic_vector(63 downto 0);

  variable extension : boolean;
  variable release : std_logic;
  variable wait_for_ack : boolean;
  variable wait_for_passed : boolean;
  variable wait_ps_busy_low : boolean;
  variable wait_psint_low : boolean;
  variable wait_cycles : integer range 0 to 255;
  
  subtype bv6 is bit_vector(5 to 0);

  begin
    wait until (clk = '1'); --  or (reset = '1');

    if reset = '1' then
      release := '1';
      extension := false;
      wait_psint_low := false;
      key_matrix := (others => '0');

    elsif (psint = '0') or (wait_psint_low = true) then

      if (psint = '0') then
        wait_psint_low := false;
      end if;

    else
      wait_psint_low := true;

      case psdatai is
        when C_KEY_EXTENSION   => extension       := true;
        when C_KEY_BREAK       => release         := '0';
        when C_KEY_ACKNOWLEDGE => wait_for_ack    := false;
        when C_KEY_RST_FAILED  => wait_for_passed := false;
        when C_KEY_RST_PASSED  => wait_for_passed := false;

        when others =>

          if extension = false then
            case psdatai is
				
              when KEY_APOSTROPHE => key_matrix(0) := release;	-- @
              when KEY_A          => key_matrix(1) := release;
              when KEY_B          => key_matrix(2) := release;
              when KEY_C          => key_matrix(3) := release;
              when KEY_D		    => key_matrix(4) := release;
              when KEY_E     		 => key_matrix(5) := release;
              when KEY_F     	    => key_matrix(6) := release;
              when KEY_G     		 => key_matrix(7) := release;

              when KEY_H          => key_matrix(8) := release;
              when KEY_I          => key_matrix(9) := release;
              when KEY_J          => key_matrix(10) := release;
              when KEY_K          => key_matrix(11) := release;
              when KEY_L      	 => key_matrix(12) := release;
              when KEY_M          => key_matrix(13) := release;
              when KEY_N          => key_matrix(14) := release;
              when KEY_O          => key_matrix(15) := release;

              when KEY_P          => key_matrix(16) := release;
              when KEY_Q          => key_matrix(17) := release;
              when KEY_R          => key_matrix(18) := release;
              when KEY_S          => key_matrix(19) := release;
              when KEY_T          => key_matrix(20) := release;
              when KEY_U          => key_matrix(21) := release;
              when KEY_V          => key_matrix(22) := release;
              when KEY_W          => key_matrix(23) := release;

              when KEY_X          => key_matrix(24) := release;
              when KEY_Y          => key_matrix(25) := release;
              when KEY_Z          => key_matrix(26) := release;
--              when KEY_           => key_matrix(27) := release;
--              when KEY_           => key_matrix(28) := release;
--              when KEY_           => key_matrix(29) := release;
--              when KEY_           => key_matrix(30) := release;
--              when KEY_           => key_matrix(31) := release;

              when KEY_0          => key_matrix(32) := release;
              when KEY_1          => key_matrix(33) := release;
              when KEY_2          => key_matrix(34) := release;
              when KEY_3          => key_matrix(35) := release;
              when KEY_4      	 => key_matrix(36) := release;
              when KEY_5      	 => key_matrix(37) := release;
              when KEY_6          => key_matrix(38) := release;
              when KEY_7          => key_matrix(39) := release;

              when KEY_8          => key_matrix(40) := release;
              when KEY_9	       => key_matrix(41) := release;
              when KEY_SEMI_COLON => key_matrix(42) := release;
              when KEY_ACCENT     => key_matrix(43) := release;				  
              when KEY_COMMA      => key_matrix(44) := release;
              when KEY_MINUS      => key_matrix(45) := release;
              when KEY_PERIOD     => key_matrix(46) := release;
              when KEY_SLASH      => key_matrix(47) := release;

              when KEY_ENTER      => key_matrix(48) := release;
              when KEY_BKSP       => key_matrix(49) := release;
              when KEY_ESC 		 => key_matrix(50) := release;

              when KEY_SPACE      => key_matrix(55) := release;

              when KEY_L_SHFT     => key_matrix(56) := release;
              when KEY_R_SHFT     => key_matrix(56) := release;

--		when x"06" => LookUp <= "1011100"; -- F2 ?
--		when x"04" => LookUp <= "1011101"; -- F3 ?
--		when x"0c" => LookUp <= "1011110"; -- F4 ?
--		when x"05" => LookUp <= "1011111"; -- F1 ?

              when others         => null;
            end case;

          else

            case psdatai is

              when E_KEY_KP_ENTER => key_matrix(48) := release;

              when E_KEY_U_ARROW  => key_matrix(51) := release;				  
              when E_KEY_D_ARROW  => key_matrix(52) := release;
              when E_KEY_L_ARROW  => key_matrix(53) := release;
              when E_KEY_R_ARROW  => key_matrix(54) := release;

              when others         => null;
            end case;
          end if;

          extension := false;
          release := '1';

      end case;
    end if;

	 sfrdatao(7 downto 0) <=
			  ( (key_matrix( 7 downto  0) and (std_logic_vector(7 downto 0)'range => addr(0)) ) or
				 (key_matrix(15 downto  8) and (std_logic_vector(7 downto 0)'range => addr(1)) ) or
				 (key_matrix(23 downto 16) and (std_logic_vector(7 downto 0)'range => addr(2)) ) or
				 (key_matrix(31 downto 24) and (std_logic_vector(7 downto 0)'range => addr(3)) ) or
				 (key_matrix(39 downto 32) and (std_logic_vector(7 downto 0)'range => addr(4)) ) or
				 (key_matrix(47 downto 40) and (std_logic_vector(7 downto 0)'range => addr(5)) ) or
				 (key_matrix(55 downto 48) and (std_logic_vector(7 downto 0)'range => addr(6)) ) or
				 (key_matrix(63 downto 56) and (std_logic_vector(7 downto 0)'range => addr(7)) ) );
  end process;

end behavioral;

