library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity UART_TEST is
  generic (
    G_BAUD_RATE       : real := 115200.0;
    G_CLOCK_FREQUENCY : real := 90.0 -- in MHz
  );
  port (
    I_CLOCK                   : in    std_logic;
    I_START_TRANSMISSION      : in    std_logic;
    I_DATA                    : in    std_logic_vector(7 downto 0);
    O_TRANSMISSION_ACTIVE     : out   std_logic;
    O_TRANSMISSION_DATA       : out   std_logic;
    O_TRANSMISSION_FINISHED   : out   std_logic
  );
end entity UART_TEST;

architecture RTL of UART_TEST is

  constant c_clocks_per_bit   : natural := natural((G_CLOCK_FREQUENCY * 10.0 ** 6) / G_BAUD_RATE);

  type t_states is (
    IDLE,
    LOAD_DATA,
    SEND_START_BIT,
    SEND_DATA,
    SEND_STOP_BIT
  );

  signal r_current_state       : t_states := IDLE;

  signal r_state_count           : integer range 0 to c_clocks_per_bit - 1 := 0;
  signal r_current_bit         : integer range 0 to 7                     := 0;  -- 8 Bits Total
  signal r_transmission_done   : std_logic                                := '0';
  signal r_current_data        : unsigned (7 downto 0);
  signal r_transmission_data   : std_logic;
  signal r_transmission_active : std_logic;

begin

  P_UART_TX : process (I_CLOCK) is
  begin

    if rising_edge(I_CLOCK) then

      case r_current_state is

        when IDLE =>
          if (I_START_TRANSMISSION = '1') then
            r_current_state <= LOAD_DATA;
          else
            r_current_state <= IDLE;
          end if;

          r_transmission_active <= '0';
          r_transmission_data   <= '1';
          r_transmission_done   <= '0';
          r_state_count           <= 0;
          r_current_bit         <= 0;

        when LOAD_DATA =>
          r_current_state       <= SEND_START_BIT;
          r_transmission_active <= '0';
          r_transmission_data   <= '1';
          r_transmission_done   <= '1';
          r_state_count           <= 0;
          r_current_bit         <= 0;
          r_current_data        <= unsigned(I_DATA);

        when SEND_START_BIT =>
          if (r_state_count < c_clocks_per_bit - 1) then
            r_state_count     <= r_state_count + 1;
            r_current_state <= SEND_START_BIT;
          else
            r_state_count     <= 0;
            r_current_state <= SEND_DATA;
          end if;

          r_transmission_active <= '1';
          r_transmission_data   <= '0';
          r_transmission_done   <= '0';

        when SEND_DATA =>
          if (r_state_count < c_clocks_per_bit - 1) then
            r_state_count     <= r_state_count + 1;
            r_current_state <= SEND_DATA;
          else
            r_state_count <= 0;

            if (r_current_bit < 7) then
              r_current_bit   <= r_current_bit + 1;
              r_current_state <= SEND_DATA;
            else
              r_current_bit   <= 0;
              r_current_state <= SEND_STOP_BIT;
            end if;
          end if;

          r_transmission_done <= '0';
          r_transmission_data <= r_current_data(r_current_bit);

        when SEND_STOP_BIT =>
          if (r_state_count < c_clocks_per_bit - 1) then
            r_state_count     <= r_state_count + 1;
            r_current_state <= SEND_STOP_BIT;
          else
            r_transmission_done <= '0';
            r_state_count         <= 0;
            r_current_state     <= IDLE;
          end if;

          r_transmission_data <= '1';

      end case;

    end if;

  end process P_UART_TX;

  O_TRANSMISSION_FINISHED <= r_transmission_done;
  O_TRANSMISSION_DATA     <= r_transmission_data;
  O_TRANSMISSION_ACTIVE   <= r_transmission_active;

end architecture RTL;
