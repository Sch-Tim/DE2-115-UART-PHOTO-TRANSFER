library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity CAMERA_CONFIGURATOR is
  generic (
    ---------------------
    -- Camera Settings --
    ---------------------

    -- The following register descriptions are taken from the camera documentation
    -- available at the manufacturer's webpage. https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=68&No=281&PartNo=3#contents

    --------------------
    -- Row start (R1) --
    --------------------

    --! y coordinate of the upper-left corner of the field of view. Has to be even!
    G_ROW_START                 : integer range 0 to 2004   := 54;

    -----------------------
    -- Column start (R2) --
    -----------------------

    --! x coordinate of the upper-left corner of the field of view.
    --! The value will be rounded down to the nearest multiple of 2 times the column bin factor.
    G_COLUMN_START              : integer range 0 to 2750   := 16;

    -------------------
    -- Row size (R3) --
    -------------------

    --! The height of the field of view minus one.
    --! Has to be odd!
    G_ROW_SIZE                  : integer range 1 to 2751   := 1919;

    ----------------------
    -- Column Size (R4) --
    ----------------------

    --! The width of the field of view minus one.
    --! Has to be odd. It should be (2*n*(Column_Bin + 1) - 1) for some integer n.
    G_COLUMN_SIZE               : integer range 1 to 2751   := 2559;

    ---------------------------
    -- Horizontal blank (R5) --
    ---------------------------

    --! Extra time added to the end of each row, in pixel clocks.
    --! Incrementing this register will increase exposure and decrease frame rate.
    G_HORIZONTAL_BLANK          : integer range 0 to 4095   := 0;

    -------------------------
    -- Vertical blank (R6) --
    -------------------------

    --! Extra time added to the end of each frame in rows minus one.
    --! Incrementing this register will decrease frame rate, but not affect exposure.
    G_VERTICAL_BLANK            : integer range 8 to 2047   := 8;

    -------------------------
    -- Output control (R7) --
    -------------------------

    --! Controls the slew rate on digital output pads except for PIXCLK.
    --! Higher values imply faster transition times.
    G_OUTPUT_SLEW_RATE          : integer range 0 to 7      := 7;

    --! Controls the slew rate on the PIXCLK pad.
    --! Higher values imply faster transition times.
    G_PIXCLK_SLEW_RATE          : integer range 0 to 7      := 7;

    --! When set, pixels will be sent through the output FIFO before being sent off chip.
    --! This allows the output port to be running at a slower speed than f_PIXCLK,
    --! since the FIFO allows for pixels to be output during horizontal blank.
    --! Use of this mode requires the PLL to be set up properly.
    G_FIFO_PARALLEL_DATA        : std_logic                 := '0';

    ----------------------------
    -- Shutter width (R8, R9) --
    ----------------------------

    --! The most significant bits of the shutter width, which are combined with Shutter Width Lower.
    G_SHUTTER_WIDTH_UPPER       : integer range 0 to 65535  := 0;

    --! The least significant bits of the shutter width.
    --! This is combined with Shutter_Width_Upper and Shutter_Delay for the effective shutter width.
    G_SHUTTER_WIDTH_LOWER       : integer range 1 to 65535  := 1984;

    ------------------------------------
    -- Pixel Clock Control (R10; x0A) --
    ------------------------------------

    --! When set, LVAL, FVAL, and D[11:0] should be captured on the rising
    --! edge of PIXCLK. When clear, they should be captured on the falling edge.
    G_INVERT_PIXEL_CLOCK        : std_logic                 := '1';

    --! Value representing how far to shift the PIXCLK output pin relative to D, in XCLKIN cycles.
    --! Positive values shift PIXCLK later in time relative to D
    --! (and thus relative to the internal array/datapath clock).
    --! No effect unless PIXCLK is divided by Divide Pixel Clock.
    G_SHIFT_PIXEL_CLOCK         : integer range -2 to 2     := 0;

    --! Produces a PIXCLK that is divided by the value times two.
    --! The value must be zero or a power of 2.
    --! This will slow down the internal clock in the array control and datapath blocks, including pixel readout.
    --! It will not affect the two-wire serial interface clock.
    G_DIVIDE_PIXEL_CLOCK        : integer range 0 to 64     := 0;

    ------------------------------
    -- Shutter delay (R12; x0C) --
    ------------------------------

    --! A negative adjustment to the effective shutter width in ACLKs. See Shutter_Width_Lower.
    G_SHUTTER_DELAY             : integer range 0 to 8191   := 0;

    ----------------------------
    -- PLL control (R16; x10) --
    ----------------------------

    --! When set, use the PLL output as the system clock.
    --! When clear, use XCLKIN as the system clock.
    G_USE_PLL                   : std_logic                 := '0';

    -----------------------------
    -- PLL config 1 (R17; x11) --
    -----------------------------

    --! PLL output frequency multiplier.
    G_PLL_M_FACTOR              : integer range 16 to 255   := 72;

    --! PLL output frequency divider minus 1.
    G_PLL_N_DIVIDER             : integer range 0 to 63     := 5;

    -----------------------------
    -- PLL config 2 (R18; x12) --
    -----------------------------

    --! PLL system clock divider minus 1. If this is set to an even number,
    --! the system clock duty cycle will not be 50:50.
    --! In this case, set all bits in R101 or slow down XCLKIN.
    G_PLL_P1_DIVIDER            : integer range 0 to 127    := 2;

    ---------------------------
    -- Read mode 1 (R30; 1E) --
    ---------------------------

    --! When set, produce a LVAL signal that is the XOR of FVAL and the normal line_valid.
    G_XOR_LINE_VALID            : std_logic                 := '0';

    --! When set, produce the LVAL signal even during the vertical blank period.
    --! When clear, produce LVAL only when active rows are being read out
    --! (that is, only when FVAL is high).
    --! Ineffective if FIFO_Parallel_Data is set.
    G_CONTINOUS_LINE_VALID      : std_logic                 := '0';

    --! When set, the sense of the TRIGGER input pin will be inverted.
    G_INVERT_TRIGGER            : std_logic                 := '0';

    --! When set, the sensor enters snapshot mode, and will wait for a trigger event between frames
    G_SNAPSHOT_MODE             : std_logic                 := '0';

    --! When set, the Global Reset Release shutter will be used.
    --! When clear, the Electronic Rolling Shutter will be used.
    G_GLOBAL_RESET_MODE         : std_logic                 := '0';

    --! When set, exposure time will be controlled by an external trigger.
    --! When clear, exposure time will be controlled by the Shutter_Width_Lower and
    --! Shutter_Width_Upper registers.
    G_BULB_EXPOSURE             : std_logic                 := '0';

    --! When set, the STROBE signal will be active LOW (during exposure).
    --! When clear, the STROBE signal is active HIGH
    G_INVERT_STROBE             : std_logic                 := '0';

    --! When set, a strobe signal will be generated by the digital logic during integration.
    --! When clear, the strobe pin will be set to the value of Invert_Strobe.
    G_STROBE_ENABLE             : std_logic                 := '0';

    --! Determines the timepoint when the strobe is asserted.
    --! 0 – first trigger
    --! 1 – start of simultaneous exposure
    --! 2 – shutter width
    --! 3 – second trigger
    G_STROBE_START              : integer range 0 to 3      := 1;

    --! Determines the timepoint when the strobe is negated.
    --! If this is set equal to or less than Strobe_Start, the width of the strobe pulse will be t_ROW.
    --! See Strobe_Start.
    G_STROBE_END                : integer range 0 to 3      := 2;

    ----------------------------
    -- Read Mode 2 (R32 Rx20) --
    ----------------------------

    --! When set, row readout in the active image occurs in reverse numerical
    --! order starting from (Row_Start + Row_Size).
    --! When clear, row readout of the active image occurs in numerical order
    G_MIRROR_ROW                : std_logic                 := '1';

    --! When set, column readout in the active image occurs in reverse
    --! numerical order, starting from (Column_Start + Column_Size).
    --! When clear, column readout of the active image occurs in numerical order.
    G_MIRROR_COL                : std_logic                 := '0';

    --! When set, the dark columns will be output to the left of the active image,
    --! making the output image wider.
    G_SHOW_DARK_COLS            : std_logic                 := '0';

    --! When set, the dark rows will be output before the active image rows,
    --! making the output image taller.
    G_SHOW_DARK_ROWS            : std_logic                 := '0';

    --! When set, digitally compensate for differing black levels between rows
    --! by adding Dark Target (R73) and subtracting the average value of the 8
    --! same-color dark pixels at the beginning of the row. When clear, digitally
    --! add Row Black Default Offset (R75) to the value of each pixel
    --! **turn off in test mode**
    G_ROW_BLC                   : std_logic                 := '0';

    --! When set, column summing will be enabled, and in column bin modes,
    --! all sampled capacitors will be enabled for column readout, resulting in
    --! an effective gain equal to the column bin factor. When clear, column
    --! averaging will be done, and there will be no additional gain related to the
    --! column bin factor.
    G_COL_SUM                   : std_logic                 := '0';

    ---------------------------------
    -- Row address mode (R34; x22) --
    ---------------------------------

    --! The number of rows to be read and averaged per row output minus one.
    G_ROW_BIN                   : integer range 0 to 3      := 0;

    --! The number of row-pairs to skip for every row-pair output.
    --! A value of zero means to read every row.
    --! For Skip 2X, this should be 1; for Skip 3X, it should be 2, and so on.
    G_ROW_SKIP                  : integer range 0 to 7      := 1;

    ------------------------------------
    -- Column address mode (R35; x23) --
    ------------------------------------

    --! The number of columns to be read and averaged per column output minus one.
    --! For normal readout, this should be zero.
    --! For Bin 2X, it should be 1; for Bin 4X, it should be 3.
    G_COLUMN_BIN                : integer range 0 to 3      := 0;

    --! The number of column-pairs to skip for every column-pair output.
    --! A value of zero means to read every column in the active image.
    --! For Skip 2X, this should be 1; for Skip 3X, this should be 2, and so on.
    --! This value should be no less than Column_Bin.
    --! For full binning, Column_Skip should equal Column_Bin.
    G_COLUMN_SKIP               : integer range 0 to 6      := 1;

    -- !! ATTENTION !! --
    -- Setting the gain values while the camera is operating can prevent it from working at all.
    -- Symptom is a flickering and distorted image.
    -- The workaround is to set the restart and restart_sync bits to halt the camera and
    -- reset the restart_sync bit afterwards as it's done in this code.

    -----------------------------
    -- Green 1 Gain (R43; x2B) --
    -----------------------------

    --! Digital Gain for the Green1 channel minus 1 times 8.
    --! The actual digital gain is (1 + value/8),
    --! and can range from 1 (a setting of 0) to 16 (a setting of 120) in increments of 1/8.
    G_GREEN1_DIGITAL_GAIN       : integer range 0 to 120    := 0;

    --! Analog gain multiplier for the Green1 channel minus 1.
    --! If 1, an additional analog gain of 2x will be applied.
    --! If 0, no additional gain is applied.
    G_GREEN1_ANALOG_MULTIPLIER  : std_logic                 := '0';

    --! Analog gain setting for the Green1 channel times 8.
    --! The effective gain for the channel is
    --! (((Green1_Digital_Gain/8) + 1) * (Green1_Analog_Multiplier + 1) * (Green1_Analog_Gain/ 8)).
    G_GREEN1_ANALOG_GAIN        : integer range 8 to 63     := 19;

    --------------------------
    -- Blue Gain (R44; x2C) --
    --------------------------

    --! Digital Gain for the Blue channel minus 1 times 8.
    --! The actual digital gain is (1 + value/8),
    --! and can range from 1 (a setting of 0) to 16 (a setting of  120) in increments of 1/8.
    G_BLUE_DIGITAL_GAIN         : integer range 0 to 120    := 0;

    --! Analog gain multiplier for the Blue channel minus 1.
    --! If 1, an additional analog gain of 2X will be applied. If 0, no additional gain is applied.
    G_BLUE_ANALOG_MULTIPLIER    : std_logic                 := '0';

    --! Analog gain setting for the Blue channel times 8.
    --! The effective gain for the channel is
    --! (((Blue_Digital_Gain/8) + 1) * (Blue_Analog_Multiplier + 1) * (Blue_Analog_Gain/8)).
    G_BLUE_ANALOG_GAIN          : integer                   := 26;

    -------------------------
    -- Red Gain (R45; x2D) --
    -------------------------

    --! Digital Gain for the Red channel minus 1 times 8.
    --! The actual digital gain is (1 + value/8)
    --! and can range from 1 (a setting of 0) to 16
    --! (a setting of 120) in increments of 1/8.
    G_RED_DIGITAL_GAIN          : integer range 0 to 120    := 0;

    --! Analog gain multiplier for the Red channel minus 1.
    --! If 1, an additional analog gain of 2X will be applied.
    --! If 0, no additional gain is applied.
    G_RED_ANALOG_MULTIPLIER     : std_logic                 := '0';

    --! Analog gain setting for the Red channel times 8.
    --! The effective gain for the channel is
    --! (((Red_Digital_Gain/8) + 1) * (Red_Analog_Multiplier + 1) * (Red_Analog_Gain/8)
    G_RED_ANALOG_GAIN           : integer range 8 to 63     := 28;

    -----------------------------
    -- Green 2 Gain (R46; x2E) --
    -----------------------------

    --! Digital Gain for the Green2 channel minus 1 times 8.
    --! The actual digital gain is (1 + value/8)
    --! and can range from 1 (a setting of 0) to 16 (a setting of 120) in increments of 1/8 .
    G_GREEN2_DIGITAL_GAIN       : integer range 0 to 120    := 0;

    --! Analog gain multiplier for the Green2 channel minus 1.
    --! If 1, an additional analog gain of 2x will be applied. If 0, no additional gain is applied.
    --! Writes are synchronized to frame boundaries.
    G_GREEN2_ANALOG_MULTIPLIER  : std_logic                 := '0';

    --! Analog gain setting for the Green2 channel times 8.
    --! The effective gain for the channel is
    --! (((Green2_Digital_Gain/8) + 1) * (Green2_Analog_Multiplier + 1) * (Green2_Analog_Gain/ 8)).
    G_GREEN2_ANALOG_GAIN        : integer range 8 to 63     := 19;

    ----------------------------------
    -- Row Black Target (R73; x49) --
    ---------------------------------

    G_ROW_BLACK_TARGET          : integer range 0 to 65535  := 424;

    -----------------------------------------
    -- Row Black Default Offset (R75; x4B) --
    -----------------------------------------

    --! A two's-compliment offset digitally added to all active image pixel values
    --! when Row BLC (R30[6]) is disabled.
    G_ROW_BLACK_DEFAULT_OFFSET  : integer range 0 to 4095   := 0;

    --------------------------------
    -- BLC Sample Size (R91; x5B) --
    --------------------------------

    --! If set, the "moving average" calculation in the BLC algorithm will use a sample size of 32.
    --! If clear, it will use a sample size of 1
    --! (that is, each frame's black level will be considered independent of other frames).
    G_BLC_SAMPLE_SIZE           : std_logic                 := '1';

    ---------------------------
    -- BLC Tune 1 (R92; x5C) --
    ---------------------------
    --! A number subtracted from the calculated correction's magnitude when
    --! in delta mode. Setting this to a positive number will correct by that much
    --! less than the delta value. A negative number will correct by more
    --! (possibly worsening the overshoot).
    --! This applies to the magnitude of the delta, so a positive damping value will be subtracted
    --! from a positive delta and added to a negative delta.
    G_BLC_DELTA_DAMPING         : integer range -8 to 7     := 0;

    --! The number of pixclks it takes for a newly set offset to take effect
    --! divided by 2. Used to configure the fast sample algorithm.
    --! After setting a calibration value in fast sample mode,
    --! (value * 2) pixclks will elapse before the next sample is taken.
    G_BLC_DAC_SETTLING_TIME     : integer range 0 to 255    := 90;

    -------------------------------------
    -- BLC Delta Thresholds (R93; x5D) --
    -------------------------------------

    --! Upper delta threshold divided by 4. If the average black value for a color
    --! is higher than this value times 4 or lower than BLC_Low_Delta_Threshold times 4,
    --! the fast sampling and binary search modes will be activated (if enabled).
    --! Once the black level is between the BLC_High_Delta_Threshold and the BLC_Low_Delta_Threshold,
    --! the delta adjustment mode will be used (though fast sample mode will continue until the end of the frame).
    --! This value should be set no lower than BLC High Target Threshold.
    G_BLC_HIGH_DELTA_THRESHOLD  : integer range 0 to 127    := 45;

    --! Lower delta threshold divided by 4. See BLC_High_Delta_Threshold.
    --! Should be no higher than BLC_Low_Target_Threshold.
    G_BLC_LOW_DELTA_THRESHOLD   : integer range 0 to 127    := 19;

    ---------------------------
    -- BLC Tune 2 (R94; x5E) --
    ---------------------------

    --! Base 2 log of the change in pixel value (in LSBs) of a pixel when the
    --! analog offset is changed by one.
    G_BLC_STEP_SIZE             : integer range 0 to 4      := 4;

    --! The maximum adjustment (positive or negative) that the BLC delta
    --! adjustment mode is allowed to make to the analog offset.
    G_BLC_MAX_ADJUST            : integer range 1 to 511    := 511;

    --------------------------------------
    -- BLC Target Thresholds (R95; x5F) --
    --------------------------------------

    --! The upper target threshold of the BLC algorithm divided by 4.
    --! The target black value is 4 times the average of the BLC_High_Target_Threshold
    --! and the BLC_Low_Target_Threshold. When the black value for a color is
    --! within these thresholds, it will be considered to be on target.
    G_BLC_HIGH_TARGET_THRESHOLD : integer range 0 to 127    := 35;

    --! The lower target threshold for the BLC algorithm divided by 4.
    --! See BLC High Target Threshold above.
    G_BLC_LOW_TARGET_THRESHOLD  : integer range 0 to 127    := 29;

    -------------------------------
    -- Green 1 Offset (R96; x60) --
    -------------------------------
    --! Representation of the analog offset value for Green1. If Manual_BLC (R98[0])
    --! is set, this value will be used as the analog offset. Otherwise, the value may be overridden by
    --! the BLC algorithm. When read, this register returns the offset currently in use.
    --! The user-programmed value is always retained internally, and may be read by setting Manual_BLC.
    G_GREEN1_OFFSET             : integer range -255 to 255 := 32;

    -------------------------------
    -- Green 2 Offset (R97; x61) --
    -------------------------------

    --! See Green 1 offset.
    G_GREEN2_OFFSET             : integer range -255 to 255 := 32;

    ----------------------------------------
    -- Black level calibration (R98; x62) --
    ----------------------------------------

    --! When set, the fast sampling mode (multiple samples per frame) will not
    --! be used if the black level falls outside the delta thresholds; instead, only
    --! one sample-adjust will take place per frame. Binary search mode may
    --! still be used. When clear, fast sample mode will be used when necessary.
    G_DISABLE_FAST_SAMPLE       : std_logic                 := '0';

    --! When set, the calibration offset chosen for Green1 will be used for
    --! Green2 pixels as well. Only effective if Green1_Analog_Gain equals
    --! Green2_Analog_Gain and Green1_Analog_Multiplier equals Green2_Analog_Multiplier.
    G_LOCK_GREEN_CALIBRATION    : std_logic                 := '0';

    --! When set, the calibration offset chosen for Red will be used for Blue
    --! pixels as well. Only effective if Red_Analog_Gain equals
    --! Blue_Analog_Gain and Red_Analog_Multiplier equals Blue_Analog_Multiplier.
    G_LOCK_RED_BLUE_CALIBRATION : std_logic                 := '0';

    --! When set, any running averages will be reset and the fast sample and
    --! binary search modes will be activated (if enabled).
    G_RECALCULATE_BLACK_LEVEL   : std_logic                 := '0';

    --! When set, binary search mode will not be used when the black level falls
    --! outside the delta thresholds; instead the delta mode will be used.
    --! Fast sampling mode may still be used if enabled.
    G_DISABLE_BINARY_SEARCH     : std_logic                 := '0';

    --! When set, analog calibration is disabled.
    --! When clear, the programmed or automatic offsets will be used.
    G_DISABLE_CALIBRATION       : std_logic                 := '0';

    --! When set, the user programmed calibration offsets from R96-R97 and
    --! R99-R100 will be used. Also, black level calculation will be disabled.
    --! When clear, the BLC algorithm will adjust the offsets to maintain the
    --! target black level. Issue a Restart after clearing this register to avoid
    --! updating offsets based on corrupt black rows.
    --! If this bit is 1, Show_Dark_Rows must be set to allow channel offset
    --! correction to function properly.
    G_MANUAL_BLC                : std_logic                 := '0';

    -- !! ATTENTION !! --
    -- Setting the gain values while the camera is operating can prevent it from working at all.
    -- Symptom is no signal at all.
    -- The workaround is to set the restart and restart_sync bits to halt the camera and
    -- reset the restart_sync bit afterwards as it's done in this code.

    ---------------------------
    -- Red offset (R99; x63) --
    ---------------------------
    --! Representation of the analog offset value for Red.
    --! See Green1_Offset. Writes are synchronized to frame boundaries.
    G_RED_OFFSET                : integer range -255 to 255 := 32;

    -- Blue Offset (R100; x64)
    --! Representation of the analog offset value for Blue. See Green1_Offset.
    G_BLUE_OFFSET               : integer range -255 to 255 := 32;

    --------------------------------------
    -- Test Pattern control (R160; xA0) --
    --------------------------------------

    --! Sets the test pattern mode, see docs for details.
    G_TEST_PATTERN_MODE         : integer range 0 to 8      := 1;

    --! use test pattern or real image
    G_ACTIVATE_TEST_PATTERN     : std_logic                 := '1';

    --! used value for red in test mode
    G_TEST_PATTERN_RED          : integer range 0 to 4095   := 1000;

    --! used value for green in test mode
    G_TEST_PATTERN_GREEN        : integer range 0 to 4095   := 2000;

    --! used value for blue in test mode
    G_TEST_PATTERN_BLUE         : integer range 0 to 4095   := 3000;

    --! width of the bar in mode 6 and 7
    G_TEST_PATTERN_BAR_WIDTH    : integer range 0 to 4095   := 25
  );
  port (
    I_CLOCK                      : in    std_logic;
    I_I2C_CLOCK                  : in    std_logic;
    I_RESET_N                    : in    std_logic;
    I_START_CONFIGURATION        : in    std_logic;

    IO_SDATA                     : inout std_logic;
    O_SCLK                       : out   std_logic;
    O_CONFIGURATION_FINISHED     : out   std_logic
  );
end entity CAMERA_CONFIGURATOR;

architecture ARCH of CAMERA_CONFIGURATOR is

  constant c_lut_size                      : integer := 41;

  type t_i2c_lut is array (0 to c_lut_size) of std_logic_vector(23 downto 0);

  type t_states is (
    IDLE,
    CAMERA_WAIT_I2C_START,
    CAMERA_WAIT_I2C_FINISH,
    CAMERA_CONFIG_FINISHED
  );

  signal r_lut_pointer                     : integer range 0 to c_lut_size := 0;
  signal r_lut_pointer_locked              : std_logic                         := '0';

  signal r_current_state                   : t_states := IDLE;
  signal w_next_state                      : t_states;

  signal w_i2c_we                          : std_logic;
  signal w_i2c_start_n                     : std_logic;
  signal w_i2c_address                     : std_logic_vector(7 downto 0);
  signal w_i2c_data                        : std_logic_vector(15 downto 0);
  signal w_i2c_q                           : std_logic_vector(15 downto 0);
  signal w_i2c_error                       : std_logic;
  signal w_i2c_valid                       : std_logic;
  signal w_i2c_ready                       : std_logic;
  signal w_i2c_config_finished             : std_logic;

  --vhdl_comp_off 
  constant c_i2c_lut : t_i2c_lut :=
  (
    x"0B" & "0000000000000011", -- stop camera while setting the values
    x"01" & std_logic_vector(to_unsigned(G_ROW_START, 16)),
    x"02" & std_logic_vector(to_unsigned(G_COLUMN_START, 16)),
    x"03" & std_logic_vector(to_unsigned(G_ROW_SIZE, 16)),
    x"04" & std_logic_vector(to_unsigned(G_COLUMN_SIZE, 16)),
    x"05" & std_logic_vector(to_unsigned(G_HORIZONTAL_BLANK, 16)),
    x"06" & std_logic_vector(to_unsigned(G_VERTICAL_BLANK, 16)),
    x"07" & "000" & std_logic_vector(to_unsigned(G_OUTPUT_SLEW_RATE, 3)) & std_logic_vector(to_unsigned(G_PIXCLK_SLEW_RATE, 3)) & "0000" & G_FIFO_PARALLEL_DATA & "10",
    x"08" & std_logic_vector(to_unsigned(G_SHUTTER_WIDTH_UPPER, 16)),
    x"09" & std_logic_vector(to_unsigned(G_SHUTTER_WIDTH_LOWER, 16)),
    x"0A" & G_INVERT_PIXEL_CLOCK & "0000" & std_logic_vector(to_signed(G_SHIFT_PIXEL_CLOCK, 3)) & "0" & std_logic_vector(to_unsigned(G_DIVIDE_PIXEL_CLOCK, 7)),
    x"0C" & std_logic_vector(to_unsigned(G_SHUTTER_DELAY, 16)),
    x"10" & "00000000001000" & '0' & G_USE_PLL,
    x"11" & std_logic_vector(to_unsigned(G_PLL_M_FACTOR, 8)) & "00" & std_logic_vector(to_unsigned(G_PLL_N_DIVIDER, 6)),
    x"12" & "00000000000" & std_logic_vector(to_unsigned(G_PLL_P1_DIVIDER, 5)),
	  x"10" & "00000000001000" & G_USE_PLL & G_USE_PLL,
    x"1E" & "0100" & G_XOR_LINE_VALID & G_CONTINOUS_LINE_VALID & G_INVERT_TRIGGER & G_SNAPSHOT_MODE & G_GLOBAL_RESET_MODE & G_BULB_EXPOSURE & G_INVERT_STROBE & G_STROBE_ENABLE & std_logic_vector(to_unsigned(G_STROBE_START, 2)) & std_logic_vector(to_unsigned(G_STROBE_END, 2)),
    x"20" & G_MIRROR_ROW & G_MIRROR_COL & "0" & G_SHOW_DARK_COLS & G_SHOW_DARK_ROWS & "0000" & G_ROW_BLC & G_COL_SUM & "00000",
    x"22" & "0000000000" & std_logic_vector(to_unsigned(G_ROW_BIN, 2)) & "0" & std_logic_vector(to_unsigned(G_ROW_SKIP, 3)),
    x"23" & "0000000000" & std_logic_vector(to_unsigned(G_COLUMN_BIN, 2)) & "0" & std_logic_vector(to_unsigned(G_COLUMN_SKIP, 3)),
    x"2B" & "0" & std_logic_vector(to_unsigned(G_GREEN1_DIGITAL_GAIN, 7)) & "0" & G_GREEN1_ANALOG_MULTIPLIER & std_logic_vector(to_unsigned(G_GREEN1_ANALOG_GAIN, 6)),
    x"2C" & "0" & std_logic_vector(to_unsigned(G_BLUE_DIGITAL_GAIN, 7)) & "1" & G_BLUE_ANALOG_MULTIPLIER & std_logic_vector(to_unsigned(G_BLUE_ANALOG_GAIN, 6)),
    x"2D" & "0" & std_logic_vector(to_unsigned(G_RED_DIGITAL_GAIN, 7)) & "1" & G_RED_ANALOG_MULTIPLIER & std_logic_vector(to_unsigned(G_RED_ANALOG_GAIN, 6)),
    x"2E" & "0" & std_logic_vector(to_unsigned(G_GREEN2_DIGITAL_GAIN, 7)) & "1" & G_GREEN2_ANALOG_MULTIPLIER & std_logic_vector(to_unsigned(G_GREEN2_ANALOG_GAIN, 6)),
    x"49" & std_logic_vector(to_unsigned(G_ROW_BLACK_TARGET, 16)),
    x"4B" & std_logic_vector(to_unsigned(G_ROW_BLACK_DEFAULT_OFFSET, 16)),
    x"5B" & "000000000000000" & G_BLC_SAMPLE_SIZE,
    x"5C" & "0000" & std_logic_vector(to_signed(G_BLC_DELTA_DAMPING, 4)) & std_logic_vector(to_unsigned(G_BLC_DAC_SETTLING_TIME, 8)),
    x"5D" & '0' & std_logic_vector(to_unsigned(G_BLC_HIGH_DELTA_THRESHOLD, 7)) & '0' & std_logic_vector(to_unsigned(G_BLC_LOW_DELTA_THRESHOLD, 7)),
    x"5E" & '0' & std_logic_vector(to_unsigned(G_BLC_STEP_SIZE, 3)) & "000" & std_logic_vector(to_unsigned(G_BLC_MAX_ADJUST, 9)),
    x"5F" & '0' & std_logic_vector(to_unsigned(G_BLC_HIGH_TARGET_THRESHOLD, 7)) & '0' & std_logic_vector(to_unsigned(G_BLC_LOW_TARGET_THRESHOLD, 7)),
    x"60" & std_logic_vector(to_signed(G_GREEN1_OFFSET, 16)),
    x"61" & std_logic_vector(to_signed(G_GREEN2_OFFSET, 16)),
    x"62" & G_DISABLE_FAST_SAMPLE & G_LOCK_GREEN_CALIBRATION & G_LOCK_RED_BLUE_CALIBRATION & G_RECALCULATE_BLACK_LEVEL & G_DISABLE_BINARY_SEARCH & "000000000" & G_DISABLE_CALIBRATION & G_MANUAL_BLC,
    x"63" & std_logic_vector(to_signed(G_RED_OFFSET, 16)),
    x"64" & std_logic_vector(to_signed(G_BLUE_OFFSET, 16)),
    x"A0" & "000000000" & std_logic_vector(to_unsigned(G_TEST_PATTERN_MODE, 4)) & "00" & G_ACTIVATE_TEST_PATTERN,
    x"A1" & "0000" & std_logic_vector(to_unsigned(G_TEST_PATTERN_GREEN, 12)),
    x"A2" & "0000" & std_logic_vector(to_unsigned(G_TEST_PATTERN_RED, 12)),
    x"A3" & "0000" & std_logic_vector(to_unsigned(G_TEST_PATTERN_BLUE, 12)),
    x"0B" & "0000000000000001",  -- resume camera operation,
    (others => '0') -- empty padding
  );
  --vhdl_comp_on

  component KAMERA_I2C_CONTROLLER is
    port (
      I_CLOCK   : in    std_logic;
      I_RESET_N : in    std_logic;

      IO_SDATA  : inout std_logic;
      O_SCLK    : out   std_logic;

      I_WE      : in    std_logic;
      I_START_N : in    std_logic;
      I_ADDRESS : in    std_logic_vector(7 downto 0);
      I_DATA    : in    std_logic_vector(15 downto 0);

      O_Q       : out   std_logic_vector(15 downto 0);
      O_ERROR   : out   std_logic;
      O_VALID   : out   std_logic;
      O_READY   : out   std_logic
    );
  end component kamera_i2c_controller;

begin

  I2C_CONTROLLER : KAMERA_I2C_CONTROLLER
    port map (
      I_CLOCK   => I_I2C_CLOCK,
      I_RESET_N => I_RESET_N,

      IO_SDATA => IO_SDATA,
      O_SCLK   => O_SCLK,

      I_WE      => w_i2c_we,
      I_START_N => w_i2c_start_n,
      I_ADDRESS => w_i2c_address,
      I_DATA    => w_i2c_data,

      O_Q     => w_i2c_q,
      O_ERROR => w_i2c_error,
      O_VALID => w_i2c_valid,
      O_READY => w_i2c_ready
    );

  P_CAMERA : process (r_current_state, w_i2c_ready, r_lut_pointer, I_START_CONFIGURATION) is
  begin

    case (r_current_state) is

      when IDLE =>

        if (I_START_CONFIGURATION = '1') then
          w_next_state <= CAMERA_WAIT_I2C_START;
        else
          w_next_state <= IDLE;
        end if;

        w_i2c_we              <= '1';
        w_i2c_start_n         <= '1';
        w_i2c_config_finished <= '0';

      when camera_wait_i2c_start =>

        if (w_i2c_ready = '0') then
          w_next_state <= camera_wait_i2c_finish;
        else
          w_next_state <= camera_wait_i2c_start;
        end if;

        w_i2c_we              <= '1';
        w_i2c_start_n         <= '0';
        w_i2c_config_finished <= '0';

      when camera_wait_i2c_finish =>

        if (w_i2c_ready = '0') then
          w_next_state <= camera_wait_i2c_finish;
        elsif (w_i2c_ready = '1' and r_lut_pointer < c_lut_size) then
          w_next_state <= camera_wait_i2c_start;
        elsif (w_i2c_ready = '1' and r_lut_pointer >= c_lut_size) then
          w_next_state <= CAMERA_CONFIG_FINISHED;
        else
          w_next_state <= camera_wait_i2c_finish;
        end if;

        w_i2c_we              <= '1';
        w_i2c_start_n         <= '1';
        w_i2c_config_finished <= '0';

      when CAMERA_CONFIG_FINISHED =>
        w_next_state <= CAMERA_CONFIG_FINISHED;

        w_i2c_config_finished <= '1';
        w_i2c_we              <= '1';
        w_i2c_start_n         <= '1';

    end case;

  end process P_CAMERA;

  PROC_STATE_FF : process (I_RESET_N, I_CLOCK) is
  begin

    if (I_RESET_N = '0') then
      r_current_state <= IDLE;
    elsif (rising_edge(I_CLOCK)) then
      r_current_state <= w_next_state;
    end if;

  end process PROC_STATE_FF;

  PROC_I2C_COUNTER : process (I_RESET_N, I_CLOCK) is
  begin

    if (I_RESET_N = '0') then
      r_lut_pointer        <= 0;
      r_lut_pointer_locked <= '0';
    elsif (rising_edge(I_CLOCK)) then
      if (r_current_state = camera_wait_i2c_finish and r_lut_pointer < c_lut_size and r_lut_pointer_locked = '0') then
        r_lut_pointer        <= r_lut_pointer + 1;
        r_lut_pointer_locked <= '1';
      end if;
      if (r_current_state = camera_wait_i2c_start) then
        r_lut_pointer_locked <= '0';
      end if;
    end if;

  end process PROC_I2C_COUNTER;

  w_i2c_address <= c_i2c_lut(r_lut_pointer)(23 downto 16);
  w_i2c_data    <= c_i2c_lut(r_lut_pointer)(15 downto 0);

  O_CONFIGURATION_FINISHED <= w_i2c_config_finished;

end architecture ARCH;
