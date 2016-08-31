-------------------------------------------------------------------------------
Library IEEE;
Use IEEE.Std_Logic_1164.all;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
entity CodecDriver_DAC is port
   (
     CLK           : in    std_logic;
     RST           : in    std_logic;

     -- PLA Interface

     CASS_IN       : out   std_logic;
     CASS_OUT      : in    std_logic;

     -- SPI Interface

     Codec_DOUT    : out   std_logic;
     Codec_SCLK    : out   std_logic;
     Codec_nCS     : out   std_logic;
     Codec_DIN     : in    std_logic;

     -- Speaker

     SPEAKER       : out   std_logic;
     MUTE          : in    std_logic
   );
end CodecDriver_DAC;

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
Architecture RTL Of CodecDriver_DAC Is

-------------------------------------------------------------------------------
Subtype  State_TYPE is Std_Logic_Vector (3 downto 0);
Signal   State   :  State_TYPE;
Signal   Return1 :  State_TYPE;      --Return address for subroutine

Constant Configure                       : State_TYPE := "0000";
Constant Configure_Start                 : State_TYPE := "0001";
Constant Configure_SendConfigurationByte : State_TYPE := "0010";
Constant LatchDataIn                     : State_TYPE := "0011";
Constant ProcessByte                     : State_TYPE := "0100";
Constant SPI_sendReceive                 : State_TYPE := "0101";
Constant SPI_sendBit_out                 : State_TYPE := "0110";
Constant SPI_sendBit_in                  : State_TYPE := "0111";
Constant ProcessByte2                    : State_TYPE := "1000";
Constant ProcessByte3                    : State_TYPE := "1001";
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
subtype  Byte is Std_Logic_Vector (7 downto 0);
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
Constant cAudio_START                   : Byte := X"80";   --Start of control byte
Constant cAudio_DAC_Addressed           : Byte := X"40";   --A1  DAC_Addressed - The control byte configures the DAC
Constant cAudio_ADC_Addressed           : Byte := X"20";   --A0  ADC_Addressed - The control byte configures the ADC
Constant cAudio_ADC_InputC1             : Byte := X"10";   --C1  ADC_Input to VDD/2 to measure supply voltage (MAX1102-MAX1103 only)
Constant cAudio_ContinuousConversion    : Byte := X"08";   --C0  Mode_ContinuousConversion
Constant cAudio_EnableReferenceVoltage  : Byte := X"04";   --E2  EnableReferenceVoltage - don't care for MAX1104 so zero
Constant cAudio_ADC_Enable              : Byte := X"02";   --E1
Constant cAudio_DAC_Enable              : Byte := X"01";   --E0
Constant cAudio_Continuous              : Byte := cAudio_START                Or
                                                  cAudio_DAC_Addressed        Or
                                                  cAudio_ADC_Addressed        Or
                                                  cAudio_ContinuousConversion Or
                                                  cAudio_DAC_Enable           Or
                                                  cAudio_ADC_Enable;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
Begin
    SPEAKER <= CASS_OUT and not MUTE;

    FSM: Process (State,RST,CLK)

    Variable CountReg         : Natural range 0 to 7;            -- Bit send/receive Counter
    Variable CountDelay       : Natural range 0 to 360;          -- Tconv delay
    Variable spiReg           : Std_Logic_Vector (7 downto 0);   -- Bit In/Out shift register
    Variable hsReg            : Std_Logic_Vector (7 downto 0);   -- Bit In/Out shift register

    Begin
       If RST = '1' then
          State    <= Configure;
       ElsIf (CLK'event) and (CLK = '1') Then
           Case State is
               When Configure =>
                    Codec_nCS <= '1';
                    State     <= Configure_Start;

               When Configure_Start=>
                    Codec_nCS <= '0';
                    State     <= Configure_SendConfigurationByte;

               When Configure_SendConfigurationByte=>
                    spiReg    := cAudio_Continuous;
                    State     <= SPI_sendReceive;
                    -- D_OUT <= hsReg(6 DownTo 0) & Codec_DIN;     -- HS TEST
                    CountDelay  := 0;
                    return1   <= LatchDataIn;

               When LatchDataIn =>
                    CASS_IN     <= hsReg(0);    -- HS TEST
                    CountDelay  := 0;
                    State     <= ProcessByte2;

               When ProcessByte2 =>
                    CountDelay := CountDelay + 1;
                    State      <= ProcessByte3;

               When ProcessByte3 =>
                    If countDelay = 180 -- 247 -- 180   (512 -18 = 494)
                       Then
                             spiReg    := (others => CASS_OUT);
                             State     <= SPI_sendReceive;
                             return1   <= LatchDataIn;
                       Else  State     <= ProcessByte2;
                    End If;

               -------------------------------------------------
               -- Subroutine:  SPI_SendReceive (spiReg) : spiReg
               -- Postcondition Codec_SCLK_buffer = '0'
               -------------------------------------------------
               When SPI_sendReceive =>
                    CountReg          := 0;
                    Codec_DOUT        <= spiReg(7); -- _buffer
                    State             <= SPI_sendBit_out;                -- Send MSB to DOUT

               When SPI_sendBit_out =>
                    Codec_DOUT <= spiReg(7); -- _buffer HS HS2
--                    spiReg := spiReg(6 DownTo 0)& Codec_DIN;
                    hsReg  := hsReg (6 DownTo 0)& Codec_DIN;
                    Codec_SCLK <= '1'; -- _buffer
                    CountReg          := CountReg-1;
                    State             <= SPI_sendBit_in;

               When SPI_sendBit_in =>
                    Codec_SCLK <= '0'; -- _buffer
                    If countReg = 0
                       Then
                            State <= Return1;                            -- Exit Subroutine
                       Else
                            spiReg := spiReg(6 DownTo 0)& Codec_DIN; -- HSHS
                            -- Codec_DOUT <= spiReg(7);              -- Next bit ready _buffer
                            State <= SPI_sendBit_out;
                    End If;
               -------------------------------------------------

               When Others =>
                   State <= Configure;
           End Case;
       End If;
    End Process;
End RTL;
-------------------------------------------------------------------------------

