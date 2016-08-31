library IEEE;
use IEEE.std_logic_1164.all;

entity PS2_to_matrix is port
    (
    clk      : in  std_logic;
    reset    : in  std_logic;

    sfrdatao : out std_logic_vector(7 downto 0);
    addr     : in  std_logic_vector(15 downto 8);
    kbd_leds : in  std_logic_vector(2 downto 0);
    sensible : in  std_logic;

    psdatai  : in  std_logic_vector(7 downto 0);
    psdatao  : out std_logic_vector(7 downto 0);
    psstrobe : out std_logic;
    psbusy   : in  std_logic;
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

    Type states is
      (
      stateIdle,
      stateReset,
      stateResetSentCode1,
      stateResetSentCode2,
--    stateResetSentCode3,
--    stateResetSentCode4,
--    stateResetSentCode5,
--    stateResetSentCode6,
      stateSetKbdLeds,
      stateSetKbdLeds1,
      stateSetKbdLeds2,
      stateSetKbdLeds3
      );
  variable state : states;

  variable key_matrix : std_logic_vector(47 downto 0);
  variable sensible_key_matrix : std_logic_vector(47 downto 0);

  variable extension : boolean;
  variable break : std_logic;
  variable old_kbd_leds : std_logic_vector (2 downto 0);
  variable wait_for_ack : boolean;
  variable wait_for_passed : boolean;
  variable wait_ps_busy_low : boolean;
  variable wait_psint_low : boolean;
  variable wait_cycles : integer range 0 to 255;
  variable col1 : std_logic_vector(5 downto 0);
  variable col2 : std_logic_vector(5 downto 0);
  variable col3 : std_logic_vector(5 downto 0);
  variable col4 : std_logic_vector(5 downto 0);
  variable col5 : std_logic_vector(5 downto 0);
  variable col6 : std_logic_vector(5 downto 0);
  variable col7 : std_logic_vector(5 downto 0);
  variable col8 : std_logic_vector(5 downto 0);
  
  subtype bv6 is bit_vector(5 to 0);

  -- Variable column : std_logic_vector(5 downto 0);

  begin
    wait until (clk = '1'); --  or (reset = '1');

    if reset = '1' then
      break := '0';
      extension := false;
      wait_psint_low := false;
      psstrobe <= '0';
      key_matrix := (others => '1');

    elsif (psint = '0') or (wait_psint_low = true) then

      if (psint = '0') then
        wait_psint_low := false;
      end if;

    else
      wait_psint_low := true;

      case psdatai is
        when C_KEY_EXTENSION   => extension       := true;
        when C_KEY_BREAK       => break           := '1';
        when C_KEY_ACKNOWLEDGE => wait_for_ack    := false;
        when C_KEY_RST_FAILED  => wait_for_passed := false;
        when C_KEY_RST_PASSED  => wait_for_passed := false;

        when others =>

          if extension = false then
            case psdatai is
              when KEY_2          => key_matrix(0) := break;
              when KEY_W          => key_matrix(1) := break;
              when KEY_1          => key_matrix(2) := break;
              when KEY_Q          => key_matrix(3) := break;
              when KEY_L_SHFT     => key_matrix(4) := break;
              when KEY_R_SHFT     => key_matrix(4) := break;
              when KEY_L_CTRL     => key_matrix(5) := break;

              when KEY_3          => key_matrix(6) := break;
              when KEY_E          => key_matrix(7) := break;
              when KEY_S          => key_matrix(8) := break;
              when KEY_Z          => key_matrix(9) := break;
              when KEY_SPACE      => key_matrix(10) := break;
              when KEY_A          => key_matrix(11) := break;

              when KEY_5          => key_matrix(12) := break;
              when KEY_T          => key_matrix(13) := break;
              when KEY_4          => key_matrix(14) := break;
              when KEY_R          => key_matrix(15) := break;
              when KEY_D          => key_matrix(16) := break;
              when KEY_X          => key_matrix(17) := break;

              when KEY_6          => key_matrix(18) := break;
              when KEY_Y          => key_matrix(19) := break;
              when KEY_G          => key_matrix(20) := break;
              when KEY_V          => key_matrix(21) := break;
              when KEY_C          => key_matrix(22) := break;
              when KEY_F          => key_matrix(23) := break;

              when KEY_8          => key_matrix(24) := break;
              when KEY_I          => key_matrix(25) := break;
              when KEY_7          => key_matrix(26) := break;
              when KEY_U          => key_matrix(27) := break;
              when KEY_H          => key_matrix(28) := break;
              when KEY_B          => key_matrix(29) := break;

              when KEY_9          => key_matrix(30) := break;
              when KEY_O          => key_matrix(31) := break;
              when KEY_K          => key_matrix(32) := break;
              when KEY_M          => key_matrix(33) := break;
              when KEY_N          => key_matrix(34) := break;
              when KEY_J          => key_matrix(35) := break;

              when KEY_MINUS      => key_matrix(36) := break;
              when KEY_SLASH      => key_matrix(37) := break;
              when KEY_0          => key_matrix(38) := break;
              when KEY_P          => key_matrix(39) := break;
              when KEY_L          => key_matrix(40) := break;
              when KEY_COMMA      => key_matrix(41) := break;

              when KEY_EQUAL      => key_matrix(42) := break;
              when KEY_BKSP       => key_matrix(43) := break;
              when KEY_ACCENT     => key_matrix(44) := break;
              when KEY_ENTER      => key_matrix(45) := break;
              when KEY_SEMI_COLON => key_matrix(46) := break;
              when KEY_PERIOD     => key_matrix(47) := break;

              when others         => null;
            end case;

          else

            case psdatai is

              when E_KEY_R_CTRL   => key_matrix(5) := break;
              when E_KEY_KP_ENTER => key_matrix(45) := break;

              when others         => null;
            end case;
          end if;

          extension := false;
          break := '0';

      end case;
    end if;

    if (sensible = '1') then
       sensible_key_matrix := key_matrix;

       if (key_matrix(4) = '0') then                         -- Ibm        Aqu
              sensible_key_matrix( 0) := key_matrix(44);     -- Shift-' -> Shift-2   """
       --     sensible_key_matrix(44) := key_matrix(24);     -- Shift-8 -> Shift-'   "*"
              sensible_key_matrix(24) := key_matrix(30);     -- Shift-9 -> Shift-8   "("
              sensible_key_matrix(30) := key_matrix(38);     -- Shift-0 -> Shift-9   ")"
              sensible_key_matrix(38) := key_matrix(37);     -- Shift-/ -> Shift-0   "?"
              sensible_key_matrix(37) := key_matrix(18);     -- Shift-6 -> Shift-/   "^"
              sensible_key_matrix(18) := key_matrix(26);     -- Shift-7 -> Shift-6   "&"
        --    sensible_key_matrix(26) := key_matrix(44);     -- '       -> Shift-7   "'"  HS
        --    sensible_key_matrix(44) := key_matrix(46);     -- Shift-; -> '         ";"  HS
              sensible_key_matrix(46) := key_matrix( 0);     -- Shift-2 -> Shift-;   "@"  HS

              sensible_key_matrix( 4) := not key_matrix(46);
              sensible_key_matrix(44) := key_matrix(46) and key_matrix(24);
       else
              sensible_key_matrix( 4) := key_matrix(44);
              sensible_key_matrix(26) := key_matrix(44);
       end if;

       sfrdatao(5 downto 0) <=
              ( (sensible_key_matrix( 5 downto  0) ) and
                (sensible_key_matrix(11 downto  6) ) and
                (sensible_key_matrix(17 downto 12) ) and
                (sensible_key_matrix(23 downto 18) ) and
                (sensible_key_matrix(29 downto 24) ) and
                (sensible_key_matrix(35 downto 30) ) and
                (sensible_key_matrix(41 downto 36) ) and
                (sensible_key_matrix(47 downto 42) ) );
    else

		 if (addr(8) = '0') then
		  col1 := "000000";
		 else
		  col1 := "111111";
		 end if;
		 if (addr(9) = '0') then
		  col2 := "000000";
		 else
		  col2 := "111111";
		 end if;
		 if (addr(10) = '0') then
		  col3 := "000000";
		 else
		  col3 := "111111";
		 end if;
		 if (addr(11) = '0') then
		  col4 := "000000";
		 else
		  col4 := "111111";
		 end if;
		 if (addr(12) = '0') then
		  col5 := "000000";
		 else
		  col5 := "111111";
		 end if;
		 if (addr(13) = '0') then
		  col6 := "000000";
		 else
		  col6 := "111111";
		 end if;
		 if (addr(14) = '0') then
		  col7 := "000000";
		 else
		  col7 := "111111";
		 end if;
		 if (addr(15) = '0') then
		  col8 := "000000";
		 else
		  col8 := "111111";
		 end if;
		 
       sfrdatao(5 downto 0) <=
              ( (key_matrix( 5 downto  0) or col8 ) and
                (key_matrix(11 downto  6) or col7 ) and
                (key_matrix(17 downto 12) or col6 ) and
                (key_matrix(23 downto 18) or col5 ) and
                (key_matrix(29 downto 24) or col4 ) and
                (key_matrix(35 downto 30) or col3 ) and
                (key_matrix(41 downto 36) or col2 ) and
                (key_matrix(47 downto 42) or col1 ) );
    end if;
  end process;

  sfrdatao(7 downto 6) <= "11";

end behavioral;

