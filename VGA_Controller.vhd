 library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity VGA_CONTROLLER is
  generic (

    G_HORIZONTAL_DISPLAY : integer := 640; --! Width of the active image
    G_VERTICAL_DISPLAY   : integer := 480; --! Height of the active image
    G_PIXEL_WIDTH        : integer := 8;   --! Amount of bits per pixel
    G_H_FRONT_PORCH_SIZE : integer := 16;  --! Horizontal front porch size (see vga references)
    G_H_BACK_PORCH_SIZE  : integer := 48;  --! Horizontal back porch size (see vga references)
    G_H_SYNC_SIZE        : integer := 96;  --! Horizontal sync size (see vga references)
    G_V_BACK_PORCH_SIZE  : integer := 33;  --! Vertical back porch size (see vga references)
    G_V_FRONT_PORCH_SIZE : integer := 10;  --! Vertical front porch size (see vga references)
    G_V_SYNC_SIZE        : integer := 2    --! Vertical back porch size (see vga references)
  );
  port (
    I_CLOCK       : in    std_logic;                                    --! input clock (if needed)
    I_RESET_N     : in    std_logic;                                    --! async low active, sets counters to 0

    I_VGA_BLANK_N : in    std_logic;

    -- Connections to VGA interface
    O_H_SYNC_N    : out   std_logic;                                    --! connection h_sync signal to vga interface
    O_V_SYNC_N    : out   std_logic;                                    --! connection v_sync signal to vga interface
    O_VALID_PIXEL : out   std_logic;                                    --! connection h_sync signal to vga interface

    I_RED         : in    std_logic_vector(G_PIXEL_WIDTH - 1 downto 0); --! Input red value
    I_GREEN       : in    std_logic_vector(G_PIXEL_WIDTH - 1 downto 0); --! Input green value
    I_BLUE        : in    std_logic_vector(G_PIXEL_WIDTH - 1 downto 0); --! Input blue value

    O_RED         : out   std_logic_vector(G_PIXEL_WIDTH - 1 downto 0); --! actual red value
    O_GREEN       : out   std_logic_vector(G_PIXEL_WIDTH - 1 downto 0); --! actual green value
    O_BLUE        : out   std_logic_vector(G_PIXEL_WIDTH - 1 downto 0); --! actual blue value

    O_VGA_SYNC_N  : out   std_logic;                                    --! vga sync signal, always low
    O_VGA_BLANK_N : out   std_logic                                     --! Makes it possible to manually turn off the screen
  );
end entity VGA_CONTROLLER;

architecture ARCH of VGA_CONTROLLER is

  --! sum of active image height, vertical sync size and vertical porches
  constant c_max_row_count         : integer := G_VERTICAL_DISPLAY + G_V_SYNC_SIZE + G_V_FRONT_PORCH_SIZE + G_V_BACK_PORCH_SIZE;

  --! sum of active image width, horizontal sync size and horizontal porches
  constant c_max_col_count         : integer := G_HORIZONTAL_DISPLAY + G_H_SYNC_SIZE + G_H_FRONT_PORCH_SIZE + G_H_BACK_PORCH_SIZE;

  --! The active image starts after completion of h sync and h back porch
  constant c_valid_pixel_col_start : integer := G_H_SYNC_SIZE + G_H_BACK_PORCH_SIZE;

  --! The active image ends after active horizontal image size h plus sync and h back porch
  constant c_valid_pixel_col_end   : integer := c_valid_pixel_col_start + G_HORIZONTAL_DISPLAY;

  --! The active image starts after completion of v sync and v back porch
  constant c_valid_pixel_row_start : integer := G_V_SYNC_SIZE + G_V_BACK_PORCH_SIZE;

  --! The active image ends after active v image size v plus sync and v back porch
  constant c_valid_pixel_row_end   : integer := c_valid_pixel_row_start + G_VERTICAL_DISPLAY;

  --! Keeps track of current vertical position
  signal r_current_row             : integer range 0 to c_max_row_count - 1 := 0;

  --! Keeps track of current horizontal position
  signal r_current_col             : integer range 0 to c_max_col_count - 1 := 0;

  --! indicates if the image is active based on current position
  signal w_valid_pixel             : std_logic;

  --! red color mux based depending on (not) active image state
  signal w_red_out                 : std_logic_vector(G_PIXEL_WIDTH - 1 downto 0);

  --! green color mux based depending on (not) active image state
  signal w_green_out               : std_logic_vector(G_PIXEL_WIDTH - 1 downto 0);

  --! blue color mux based depending on (not) active image state
  signal w_blue_out                : std_logic_vector(G_PIXEL_WIDTH - 1 downto 0);

  --! sets horizontal sync signal based on current position
  signal w_h_sync                  : std_logic;

  --! sets vertical sync signal based on current position
  signal w_v_sync                  : std_logic;

    --! indicates if the image is active based on current position
    signal r_valid_pixel             : std_logic;

    --! red color mux based depending on (not) active image state
    signal r_red_out                 : std_logic_vector(G_PIXEL_WIDTH - 1 downto 0);
  
    --! green color mux based depending on (not) active image state
    signal r_green_out               : std_logic_vector(G_PIXEL_WIDTH - 1 downto 0);
  
    --! blue color mux based depending on (not) active image state
    signal r_blue_out                : std_logic_vector(G_PIXEL_WIDTH - 1 downto 0);
  
    --! sets horizontal sync signal based on current position
    signal r_h_sync                  : std_logic;
  
    --! sets vertical sync signal based on current position
    signal r_v_sync                  : std_logic;

    signal r_reset_timer : integer range 0 to 10;

begin

  -- This counter counts through the rows and columns of the display.
  -- Based on this count, the sync signals and the output colors are controlled.
  COL_COUNTER : process (I_CLOCK, r_reset_timer) is
  begin

    if (r_reset_timer > 0) then
      r_current_col <= 0;
    elsif (rising_edge(I_CLOCK)) then
      if(r_reset_timer = 0) then
      if (r_current_col = c_max_col_count - 1) then
        r_current_col <= 0;
      else
        r_current_col <= r_current_col + 1;
      end if;
    end if;
  end if;
  end process COL_COUNTER;

  PROC_ROW_COUNTER : process (I_CLOCK, r_reset_timer) is
  begin
    if(r_reset_timer > 0) then
      r_current_row <= 0;
    elsif(rising_edge(I_CLOCK)) then
      if(r_reset_timer = 0) then
      if (r_current_col = c_max_col_count - 1) then
        if (r_current_row = c_max_row_count - 1) then
          r_current_row <= 0;
        else
          r_current_row <= r_current_row + 1;
        end if;
      end if;
    end if;
  end if;
  end process PROC_ROW_COUNTER;

  -- Sets the horizontal sync based on the current column
  PROC_H_SYNC : process (r_current_col) is
  begin

    if (r_current_col < G_H_SYNC_SIZE) then
      w_h_sync <= '0';
    else
      w_h_sync <= '1';
    end if;

  end process PROC_H_SYNC;

  -- Sets the horizontal sync based on the current row
  PROC_V_SYNC : process (r_current_row) is
  begin

    if (r_current_row < G_V_SYNC_SIZE) then
      w_v_sync <= '0';
    else
      w_v_sync <= '1';
    end if;

  end process PROC_V_SYNC;

  -- This process controls the valid pixel signal and turns the
  -- output on or off based on the current row and column.
  OUTPUT : process (r_current_col, r_current_row, I_RED, I_GREEN, I_BLUE) is
  begin

    if (r_current_row >= c_valid_pixel_row_start and r_current_row < c_valid_pixel_row_end
        and r_current_col >= c_valid_pixel_col_start and r_current_col < c_valid_pixel_col_end
      ) then
      w_valid_pixel <= '1';
      w_red_out     <= I_RED;
      w_green_out   <= I_GREEN;
      w_blue_out    <= I_BLUE;
    else
      w_valid_pixel <= '0';
      w_red_out     <= (others => '0');
      w_green_out   <= (others => '0');
      w_blue_out    <= (others => '0');
    end if;

  end process OUTPUT;

  proc_registers : process (r_reset_timer, I_CLOCK) is
  begin
  
    if (r_reset_timer > 0) then
      r_valid_pixel <= '0';
      r_red_out     <= (others => '0');
      r_green_out   <= (others => '0');
      r_blue_out    <= (others => '0');
      r_h_sync <= '0';
      r_v_sync <= '0';
    elsif (rising_edge(I_CLOCK)) then
      if(r_reset_timer = 0) then
        r_valid_pixel <= w_valid_pixel;
        r_red_out <= w_red_out;
        r_green_out <= w_green_out;
        r_blue_out <= w_blue_out;
        r_h_sync <= w_h_sync;
        r_v_sync <= w_v_sync;
      end if;
    end if;
  
  end process proc_registers;

  proc_reset_timer : process(I_CLOCK) 
  begin
    if(rising_edge(I_CLOCK)) then
      if(I_RESET_N = '0') then
        r_reset_timer <= 10;
      elsif(r_reset_timer > 0) then
        r_reset_timer <= r_reset_timer - 1;
      end if;
    end if;
  end process;
  ---------------------------------------------------------------------
  --- Connect output registers with the corresponding vga interface ---
  ---------------------------------------------------------------------
  O_VGA_SYNC_N  <= '0';
  O_VALID_PIXEL <= r_valid_pixel;
  O_RED         <= r_red_out;
  O_GREEN       <= r_green_out;
  O_BLUE        <= r_blue_out;
  O_V_SYNC_N    <= r_v_sync;
  O_H_SYNC_N    <= r_h_sync;
  O_VGA_BLANK_N <= I_VGA_BLANK_N;

end architecture ARCH;
