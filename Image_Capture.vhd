library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity IMAGE_CAPTURE is
  generic (
    G_IMAGE_WIDTH  : integer range 0 to 2592 := 1280;
    G_IMAGE_HEIGHT : integer range 0 to 1944 := 960
  );
  port (
    I_CLOCK       : in    std_logic;
    I_DATA        : in    std_logic_vector(11 downto 0);
    I_RESET_N     : in    std_logic;
    I_LVAL        : in    std_logic;
    I_FVAL        : in    std_logic;
    O_PIXEL_VALID : out   std_logic;
    O_PIXEL_DATA  : out   std_logic_vector(11 downto 0);
    O_X_COORD     : out   integer range 0 to G_IMAGE_WIDTH;
    O_Y_COORD     : out   integer range 0 to G_IMAGE_HEIGHT;
    O_NEW_FRAME_STARTED : out std_logic
  );
end entity IMAGE_CAPTURE;

architecture ARCH of IMAGE_CAPTURE is

  signal r_data     : std_logic_vector(11 downto 0);
  signal r_valid    : std_logic;

  signal r_lval     : std_logic;

  signal r_pre_fval : std_logic;
  signal r_fval     : std_logic;
  signal r_new_frame_started : std_logic;

  signal r_x_coord  : integer range 0 to G_IMAGE_WIDTH;
  signal r_y_coord  : integer range 0 to G_IMAGE_HEIGHT;

begin

  PROC_X_COUNTER : process (I_RESET_N, I_CLOCK) is
  begin

    if (I_RESET_N = '0') then
      r_x_coord <= 0;
    elsif (falling_edge(I_CLOCK)) then
      if (r_lval = '1') then
        if (r_x_coord < G_IMAGE_WIDTH - 1) then
          r_x_coord <= r_x_coord + 1;
        end if;
      end if;
    end if;

  end process PROC_X_COUNTER;

  PROC_Y_COUNTER : process (I_RESET_N, I_CLOCK) is
  begin

    if (I_RESET_N = '0') then
      r_y_coord <= 0;
    elsif (falling_edge(I_CLOCK)) then
      if (r_lval = '1') then
        if (r_x_coord = G_IMAGE_WIDTH) then
          if (r_y_coord < G_IMAGE_HEIGHT - 1) then
            r_y_coord <= r_y_coord + 1;
          else
            r_y_coord <= 0;
          end if;
        end if;
      end if;
    end if;

  end process PROC_Y_COUNTER;

  PROC_CAPTURE_VALID_FLAGS : process (I_RESET_N, I_CLOCK) is
  begin

    if (I_RESET_N = '0') then
      r_lval <= '0';
      r_fval <= '0';
      r_pre_fval <= '0';
    elsif (falling_edge(I_CLOCK)) then
      r_pre_fval <= I_FVAL;
      r_lval <= I_LVAL;

      if (r_pre_fval = '0' and I_FVAL = '1') then
        r_fval <= '1';
        r_new_frame_started <= '1';
      elsif (r_pre_fval = '1' and I_FVAL = '0') then
        r_fval <= '0';
        r_new_frame_started <= '0';
      end if;

      if(I_LVAL = '1') then
        r_new_frame_started <= '0';
      end if;
    end if;


  end process PROC_CAPTURE_VALID_FLAGS;

  PROC_CAPTURE_DATA : process (I_RESET_N, I_CLOCK) is
  begin

    if (I_RESET_N = '0') then
      r_data <= (others => '0');
    elsif (falling_edge(I_CLOCK)) then
      -- if (r_lval = '1') then
        r_data <= I_DATA;
      -- else
        -- r_data <= (others => '0');
      -- end if;
    end if;

  end process PROC_CAPTURE_DATA;

  O_X_COORD     <= r_x_coord;
  O_Y_COORD     <= r_y_coord;
  O_PIXEL_DATA  <= r_data;
  O_PIXEL_VALID <= '1' when r_lval = '1' and r_fval = '1' else '0';
  O_NEW_FRAME_STARTED <= r_new_frame_started;

end architecture ARCH;
