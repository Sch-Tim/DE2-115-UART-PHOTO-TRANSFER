library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.fixed_pkg.all;
  use work.float_pkg.all;

entity KAMERA_VGA_DEMONSTRATOR is
  port (
    I_CLOCK            : in    std_logic;

    ------------------SDRAM---------------------------
    O_DRAM_ADDR        : out   unsigned(12 downto 0);
    O_DRAM_BA          : out   unsigned(1 downto 0);
    O_DRAM_CAS_N       : out   std_logic;
    O_DRAM_CKE         : out   std_logic;
    O_DRAM_CLK         : out   std_logic;
    O_DRAM_CS_N        : out   std_logic;
    IO_DRAM_DQ         : inout std_logic_vector(31 downto 0);
    O_DRAM_RAS_N       : out   std_logic;
    O_DRAM_WE_N        : out   std_logic;
    O_DRAM_LDQM_1      : out   std_logic;
    O_DRAM_UDQM_1      : out   std_logic;
    O_DRAM_LDQM_0      : out   std_logic;
    O_DRAM_UDQM_0      : out   std_logic;

    -------------------VGA----------------------------
    O_H_SYNC           : out   std_logic;
    O_V_SYNC           : out   std_logic;
    O_VGA_R            : out   std_logic_vector(7 downto 0);
    O_VGA_G            : out   std_logic_vector(7 downto 0);
    O_VGA_B            : out   std_logic_vector(7 downto 0);
    O_VGA_SYNC_N       : out   std_logic;
    O_VGA_BLANK_N      : out   std_logic;
    O_VGA_CLOCK        : out   std_logic;

    ------------------- UART ----------------------------
    O_TX_ACTIVE        : out   std_logic;
    O_TX_SERIAL        : out   std_logic;

    ------- Anzeigen, Buttons, Switches------------------
    I_SLIDE_SWITCH     : in    std_logic_vector(17 downto 0);
    I_BUTTON           : in    std_logic_vector(3 downto 0);

    O_LED_RED          : out   std_logic_vector(17 downto 0);
    O_LED_GREEN        : out   std_logic_vector(8 downto 0);

    O_7_SEGMENT_0      : out   std_logic_vector(6 downto 0);
    O_7_SEGMENT_1      : out   std_logic_vector(6 downto 0);
    O_7_SEGMENT_2      : out   std_logic_vector(6 downto 0);
    O_7_SEGMENT_3      : out   std_logic_vector(6 downto 0);
    O_7_SEGMENT_4      : out   std_logic_vector(6 downto 0);
    O_7_SEGMENT_5      : out   std_logic_vector(6 downto 0);
    O_7_SEGMENT_6      : out   std_logic_vector(6 downto 0);
    O_7_SEGMENT_7      : out   std_logic_vector(6 downto 0);

    I_GPIO_0           : in    std_logic;
    I_GPIO_1           : in    std_logic;
    I_GPIO_3           : in    std_logic;
    I_GPIO_4           : in    std_logic;
    I_GPIO_5           : in    std_logic;
    I_GPIO_6           : in    std_logic;
    I_GPIO_7           : in    std_logic;
    I_GPIO_8           : in    std_logic;
    I_GPIO_9           : in    std_logic;
    I_GPIO_10          : in    std_logic;
    I_GPIO_11          : in    std_logic;
    I_GPIO_12          : in    std_logic;
    I_GPIO_13          : in    std_logic;

    O_GPIO_16          : out   std_logic;
    O_GPIO_17          : out   std_logic;

    O_GPIO_19          : out   std_logic;

    I_GPIO_20          : in    std_logic;
    I_GPIO_21          : in    std_logic;
    I_GPIO_22          : in    std_logic;
    O_GPIO_23          : inout std_logic;
    O_GPIO_24          : out   std_logic;

    I_HSMC_J3_0        : in    std_logic; -- (GPIO 0)
    I_HSMC_J3_1        : in    std_logic; -- (GPIO 1)
    I_HSMC_J3_3        : in    std_logic; -- (GPIO 3)
    I_HSMC_J3_4        : in    std_logic; -- TX_n16 (GPIO 4)
    I_HSMC_J3_5        : in    std_logic; -- RX_n15 (GPIO 5)
    I_HSMC_J3_6        : in    std_logic; -- TX_p16 (GPIO 6)
    I_HSMC_J3_7        : in    std_logic; -- RX_p15 (GPIO 7)
    I_HSMC_J3_8        : in    std_logic; -- TX_n15 (GPIO 8)
    I_HSMC_J3_9        : in    std_logic; -- RX_n14 (GPIO 9)
    I_HSMC_J3_10       : in    std_logic; -- TX_p15 (GPIO 10)
    I_HSMC_J3_11       : in    std_logic;
    I_HSMC_J3_12       : in    std_logic;
    I_HSMC_J3_13       : in    std_logic; -- RX_p14 (GPIO 11)
    I_HSMC_J3_14       : in    std_logic; -- TX_n14 (GPIO 12)
    I_HSMC_J3_15       : in    std_logic; -- RX_n13 (GPIO 13)
    O_HSMC_J3_16       : out   std_logic;
    -- HSMC 17 = TX_p14 (GPIO 14)
    O_HSMC_J3_17       : out   std_logic; -- RX_p13 (GPIO 15)
    O_HSMC_J3_18       : out   std_logic; -- CLKOUT_n2

    O_HSMC_J3_19       : out   std_logic; -- RX_n12

    I_HSMC_J3_20       : in    std_logic; -- CLKOUT_p2
    I_HSMC_J3_21       : in    std_logic; -- RX_p12
    I_HSMC_J3_22       : in    std_logic; -- TX_n13
    IO_HSMC_J3_23      : inout std_logic; -- RX_n11
    O_HSMC_J3_24       : out   std_logic;  -- TX_p13
	 
	 I_HSMC_J4_0        : in    std_logic; -- (GPIO 0)
    I_HSMC_J4_1        : in    std_logic; -- (GPIO 1)
    I_HSMC_J4_3        : in    std_logic; -- (GPIO 3)
    I_HSMC_J4_4        : in    std_logic; -- TX_n16 (GPIO 4)
    I_HSMC_J4_5        : in    std_logic; -- RX_n15 (GPIO 5)
    I_HSMC_J4_6        : in    std_logic; -- TX_p16 (GPIO 6)
    I_HSMC_J4_7        : in    std_logic; -- RX_p15 (GPIO 7)
    I_HSMC_J4_8        : in    std_logic; -- TX_n15 (GPIO 8)
    I_HSMC_J4_9        : in    std_logic; -- RX_n14 (GPIO 9)
    I_HSMC_J4_10       : in    std_logic; -- TX_p15 (GPIO 10)
    I_HSMC_J4_11       : in    std_logic;
    I_HSMC_J4_12       : in    std_logic;
    I_HSMC_J4_13       : in    std_logic; -- RX_p14 (GPIO 11)
    I_HSMC_J4_14       : in    std_logic; -- TX_n14 (GPIO 12)
    I_HSMC_J4_15       : in    std_logic; -- RX_n13 (GPIO 13)
    O_HSMC_J4_16       : out   std_logic;
    -- HSMC 17 = TX_p14 (GPIO 14)
    O_HSMC_J4_17       : out   std_logic; -- RX_p13 (GPIO 15)
    O_HSMC_J4_18       : out   std_logic; -- CLKOUT_n2

    O_HSMC_J4_19       : out   std_logic; -- RX_n12

    I_HSMC_J4_20       : in    std_logic; -- CLKOUT_p2
    I_HSMC_J4_21       : in    std_logic; -- RX_p12
    I_HSMC_J4_22       : in    std_logic; -- TX_n13
    IO_HSMC_J4_23      : inout std_logic; -- RX_n11
    O_HSMC_J4_24       : out   std_logic  -- TX_p13
  );
end entity KAMERA_VGA_DEMONSTRATOR;

architecture RTL of KAMERA_VGA_DEMONSTRATOR is

  type states_t is (
    FLUSH_FIFOS,

    RECTIFICATION_CALCULATE_OLD_COORDINATE,
    RECTIFICATION_STORE_OLD_COORDINATE,

    WAIT_FOR_NEW_FRAME_LEFT,
    WRITE_LEFT,
    WAIT_FOR_NEW_FRAME_RIGHT,
    WRITE_RIGHT,

    RECTIFICATION_LOAD_OLD_COORDINATE,
    RECTIFICATION_LOAD_OLD_PIXEL,
    RECTIFICATION_STORE_NEW_PIXEL,
	 
	 TRANSMIT_TO_DISPARITY_GENERATOR_LEFT,
    TRANSMIT_TO_DISPARITY_GENERATOR_RIGHT,
    LOAD_DISPARITY,

    READ_LEFT,
    READ_RIGHT,
    READ_RECTIFIED,
	 READ_DISPARITY,
    FINISHED
  );
  
  
  constant c_image_width                                          : integer := 640;
  constant c_image_height                                         : integer := 480;
  constant c_max_rgb_count                                        : integer := c_image_height * c_image_width;

  -- RECTIFICATION

  constant c_639                                                  : signed(21 downto 0) := to_signed(639, 22);
  constant c_0                                                    : signed(21 downto 0) := to_signed(0, 22);
  constant c_1                                                    : signed(21 downto 0) := to_signed(1, 22);
  constant c_479                                                  : signed(21 downto 0) := to_signed(639, 22);

  signal r_start_rectification                                    : std_logic := '0';
  signal r_i_x                                                    : signed(21 downto 0) := (others => '0');
  signal r_i_y                                                    : signed(21 downto 0) := (others => '0');
  signal r_use_inverse                                            : std_logic := '1';
  signal w_o_x                                                    : integer range -999999 to 999999;
  signal w_o_y                                                    : integer range -999999 to 999999;
  signal w_rect_valid                                             : std_logic;
  signal w_rect_ack                                               : std_logic;
  signal w_coordinate_invalid                                     : std_logic;

  constant c_bounding_box_left_x_offset                           : integer range -639 to 639 := 0;
  constant c_bounding_box_right_x_offset                          : integer range -639 to 639 := 0;
  constant c_bounding_box_upper_y_offset                          : integer range -479 to 479 := 0;
  constant c_bounding_box_lower_y_offset                          : integer range -479 to 479 := 0;

  constant c_image_1_offset                                       : integer := 0;
  constant c_image_2_offset                                       : integer := c_image_1_offset + (c_image_height * c_image_width);
  constant c_image_rect_offset                                    : integer := c_image_1_offset + 2 * (c_image_height * c_image_width);
  constant c_rect_coordinate_offset                               : integer := c_image_1_offset + 3 * (c_image_height * c_image_width);
  constant c_disparity_offset                               		: integer := c_image_1_offset + 4 * (c_image_height * c_image_width);

  constant c_color_threshold                                      : integer := 200;

    constant c_block_size                                           : integer := 5;
  constant c_minimal_disparity                                    : integer := 60;
  constant c_maximum_disparity                                    : integer := 9999;
  constant c_disparity_width                                      : integer := c_image_width / c_block_size;
  constant c_disparity_height                                     : integer := c_image_height / c_block_size;
  constant c_disparity_pixel_amount                               : integer := c_disparity_height * c_disparity_width;

  signal r_current_original_image_row                             : integer range 0 to c_image_height := 0;
  signal r_current_original_image_column                          : integer range 0 to c_image_width := 0;
  
  signal r_current_disparity_image_row                            : integer range 0 to c_image_height / c_block_size := 0;
  signal r_current_disparity_image_column                         : integer range 0 to c_image_width / c_block_size := 0;


  ----------------- clocks ------------------------------
  signal w_clk_system                                             : std_logic;
  signal w_clk_vga                                                : std_logic;
  signal w_clk_sdram                                              : std_logic;
  signal w_clk_sdram_n                                            : std_logic;
  signal w_clk_i2c                                                : std_logic;
  signal w_clk_i2c_double                                         : std_logic;
  signal w_clk_camera                                             : std_logic;

  --------------- camera left ---------------------------

  signal w_left_camera_pixeldata                                  : std_logic_vector(23 downto 0);
  signal w_left_input_image_valid                                 : std_logic;
  signal r_left_new_frame_started                                 : std_logic;
  signal w_left_camera_pixclk                                     : std_logic;
  signal w_left_camera_sclk                                       : std_logic;
  signal w_left_camera_xclk                                       : std_logic;

  signal w_left_camera_out_raw                                    : std_logic_vector(11 downto 0);
  signal w_left_camera_pixel_out_full_width                       : std_logic_vector(35 downto 0);
  signal w_left_camera_pixel_out_reduced_width                    : std_logic_vector(23 downto 0);
  signal w_left_camera_strobe                                     : std_logic;
  signal w_left_camera_lval                                       : std_logic;
  signal w_left_camera_fval                                       : std_logic;
  signal w_left_camera_sdata                                      : std_logic;
  signal w_left_camera_reset_n                                    : std_logic;
  signal w_left_camera_trigger                                    : std_logic;
  signal w_left_camera_pixel_valid                                : std_logic;
  signal w_left_new_frame_started                                 : std_logic;

  signal w_left_raw_pixel_valid                                   : std_logic;
  signal w_left_raw_pixel_full_width                              : std_logic_vector(11 downto 0);
  signal w_left_raw_pixel_reduced_width                           : std_logic_vector(7 downto 0);

  signal w_take_picture                                           : std_logic;

  signal r_lval                                                   : std_logic := '0';
  signal r_pixel_data                                             : std_logic_vector(11 downto 0) := (others => '0');

  -- disparity --
  signal w_disparity_pixel_valid                                  : std_logic;
  signal w_disparity_pixel                                        : std_logic_vector(7 downto 0);
  signal w_disparity_ready                                        : std_logic;
  
  signal r_read_from_ram_count                                    : integer range 0 to c_image_width * c_block_size := 0;
  signal r_requested_from_ram_count                               : integer range 0 to c_image_width * c_block_size := 0;

  --------------- camera right ---------------------------
  signal w_right_chosen_picture                                   : std_logic_vector(1 downto 0);
  signal w_right_pixeldata                                        : std_logic_vector(23 downto 0);
  signal w_right_input_image_valid                                : std_logic;
  signal r_right_new_frame_started                                : std_logic := '0';
  signal w_right_camera_pixclk                                    : std_logic;
  signal w_right_camera_sclk                                      : std_logic;
  signal w_right_camera_xclk                                      : std_logic;

  signal w_right_camera_out_raw                                   : std_logic_vector(11 downto 0);
  signal w_right_camera_pixel_out_reduced_width                   : std_logic_vector(23 downto 0);
  signal w_right_camera_strobe                                    : std_logic;
  signal w_right_camera_lval                                      : std_logic;
  signal w_right_camera_fval                                      : std_logic;
  signal w_right_camera_sdata                                     : std_logic;
  signal w_right_camera_reset_n                                   : std_logic;
  signal w_right_camera_trigger                                   : std_logic;
  signal w_right_camera_pixel_valid                               : std_logic;
  signal w_right_new_frame_started                                : std_logic;

  -- sdram --

  signal r_sdram_fifo_data_in                                     : std_logic_vector(7 downto 0) := (others => '0');
  signal r_sdram_fifo_data_in_delay1                                     : std_logic_vector(7 downto 0) := (others => '0');
  signal r_sdram_fifo_data_in_delay2                                     : std_logic_vector(7 downto 0) := (others => '0');
  signal r_sdram_fifo_data_in_delay3                                     : std_logic_vector(7 downto 0) := (others => '0');
  signal r_sdram_fifo_data_in_delay4                                     : std_logic_vector(7 downto 0) := (others => '0');
  signal r_sdram_fifo_data_in_delay5                                     : std_logic_vector(7 downto 0) := (others => '0');
  signal r_sdram_fifo_data_in_delay6                                     : std_logic_vector(7 downto 0) := (others => '0');
  signal r_sdram_fifo_data_in_delay7                                     : std_logic_vector(7 downto 0) := (others => '0');
  signal r_sdram_fifo_data_in_delay8                                     : std_logic_vector(7 downto 0) := (others => '0');
  signal w_sdram_fifo_rdreq                                       : std_logic;
  signal r_sdram_fifo_wrreq                                       : std_logic := '0';
  signal r_sdram_fifo_wrreq_delay1                                       : std_logic := '0';
  signal r_sdram_fifo_wrreq_delay2                                       : std_logic := '0';
  signal r_sdram_fifo_wrreq_delay3                                       : std_logic := '0';
  signal r_sdram_fifo_wrreq_delay4                                       : std_logic := '0';
  signal r_sdram_fifo_wrreq_delay5                                       : std_logic := '0';
  signal r_sdram_fifo_wrreq_delay6                                       : std_logic := '0';
  signal r_sdram_fifo_wrreq_delay7                                       : std_logic := '0';
  signal r_sdram_fifo_wrreq_delay8                                       : std_logic := '0';
  signal w_sdram_fifo_q                                           : std_logic_vector(7 downto 0);
  signal w_sdram_fifo_rdempty                                     : std_logic;
  signal w_sdram_fifo_wrfull                                      : std_logic;
  signal w_sdram_fifo_wrusedw                                     : std_logic_vector(12 downto 0);
  signal w_sdram_fifo_rdusedw                                     : std_logic_vector(12 downto 0);
  signal w_sdram_fifo_aclr                                        : std_logic;
  signal w_sdram_initialized                                      : std_logic;

  signal r_current_state                                          : states_t := flush_fifos;
  signal w_next_state                                             : states_t;
  signal w_sdram_addr                                             : std_logic_vector(24 downto 0);
  signal w_sdram_rdval                                            : std_logic;
  signal w_sdram_we_n                                             : std_logic;
  signal w_sdram_writedata                                        : std_logic_vector(31 downto 0);
  signal w_sdram_ack                                              : std_logic;

  signal w_dqml                                                   : std_logic;
  signal w_dqmh                                                   : std_logic;

  signal w_sdram_readdata                                         : std_logic_vector(31 downto 0);
  signal w_sdram_req                                              : std_logic;

  signal r_values_read_from_ram                                   : integer range 0 to 307200 := 0;

  signal r_values_written_to_uart                                 : integer range 0 to 307200 := 0;

  -----------------fifo-------------------------------------

  signal w_vga_fifo_data_in                                       : std_logic_vector(23 downto 0);
  signal w_vga_fifo_rdreq                                         : std_logic;
  signal w_vga_fifo_wrreq                                         : std_logic;
  signal w_vga_fifo_q                                             : std_logic_vector(23 downto 0);
  signal w_vga_fifo_rdempty                                       : std_logic;
  signal w_vga_fifo_wrfull                                        : std_logic;
  signal w_vga_fifo_wrusedw                                       : std_logic_vector(12 downto 0);
  signal w_vga_fifo_rdusedw                                       : std_logic_vector(12 downto 0);
  signal w_vga_fifo_aclr                                          : std_logic;

  -------------------vga-------------------------------------
  signal w_vga_ready                                              : std_logic;
  signal w_vga_data_in                                            : std_logic_vector(23 downto 0);
  signal w_vga_reset                                              : std_logic;

  ---------------UART----------------------------------------
  signal w_start_transmission                                     : std_logic;
  signal w_tx_done                                                : std_logic;
  signal r_current_byte                                           : integer range 0 to 2 := 0;
  signal r_data_written_to_uart                                   : integer range 0 to 307200 := 0;
  signal w_uart_in                                                : std_logic_vector(7 downto 0);

  ---------------anwendung-----------------------------------
  signal r_ram_write_pointer                                      : integer range 0 to 308000 := 0; -- 480*640 = 307.200

  -- Der Integer wird bei -1 initialisiert und nimmt diesen Zustand dann nie wieder ein.
  -- So kann überprüft werden, ob schon einmal gelesen wurde.
  -- Dies ist nötig für die write_ready flag beim ersten Durchlauf.
  signal r_ram_read_pointer                                       : integer range 0 to 308000 := 0; -- 480*640 = 307.200
  signal r_ram_read_pointer_right                                       : integer range 0 to 308000 := 0; -- 480*640 = 307.200
  signal r_ram_read_pointer_left                                       : integer range 0 to 308000 := 0; -- 480*640 = 307.200

  signal r_vga_out_counter                                        : integer range 0 to 307199 := 0;

  signal r_rgb_count                                              : integer range 0 to 16777215 := 0;

  signal r_values_written_to_fifo                                 : integer range 0 to 308000 := 0;

  signal w_continous_write                                        : std_logic;
  signal w_reset_n                                                : std_logic;
  signal w_vga_blank_n                                            : std_logic;

  signal r_pixel_col_count                                        : integer range 0 to 2600 := 0;
  signal r_pixel_row_count                                        : integer range 0 to 2600 := 0;
  signal r_row_counter_locked                                     : std_logic               := '1';

  signal r_bounding_box_ready                                     : std_logic := '0';
  signal r_bounding_box_w                                         : integer range 0 to 99999 := 0;
  signal r_bounding_box_h                                         : integer range 0 to 99999 := 0;

  signal r_bounding_box_left_upper_x                              : integer range -999999 to 999999 := 0;
  signal r_bounding_box_left_upper_y                              : integer range -999999 to 999999 := 0;

  signal r_bounding_box_left_lower_x                              : integer range -999999 to 999999 := 0;
  signal r_bounding_box_left_lower_y                              : integer range -999999 to 999999 := 0;

  signal r_bounding_box_right_upper_x                             : integer range -999999 to 999999 := 0;
  signal r_bounding_box_right_upper_y                             : integer range -999999 to 999999 := 0;

  signal r_bounding_box_right_lower_x                             : integer range -999999 to 999999 := 0;
  signal r_bounding_box_right_lower_y                             : integer range -999999 to 999999 := 0;

  signal r_bounding_box_max_x                                     : integer range -999999 to 999999 := 0;
  signal r_bounding_box_max_y                                     : integer range -999999 to 999999 := 0;

  signal r_target_area_y_start                                    : signed(21 downto 0) := (others => '0');
  signal r_target_area_y_end                                      : signed(21 downto 0) := c_479;
  signal r_target_area_x_start                                    : signed(21 downto 0) := c_0;
  signal r_target_area_x_end                                      : signed(21 downto 0) := c_639;

  signal r_current_new_x                                          : signed(21 downto 0)    := (others => '0');
  signal r_current_new_y                                          : signed(21 downto 0)    := (others => '0');
  signal r_current_new_write_col                                  : integer range 0 to 639 := 0;
  signal r_current_new_write_row                                  : integer range 0 to 479 := 0;

  signal r_current_original_write_col                             : integer range 0 to 640 := 0;
  signal r_current_original_write_row                             : integer range 0 to 480 := 0;

  signal r_next_new_x                                             : signed(21 downto 0) := (others => '0');
  signal r_next_new_y                                             : signed(21 downto 0) := (others => '0');

  signal r_current_old_x                                          : integer range 0 to 999 := 0;
  signal r_current_old_y                                          : integer range 0 to 999 := 0;
  signal r_current_old_pixel                                      : std_logic_vector(7 downto 0) := (others => '0');

  signal r_current_old_coordinate_read_pointer                    : integer range 0 to 307200 := 0;
  signal r_current_old_pixel_read_pointer                         : integer range 0 to 307200 := 0;
  -- signal r_ram_write_pointer                        : integer range 0 to 307200;

  signal r_old_coordinate_invalid                                 : std_logic := '0';

  signal w_new_coordinate_lut                                     : integer range 0 to 307200;
  signal w_old_coordinate_lut                                     : integer range 0 to 307200;

  signal r_old_pixel                                              : std_logic_vector(7 downto 0) := (others => '0');

  signal r_next_old_coordinate_ready                              : std_logic := '0';
  signal r_ram_write_finished                                     : std_logic := '0';

  signal r_current_file_write_column                              : integer range 0 to 639 := 0;
  signal r_current_file_write_row                                 : integer range 0 to 479 := 0;
  signal w_file_write_lut                                         : integer range 0 to 307200;

  signal r_lock_start                                             : std_logic := '0';

  signal r_read_req_acknowledged                                  : std_logic := '0';
  
  signal r_lock_sdram_request : std_logic := '0';
  
    -- disparity --
 
  signal r_disparity_generator_in : std_logic_vector(9 downto 0) := (others => '0');
  signal r_disparity_ready_for_output                             : std_logic := '0';
  signal r_disparity_start : std_logic := '0';
  
  signal r_ram_disparity_data_in : std_logic_vector(7 downto 0) := (others => '0');

  -- END RECTIFICATION

  attribute keep : boolean;
  attribute preserve : boolean;
  attribute noprune : boolean;

  attribute keep of r_pixel_col_count     : signal is true;
  attribute preserve of r_pixel_col_count : signal is true;
  attribute noprune of r_pixel_col_count  : signal is true;

  attribute keep of r_pixel_row_count     : signal is true;
  attribute preserve of r_pixel_row_count : signal is true;
  attribute noprune of r_pixel_row_count  : signal is true;

  attribute keep of r_current_old_x     : signal is true;
  attribute preserve of r_current_old_x : signal is true;
  attribute noprune of r_current_old_x  : signal is true;

  attribute keep of r_current_old_y     : signal is true;
  attribute preserve of r_current_old_y : signal is true;
  attribute noprune of r_current_old_y  : signal is true;

  attribute keep of r_read_req_acknowledged     : signal is true;
  attribute preserve of r_read_req_acknowledged : signal is true;
  attribute noprune of r_read_req_acknowledged  : signal is true;

  component PLL is
    port (
      CLK_CLK            : in    std_logic                     := 'X';
      CLK_SYSTEM_CLK     : out   std_logic;
      RESET_RESET_N      : in    std_logic                     := 'X';
      CLK_SDRAM_CLK      : out   std_logic;
      CLK_VGA_CLK        : out   std_logic;
      CLK_I2C_CLK        : out   std_logic;
      CLK_I2C_DOUBLE_CLK : out   std_logic;
      CLK_CAMERA_CLK     : out   std_logic
    );
  end component pll;

  component SDRAM_CONTROLLER is
    generic (
      G_CLK_FREQ           : real := 90.0;

      G_ADDR_WIDTH         : natural := 25;

      G_SDRAM_ADDR_WIDTH   : natural := 13;
      G_SDRAM_DATA_WIDTH   : natural := 32;
      G_SDRAM_COL_WIDTH    : natural := 10;
      G_SDRAM_ROW_WIDTH    : natural := 13;
      G_SDRAM_BANK_WIDTH   : natural := 2;

      G_CAS_LATENCY        : natural := 2;

      G_BURST_LENGTH       : natural := 1;

      G_WRITE_BURST_MODE   : std_logic := '0';

      G_T_DESL             : real := 200000.0;
      G_T_MRD              : real := 15.0;
      G_T_RC               : real := 60.0;
      G_T_RCD              : real := 15.0;
      G_T_RP               : real := 15.0;
      G_T_WR               : real := 15.0;
      G_T_REFI             : real := 7812.5;
      G_USE_AUTO_PRECHARGE : std_logic := '0'
    );
    port (
      I_RESET_N           : in    std_logic := '1';
      I_CLOCK             : in    std_logic;
      I_ADDRESS           : in    unsigned(G_ADDR_WIDTH - 1 downto 0);
      I_DATA              : in    std_logic_vector(G_SDRAM_DATA_WIDTH - 1 downto 0);
      I_WRITE_ENABLE      : in    std_logic;
      I_REQUEST           : in    std_logic;
      O_ACKNOWLEDGE       : out   std_logic;
      O_VALID             : out   std_logic;
      O_Q                 : out   std_logic_vector(G_SDRAM_DATA_WIDTH - 1 downto 0);
      O_SDRAM_A           : out   unsigned(G_SDRAM_ADDR_WIDTH - 1 downto 0);
      O_SDRAM_BA          : out   unsigned(G_SDRAM_BANK_WIDTH - 1 downto 0);
      IO_SDRAM_DQ         : inout std_logic_vector(G_SDRAM_DATA_WIDTH - 1 downto 0);
      O_SDRAM_CKE         : out   std_logic;
      O_SDRAM_CS          : out   std_logic;
      O_SDRAM_RAS         : out   std_logic;
      O_SDRAM_CAS         : out   std_logic;
      O_SDRAM_WE          : out   std_logic;
      O_SDRAM_DQML        : out   std_logic;
      O_SDRAM_DQMH        : out   std_logic;
      O_SDRAM_INITIALIZED : out   std_logic
    );
  end component sdram_controller;

  component VGA_FIFO is
    port (
      DATA    : in    std_logic_vector(23 downto 0);
      RDCLK   : in    std_logic;
      RDREQ   : in    std_logic;
      WRCLK   : in    std_logic;
      WRREQ   : in    std_logic;
      Q       : out   std_logic_vector(23 downto 0);
      RDEMPTY : out   std_logic;
      WRFULL  : out   std_logic;
      WRUSEDW : out   std_logic_vector(12 downto 0);
      RDUSEDW : out   std_logic_vector(12 downto 0);
      ACLR    : in    std_logic
    );
  end component vga_fifo;

  component SDRAM_FIFO is
    port (
      DATA    : in    std_logic_vector(7 downto 0);
      RDCLK   : in    std_logic;
      RDREQ   : in    std_logic;
      WRCLK   : in    std_logic;
      WRREQ   : in    std_logic;
      Q       : out   std_logic_vector(7 downto 0);
      RDEMPTY : out   std_logic;
      WRFULL  : out   std_logic;
      WRUSEDW : out   std_logic_vector(12 downto 0);
      RDUSEDW : out   std_logic_vector(12 downto 0);
      ACLR    : in    std_logic
    );
  end component sdram_fifo;

  component VGA_PUFFER is
    port (
      DATA    : in    std_logic_vector(11 downto 0);
      RDCLK   : in    std_logic;
      RDREQ   : in    std_logic;
      WRCLK   : in    std_logic;
      WRREQ   : in    std_logic;
      Q       : out   std_logic_vector(11 downto 0);
      RDEMPTY : out   std_logic;
      WRFULL  : out   std_logic;
      WRUSEDW : out   std_logic_vector(8 downto 0);
      RDUSEDW : out   std_logic_vector(8 downto 0)
    );
  end component;

  component VGA_CONTROLLER is
    generic (
      G_HORIZONTAL_DISPLAY : integer := c_image_width;
      G_VERTICAL_DISPLAY   : integer := c_image_height;
      G_PIXEL_WIDTH        : integer := 8;

      G_H_FRONT_PORCH_SIZE : integer := 16;
      G_H_BACK_PORCH_SIZE  : integer := 48;
      G_H_SYNC_SIZE        : integer := 96;

      G_V_BACK_PORCH_SIZE  : integer := 33;
      G_V_FRONT_PORCH_SIZE : integer := 10;
      G_V_SYNC_SIZE        : integer := 2
    );
    port (
      I_CLOCK       : in    std_logic;
      I_RESET_N     : in    std_logic;
      I_VGA_BLANK_N : in    std_logic;
      O_H_SYNC_N    : out   std_logic;
      O_V_SYNC_N    : out   std_logic;
      O_VALID_PIXEL : out   std_logic;
      I_RED         : in    std_logic_vector(G_PIXEL_WIDTH - 1 downto 0);
      I_GREEN       : in    std_logic_vector(G_PIXEL_WIDTH - 1 downto 0);
      I_BLUE        : in    std_logic_vector(G_PIXEL_WIDTH - 1 downto 0);
      O_RED         : out   std_logic_vector(G_PIXEL_WIDTH - 1 downto 0);
      O_GREEN       : out   std_logic_vector(G_PIXEL_WIDTH - 1 downto 0);
      O_BLUE        : out   std_logic_vector(G_PIXEL_WIDTH - 1 downto 0);
      O_VGA_SYNC_N  : out   std_logic;
      O_VGA_BLANK_N : out   std_logic
    );
  end component vga_controller;

  component KAMERA_CONTROLLER is
    generic (
      G_COLOR_BW            : string := "GRAY";
      G_COLUMN_SIZE         : integer := 2559;
      G_ROW_SIZE            : integer := 1919;
      G_SHUTTER_WIDTH_LOWER : integer := 1250;

      G_ROW_SKIP            : integer := 1;
      G_COLUMN_SKIP         : integer := 1;
      G_ROW_START           : integer := 54
    );
    port (
      I_CAMERA_CLOCK                   : in    std_logic;
      I_I2C_CLOCK                      : in    std_logic;
      I_RESET_N                        : in    std_logic;

      ---------------- Kamera -----------------------------
      I_PIXEL_RAW                      : in    std_logic_vector(11 downto 0);
      I_PIXCLK                         : in    std_logic;
      I_STROBE                         : in    std_logic;
      I_LVAL                           : in    std_logic;
      I_FVAL                           : in    std_logic;

      IO_SDATA                         : inout std_logic;
      O_SCLK                           : out   std_logic;

      O_XCLK                           : out   std_logic;
      O_CAMERA_RESET_N                 : out   std_logic;
      O_TRIGGER                        : out   std_logic;

      O_RAW_PIXEL_VALID                : out   std_logic;
      O_RAW_PIXEL_FULL_WIDTH           : out   std_logic_vector(11 downto 0);
      O_RAW_PIXEL_REDUCED_WIDTH        : out   std_logic_vector(7 downto 0);

      ----------------- berechnete Pixel -------------------
      O_NEW_FRAME_STARTED              : out   std_logic;
      O_CALCULATED_PIXEL_REDUCED_WIDTH : out   std_logic_vector(23 downto 0);
      O_CALCULATED_PIXEL_FULL_WIDTH    : out   std_logic_vector(35 downto 0);
      O_CALCULATED_PIXEL_VALID         : out   std_logic
    );
  end component kamera_controller;

  component UART_TEST is
    port (
      I_CLOCK                     : in    std_logic;
      I_START_TRANSMISSION        : in    std_logic;
      I_DATA                      : in    std_logic_vector(7 downto 0);
      O_TRANSMISSION_ACTIVE       : out   std_logic;
      O_TRANSMISSION_DATA         : out   std_logic;
      O_TRANSMISSION_FINISHED     : out   std_logic
    );
  end component uart_test;

  component RECTIFICATION is
    generic (
G_H_11 : sfixed(16 downto -15) := to_sfixed(0.01056580, 16, -15);
G_H_12 : sfixed(16 downto -15) := to_sfixed(-0.00011774, 16, -15);
G_H_13 : sfixed(16 downto -15) := to_sfixed(0.04633187, 16, -15);

G_H_21 : sfixed(16 downto -15) := to_sfixed(0.00019305, 16, -15);
G_H_22 : sfixed(16 downto -15) := to_sfixed(0.01018863, 16, -15);
G_H_23 : sfixed(16 downto -15) := to_sfixed(-0.28007307, 16, -15);

G_H_31 : sfixed(16 downto -15) := to_sfixed(0.00000079, 16, -15);
G_H_32 : sfixed(16 downto -15) := to_sfixed(0.00000000, 16, -15);
G_H_33 : sfixed(16 downto -15) := to_sfixed(0.00996014, 16, -15);

G_H_INV_11 : sfixed(16 downto -15) := to_sfixed(94.65545406, 16, -15);
G_H_INV_12 : sfixed(16 downto -15) := to_sfixed(1.09381708, 16, -15);
G_H_INV_13 : sfixed(16 downto -15) := to_sfixed(-409.55421040, 16, -15);

G_H_INV_21 : sfixed(16 downto -15) := to_sfixed(-1.99867065, 16, -15);
G_H_INV_22 : sfixed(16 downto -15) := to_sfixed(98.12546822, 16, -15);
G_H_INV_23 : sfixed(16 downto -15) := to_sfixed(2768.52665255, 16, -15);

G_H_INV_31 : sfixed(16 downto -15) := to_sfixed(-0.00746399, 16, -15);
G_H_INV_32 : sfixed(16 downto -15) := to_sfixed(-0.00008722, 16, -15);
G_H_INV_33 : sfixed(16 downto -15) := to_sfixed(100.43250031, 16, -15)
    );
    port (
      I_CLOCK              : in    std_logic;
      I_RESET_N            : in    std_logic;

      I_START              : in    std_logic;
      I_X                  : signed(21 downto 0);
      I_Y                  : signed(21 downto 0);
      I_USE_INVERSE        : in    std_logic;

      O_X                  : out   integer range -999999 to 999999;
      O_Y                  : out   integer range -999999 to 999999;
      O_VALID              : out   std_logic;
      O_ACK                : out   std_logic;
      O_COORDINATE_INVALID : out   std_logic
    );
  end component;
  
  component DISPARITY_GENERATOR is
    generic (
      G_IMAGE_WIDTH          : integer := c_image_width;
      G_IMAGE_HEIGHT         : integer := c_image_height;
      G_BLOCK_SIZE           : integer := c_block_size;
      G_MINIMAL_DISPARITY    : integer := c_minimal_disparity;
      G_MAXIMUM_DISPARITY    : integer := c_maximum_disparity;
      G_BACKGROUND_THRESHOLD : integer := c_color_threshold;
      G_MAX_SAD              : integer := 9999
    );
    port (
      I_CLOCK                 : in    std_logic;
      I_RESET_N               : in    std_logic;
      I_WRITE_ENABLE          : in    std_logic;
      I_PIXEL                 : in    std_logic_vector(9 downto 0);

      O_READY                 : out   std_logic;
      O_DISPARITY_PIXEL       : out   std_logic_vector(7 downto 0);
      O_DISPARITY_PIXEL_VALID : out   std_logic
    );
  end component disparity_generator;

begin

  U0 : PLL
    port map (
      CLK_CLK            => I_CLOCK,
      RESET_RESET_N      => w_reset_n,
      CLK_SYSTEM_CLK     => w_clk_system,
      CLK_VGA_CLK        => w_clk_vga,
      CLK_SDRAM_CLK      => w_clk_sdram,
      CLK_I2C_CLK        => w_clk_i2c,
      CLK_I2C_DOUBLE_CLK => w_clk_i2c_double,
      CLK_CAMERA_CLK     => w_clk_camera
    );

  U1 : VGA_FIFO
    port map (
      DATA    => w_vga_fifo_data_in,
      RDCLK   => w_clk_system,
      RDREQ   => w_vga_fifo_rdreq,
      WRCLK   => w_clk_system,
      WRREQ   => w_vga_fifo_wrreq,
      Q       => w_vga_fifo_q,
      RDEMPTY => w_vga_fifo_rdempty,
      WRFULL  => w_vga_fifo_wrfull,
      WRUSEDW => w_vga_fifo_wrusedw,
      RDUSEDW => w_vga_fifo_rdusedw,
      ACLR    => w_vga_fifo_aclr
    );

  U2 : VGA_CONTROLLER
    port map (
      I_CLOCK       => w_clk_vga,
      I_RESET_N     => w_vga_reset,
      I_RED         => w_vga_data_in(23 downto 16),
      I_GREEN       => w_vga_data_in(15 downto 8),
      I_BLUE        => w_vga_data_in(7 downto 0),
      I_VGA_BLANK_N => w_vga_blank_n,
      O_VALID_PIXEL => w_vga_ready,
      O_H_SYNC_N    => O_H_SYNC,
      O_V_SYNC_N    => O_V_SYNC,
      O_RED         => O_VGA_R,
      O_GREEN       => O_VGA_G,
      O_BLUE        => O_VGA_B,
      O_VGA_SYNC_N  => O_VGA_SYNC_N,
      O_VGA_BLANK_N => O_VGA_BLANK_N
    );

  U3 : SDRAM_CONTROLLER
    port map (
      -- reset
      I_RESET_N           => w_reset_n,
      I_CLOCK             => w_clk_system,
      I_ADDRESS           => unsigned(w_sdram_addr),
      I_DATA              => w_sdram_writedata,
      I_WRITE_ENABLE      => not w_sdram_we_n,
      I_REQUEST           => w_sdram_req,
      O_ACKNOWLEDGE       => w_sdram_ack,
      O_VALID             => w_sdram_rdval,
      O_Q                 => w_sdram_readdata,
      O_SDRAM_A           => O_DRAM_ADDR,
      O_SDRAM_BA          => O_DRAM_BA,
      IO_SDRAM_DQ         => IO_DRAM_DQ,
      O_SDRAM_CKE         => O_DRAM_CKE,
      O_SDRAM_CS          => O_DRAM_CS_N,
      O_SDRAM_RAS         => O_DRAM_RAS_N,
      O_SDRAM_CAS         => O_DRAM_CAS_N,
      O_SDRAM_WE          => O_DRAM_WE_N,
      O_SDRAM_DQML        => w_dqml,
      O_SDRAM_DQMH        => w_dqmh,
      O_SDRAM_INITIALIZED => w_sdram_initialized
    );

  U4 : SDRAM_FIFO
    port map (
      DATA    => r_sdram_fifo_data_in,
      RDCLK   => w_clk_system,
      RDREQ   => w_sdram_fifo_rdreq,
      WRCLK   => w_clk_camera,
      WRREQ   => r_sdram_fifo_wrreq,
      Q       => w_sdram_fifo_q,
      RDEMPTY => w_sdram_fifo_rdempty,
      WRFULL  => w_sdram_fifo_wrfull,
      WRUSEDW => w_sdram_fifo_wrusedw,
      RDUSEDW => w_sdram_fifo_rdusedw,
      ACLR    => w_sdram_fifo_aclr
    );

  COMP_CAMERA_LEFT : KAMERA_CONTROLLER
    port map (
      I_CAMERA_CLOCK => w_clk_camera,
      I_I2C_CLOCK    => w_clk_i2c,
      I_RESET_N      => w_reset_n,

      I_PIXCLK    => w_left_camera_pixclk,
      I_PIXEL_RAW => w_left_camera_out_raw,
      I_STROBE    => w_left_camera_strobe,
      I_LVAL      => w_left_camera_lval,
      I_FVAL      => w_left_camera_fval,

      O_SCLK   => O_HSMC_J3_24,
      IO_SDATA => IO_HSMC_J3_23,

      O_CAMERA_RESET_N => w_left_camera_reset_n,
      O_TRIGGER        => w_left_camera_trigger,

      O_NEW_FRAME_STARTED              => w_left_new_frame_started,
      O_CALCULATED_PIXEL_REDUCED_WIDTH => w_left_camera_pixel_out_reduced_width,
      O_CALCULATED_PIXEL_FULL_WIDTH    => open,
      O_CALCULATED_PIXEL_VALID         => w_left_camera_pixel_valid
    );

  COMP_CAMERA_RIGHT : KAMERA_CONTROLLER
    port map (
      I_CAMERA_CLOCK => w_clk_camera,
      I_I2C_CLOCK    => w_clk_i2c,
      I_RESET_N      => w_reset_n,

      I_PIXCLK    => w_right_camera_pixclk,
      I_PIXEL_RAW => w_right_camera_out_raw,
      I_STROBE    => w_right_camera_strobe,
      I_LVAL      => w_right_camera_lval,
      I_FVAL      => w_right_camera_fval,

		O_SCLK   => O_GPIO_24,
      IO_SDATA => O_GPIO_23,

      O_CAMERA_RESET_N => w_right_camera_reset_n,
      O_TRIGGER        => w_right_camera_trigger,

      O_NEW_FRAME_STARTED              => w_right_new_frame_started,
      O_CALCULATED_PIXEL_REDUCED_WIDTH => w_right_camera_pixel_out_reduced_width,
      O_CALCULATED_PIXEL_FULL_WIDTH    => open,
      O_CALCULATED_PIXEL_VALID         => w_right_camera_pixel_valid
    );

  U6 : UART_TEST
    port map (
      I_CLOCK                 => w_clk_system,
      I_START_TRANSMISSION    => w_start_transmission,
      I_DATA                  => w_uart_in,
      O_TRANSMISSION_ACTIVE   => O_TX_ACTIVE,
      O_TRANSMISSION_DATA     => O_TX_SERIAL,
      O_TRANSMISSION_FINISHED => w_tx_done
    );

  RECT : RECTIFICATION
    port map (
      I_CLOCK   => w_clk_system,
      I_RESET_N => w_reset_n,

      I_START       => r_start_rectification,
      I_X           => r_i_x,
      I_Y           => r_i_y,
      I_USE_INVERSE => r_use_inverse,

      O_X                  => w_o_x,
      O_Y                  => w_o_y,
      O_VALID              => w_rect_valid,
      O_ACK                => w_rect_ack,
      O_COORDINATE_INVALID => w_coordinate_invalid
    );
	 
	   DISPARITY : DISPARITY_GENERATOR
    port map (
      I_CLOCK        => w_clk_system,
      I_RESET_N      => w_reset_n,
      I_WRITE_ENABLE => r_disparity_start,
      I_PIXEL        => r_disparity_generator_in,
      -- I_PIXEL        => r_ram_q(7 downto 0),

      O_READY                 => w_disparity_ready,
      O_DISPARITY_PIXEL       => w_disparity_pixel,
      O_DISPARITY_PIXEL_VALID => w_disparity_pixel_valid
    );

  ---------------------
  -- Fill sdram fifo --
  ---------------------

  PROC_CAMERA_FIFO_WRITE : process(w_clk_camera, w_reset_n)

  begin

    if(w_reset_n = '0') then

      r_sdram_fifo_wrreq_delay1   <= '0';
      r_sdram_fifo_data_in_delay1 <= (others => '0');

      r_sdram_fifo_wrreq   <= '0';
      r_sdram_fifo_data_in <= (others => '0');
      
    elsif(rising_edge(w_clk_camera)) then
      
      if (w_right_input_image_valid = '1' and r_current_state = WRITE_RIGHT) then
        r_sdram_fifo_wrreq_delay1 <= w_right_input_image_valid;
        r_sdram_fifo_data_in_delay1 <= w_right_camera_pixel_out_reduced_width(7 downto 0);
      elsif (w_left_input_image_valid = '1' and r_current_state = WRITE_LEFT) then
        r_sdram_fifo_wrreq_delay1 <= '1';
        r_sdram_fifo_data_in_delay1 <= w_left_camera_pixel_out_reduced_width(7 downto 0);
      else
        r_sdram_fifo_wrreq_delay1 <= '0';
        r_sdram_fifo_data_in_delay1 <= (others => '0');

      end if;

      r_sdram_fifo_wrreq   <= r_sdram_fifo_wrreq_delay1;
      r_sdram_fifo_data_in <= r_sdram_fifo_data_in_delay1;

    end if;

  end process;

  --------------------------------------------
  -- read/write state machine and registers --
  --------------------------------------------

  PROC_STATE_OUT : process (r_read_req_acknowledged, r_current_state, r_ram_write_pointer, w_sdram_fifo_rdempty, w_sdram_ack, w_left_new_frame_started, w_sdram_initialized, w_left_camera_pixel_valid, r_ram_read_pointer) is

  begin

    case r_current_state is

      when flush_fifos =>

        w_next_state <= RECTIFICATION_CALCULATE_OLD_COORDINATE;

        w_sdram_addr                   <= std_logic_vector(to_unsigned(r_ram_write_pointer, w_sdram_addr'length));
        w_sdram_we_n                   <= '1';
        w_vga_reset                    <= '1';
        w_vga_fifo_aclr                <= '1';
        w_sdram_req                    <= '0';
        w_sdram_fifo_aclr              <= '1';
        w_sdram_fifo_rdreq             <= '0';
        w_sdram_writedata(31 downto 0) <= (others => '0');

      when RECTIFICATION_CALCULATE_OLD_COORDINATE =>

        if (w_rect_valid = '1') then
          w_next_state <= RECTIFICATION_STORE_OLD_COORDINATE;
        else
          w_next_state <= RECTIFICATION_CALCULATE_OLD_COORDINATE;
        end if;

        w_sdram_writedata(31 downto 0) <= (others => '0');
        w_sdram_req                    <= '0';
        w_sdram_we_n                   <= '1';
        w_sdram_addr                   <= (others => '0');
        w_sdram_fifo_aclr              <= '0';
        w_sdram_fifo_rdreq             <= '0';
        w_vga_reset                    <= '1';
        w_vga_fifo_aclr                <= '1';

      when RECTIFICATION_STORE_OLD_COORDINATE =>

        if (w_sdram_ack = '1') then
          if (r_ram_write_pointer = c_max_rgb_count - 1) then
            w_next_state <= wait_for_new_frame_left;
          else
            w_next_state <= RECTIFICATION_CALCULATE_OLD_COORDINATE;
          end if;
        else
          w_next_state <= RECTIFICATION_STORE_OLD_COORDINATE;
        end if;

        if (r_read_req_acknowledged = '0') then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;

        w_sdram_we_n         <= '0';
        w_sdram_addr         <= std_logic_vector(to_unsigned(r_ram_write_pointer + c_rect_coordinate_offset, w_sdram_addr'length));
        w_sdram_writedata    <= std_logic_vector(to_unsigned(r_current_old_x, 16)) & std_logic_vector(to_unsigned(r_current_old_y, 16));
        w_sdram_fifo_aclr    <= '0';
        w_sdram_fifo_rdreq   <= '0';
        w_vga_reset          <= '1';
        w_vga_fifo_aclr      <= '1';

      when wait_for_new_frame_left =>

        if (w_left_new_frame_started = '1' and w_sdram_initialized = '1') then
          w_next_state <= write_left;
        else
          w_next_state <= wait_for_new_frame_left;
        end if;

        w_sdram_addr         <= std_logic_vector(to_unsigned(r_ram_write_pointer, w_sdram_addr'length));
        w_sdram_we_n         <= '0';
        w_sdram_req          <= '0';
        w_sdram_fifo_aclr    <= '0';

        w_sdram_fifo_rdreq   <= '0';
        w_sdram_writedata    <= "000000000000000000000000" & w_sdram_fifo_q;
        w_vga_reset          <= '1';
        w_vga_fifo_aclr      <= '1';
		  w_sdram_req <= '0';

      when write_left =>

        if (r_ram_write_pointer = c_max_rgb_count - 1 and w_sdram_ack = '1') then
          w_next_state <= wait_for_new_frame_right;
        else
          w_next_state <= write_left;
        end if;

        w_sdram_addr         <= std_logic_vector(to_unsigned(r_ram_write_pointer, w_sdram_addr'length));
        w_sdram_we_n         <= '0';
        w_sdram_fifo_aclr    <= '0';
        
        w_sdram_writedata    <= "000000000000000000000000" & w_sdram_fifo_q;
        w_vga_reset          <= '1';
        w_vga_fifo_aclr      <= '1';

        if (w_sdram_fifo_rdempty = '0') then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;

        if (w_sdram_ack = '1') then
          w_sdram_fifo_rdreq <= '1';
        else
          w_sdram_fifo_rdreq <= '0';
        end if;

      when wait_for_new_frame_right =>

        if (w_right_new_frame_started = '1' and w_sdram_initialized = '1') then
          w_next_state <= write_right;
        else
          w_next_state <= wait_for_new_frame_right;
        end if;

        w_sdram_addr         <= std_logic_vector(to_unsigned(r_ram_write_pointer + c_image_2_offset, w_sdram_addr'length));
        w_sdram_we_n         <= '0';
        w_sdram_req          <= '0';
        w_sdram_fifo_aclr    <= '0';
        w_sdram_fifo_rdreq   <= '0';
        w_sdram_writedata    <= "000000000000000000000000" & w_sdram_fifo_q;
        w_vga_reset          <= '1';
        w_vga_fifo_aclr      <= '1';

      when write_right =>

        if (r_ram_write_pointer = c_max_rgb_count - 1 and w_sdram_ack = '1') then
          w_next_state <= RECTIFICATION_LOAD_OLD_COORDINATE;
        else
          w_next_state <= write_right;
        end if;

        w_sdram_addr         <= std_logic_vector(to_unsigned(r_ram_write_pointer + c_image_2_offset, w_sdram_addr'length));
        w_sdram_we_n         <= '0';
        w_sdram_fifo_aclr    <= '0';
        
        w_sdram_writedata    <= "000000000000000000000000" & w_sdram_fifo_q;
        w_vga_reset          <= '1';
        w_vga_fifo_aclr      <= '1';

        if (w_sdram_fifo_rdempty = '0') then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;

        if (w_sdram_ack = '1') then
          w_sdram_fifo_rdreq <= '1';
        else
          w_sdram_fifo_rdreq <= '0';
        end if;

      -- RECTIFICATION

      when RECTIFICATION_LOAD_OLD_COORDINATE =>

        if (w_sdram_rdval = '1') then
          w_next_state <= RECTIFICATION_LOAD_OLD_PIXEL;
        else
          w_next_state <= RECTIFICATION_LOAD_OLD_COORDINATE;
        end if;

        w_sdram_addr <= std_logic_vector(to_unsigned(r_ram_write_pointer + c_rect_coordinate_offset, w_sdram_addr'length));
        w_sdram_we_n <= '1';

        if (r_read_req_acknowledged = '0') then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;

        w_sdram_fifo_aclr    <= '0';
        w_sdram_fifo_rdreq   <= '0';
        w_sdram_writedata    <= (others => '0');
        w_vga_reset          <= '1';
        w_vga_fifo_aclr      <= '1';

      when RECTIFICATION_LOAD_OLD_PIXEL =>

        if (w_sdram_rdval = '1') then
          w_next_state <= RECTIFICATION_STORE_NEW_PIXEL;
        else
          w_next_state <= RECTIFICATION_LOAD_OLD_PIXEL;
        end if;

        w_sdram_addr <= std_logic_vector(to_unsigned(r_current_old_pixel_read_pointer + c_image_1_offset, w_sdram_addr'length));
        w_sdram_we_n <= '1';

        if (r_read_req_acknowledged = '0') then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;

        w_sdram_fifo_aclr    <= '0';
        w_sdram_fifo_rdreq   <= '0';
        w_sdram_writedata    <= "000000000000000000000000" & w_sdram_fifo_q;
        w_vga_reset          <= '1';
        w_vga_fifo_aclr      <= '1';

      when RECTIFICATION_STORE_NEW_PIXEL =>

        if (w_sdram_ack = '1') then
          if (r_ram_write_pointer = c_max_rgb_count - 1) then
            w_next_state <= TRANSMIT_TO_DISPARITY_GENERATOR_LEFT;
          else
            w_next_state <= RECTIFICATION_LOAD_OLD_COORDINATE;
          end if;
        else
          w_next_state <= RECTIFICATION_STORE_NEW_PIXEL;
        end if;

        w_sdram_addr <= std_logic_vector(to_unsigned(r_ram_write_pointer + c_image_rect_offset, w_sdram_addr'length));
        w_sdram_we_n <= '0';

        if (r_read_req_acknowledged = '0') then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;

        w_sdram_fifo_aclr    <= '0';
        w_sdram_fifo_rdreq   <= '0';
        w_sdram_writedata    <= "000000000000000000000000" & r_old_pixel;
        w_vga_reset          <= '1';
        w_vga_fifo_aclr      <= '1';
		  
      when TRANSMIT_TO_DISPARITY_GENERATOR_LEFT =>

        -- w_sdram_addr       <= std_logic_vector(to_unsigned(r_ram_read_pointer_right + 307200, w_sdram_addr'length));
        -- w_sdram_addr       <= std_logic_vector(to_unsigned(r_ram_read_pointer_left, w_sdram_addr'length));
        w_sdram_addr       <= std_logic_vector(to_unsigned(r_ram_read_pointer_left + c_image_rect_offset, w_sdram_addr'length));
        w_sdram_we_n       <= '1';
        w_sdram_fifo_aclr  <= '0';
        w_sdram_fifo_rdreq <= '0';
		  w_sdram_writedata(31 downto 0) <= (others => '0');
		  w_vga_reset                    <= '1';
		  w_vga_fifo_aclr                <= '0';
      -- r_disparity_generator_in <= std_logic_vector(to_signed(to_integer(unsigned(w_sdram_readdata)) - to_integer(signed(w_mean_value_left)), 10));


        if (r_requested_from_ram_count < c_image_width * c_block_size) then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;

        --w_sdram_fifo_data_in <= (others => '0');

        -- TODO Rechnung takten
        if (r_read_from_ram_count = c_image_width * c_block_size - 1) then
          w_next_state <= TRANSMIT_TO_DISPARITY_GENERATOR_RIGHT;
        else
          w_next_state <= TRANSMIT_TO_DISPARITY_GENERATOR_LEFT;
        end if;
----
	when TRANSMIT_TO_DISPARITY_GENERATOR_RIGHT =>

        -- w_sdram_addr       <= std_logic_vector(to_unsigned(r_ram_read_pointer_left, w_sdram_addr'length));
        w_sdram_addr       <= std_logic_vector(to_unsigned(r_ram_read_pointer_right + c_image_2_offset, w_sdram_addr'length));
        w_sdram_we_n       <= '1';
        w_sdram_fifo_aclr  <= '0';
        w_sdram_fifo_rdreq <= '0';
		  w_sdram_writedata(31 downto 0) <= (others => '0');
      -- r_disparity_generator_in <= std_logic_vector(to_signed(to_integer(unsigned(w_sdram_readdata)) - to_integer(signed(w_mean_value_left)), 10));

        if (r_requested_from_ram_count < c_image_width * c_block_size) then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;

        --w_sdram_fifo_data_in <= (others => '0');

        -- TODO Rechnung takten
        if (r_read_from_ram_count = c_image_width * c_block_size - 1) then
          w_next_state <= LOAD_DISPARITY;
        else
          w_next_state <= TRANSMIT_TO_DISPARITY_GENERATOR_RIGHT;
        end if;
		  
		  w_vga_reset                    <= '1';
		  w_vga_fifo_aclr                <= '0';
--		  
		when LOAD_DISPARITY =>

        if (w_disparity_ready = '1' and r_current_disparity_image_row = c_disparity_height - 1) then
          -- w_next_state <= FINISHED;
          w_next_state <= READ_LEFT;
        elsif (w_disparity_ready = '1' and r_current_disparity_image_row < c_disparity_height - 1) then
          w_next_state <= TRANSMIT_TO_DISPARITY_GENERATOR_LEFT;
        else
          w_next_state <= LOAD_DISPARITY;
        end if;

        w_sdram_addr         <= std_logic_vector(to_unsigned(r_ram_write_pointer + c_disparity_offset, w_sdram_addr'length));
        w_sdram_we_n         <= '0';
        w_sdram_fifo_aclr    <= '0';
        w_sdram_fifo_rdreq   <= '0';

        if (r_lock_sdram_request = '1') then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;
		  
        --w_sdram_fifo_data_in <= (others => '0');
		  w_sdram_writedata <= "000000000000000000000000" & r_ram_disparity_data_in;
		  
		  w_vga_reset                    <= '1';
		  w_vga_fifo_aclr                <= '0';

      when read_left =>

        if (r_data_written_to_uart = c_max_rgb_count - 1 and w_tx_done = '1') then
          w_next_state <= read_right;
        else
          w_next_state <= read_left;
        end if;

        w_sdram_addr                   <= std_logic_vector(to_unsigned(r_ram_read_pointer + c_image_1_offset, w_sdram_addr'length));
        w_sdram_we_n                   <= '1';
        w_sdram_fifo_aclr              <= '0';
        w_sdram_fifo_rdreq             <= '0';
        w_sdram_writedata(31 downto 0) <= (others => '0');
        w_vga_reset                    <= '1';
        w_vga_fifo_aclr                <= '0';

        if (to_integer(unsigned(w_vga_fifo_wrusedw)) < 240 and r_ram_read_pointer < c_max_rgb_count) then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;

      when read_right =>

        if (r_data_written_to_uart = c_max_rgb_count - 1 and w_tx_done = '1') then
          w_next_state <= read_rectified;
        else
          w_next_state <= read_right;
        end if;

        w_sdram_addr                   <= std_logic_vector(to_unsigned(r_ram_read_pointer + c_image_2_offset, w_sdram_addr'length));
        w_sdram_we_n                   <= '1';
        w_sdram_we_n                   <= '1';
        w_sdram_fifo_aclr              <= '0';
        w_sdram_fifo_rdreq             <= '0';
        w_sdram_writedata(31 downto 0) <= (others => '0');
        w_vga_reset                    <= '1';
        w_vga_fifo_aclr                <= '0';

        if (to_integer(unsigned(w_vga_fifo_wrusedw)) < 240 and r_ram_read_pointer < c_max_rgb_count) then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;

      when read_rectified =>

        if (r_data_written_to_uart = c_max_rgb_count - 1 and w_tx_done = '1') then
          w_next_state <= read_disparity;
        else
          w_next_state <= read_rectified;
        end if;

        w_sdram_addr                   <= std_logic_vector(to_unsigned(r_ram_read_pointer + c_image_rect_offset, w_sdram_addr'length));
        w_sdram_we_n                   <= '1';
        w_vga_reset                    <= '1';
        w_vga_fifo_aclr                <= '0';
        w_sdram_fifo_aclr              <= '0';
        w_sdram_fifo_rdreq             <= '0';
        w_sdram_writedata(31 downto 0) <= (others => '0');

        if (to_integer(unsigned(w_vga_fifo_wrusedw)) < 240 and r_ram_read_pointer < c_max_rgb_count) then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;
		  
      when read_disparity =>

        if (r_data_written_to_uart = c_disparity_pixel_amount - 1 and w_tx_done = '1') then
          w_next_state <= finished;
        else
          w_next_state <= read_disparity;
        end if;

        w_sdram_addr                   <= std_logic_vector(to_unsigned(r_ram_read_pointer + c_disparity_offset, w_sdram_addr'length));
        w_sdram_we_n                   <= '1';
        w_vga_reset                    <= '1';
        w_vga_fifo_aclr                <= '0';
        w_sdram_fifo_aclr              <= '0';
        w_sdram_fifo_rdreq             <= '0';
        w_sdram_writedata(31 downto 0) <= (others => '0');

        if (to_integer(unsigned(w_vga_fifo_wrusedw)) < 240 and r_ram_read_pointer < c_disparity_pixel_amount) then
          w_sdram_req <= '1';
        else
          w_sdram_req <= '0';
        end if;

      when finished =>
        w_next_state                   <= finished;
        w_sdram_addr                   <= std_logic_vector(to_unsigned(r_ram_read_pointer + c_disparity_offset, w_sdram_addr'length));
        w_sdram_we_n                   <= '1';
        w_vga_reset                    <= '1';
        w_vga_fifo_aclr                <= '0';
        w_sdram_fifo_aclr              <= '0';
        w_sdram_fifo_rdreq             <= '0';
        w_sdram_writedata(31 downto 0) <= (others => '0');
        w_sdram_req                    <= '0';

    end case;

  end process PROC_STATE_OUT;

  PROC_STATE_FF : process (w_reset_n, w_clk_system) is
  begin

    if (w_reset_n = '0' or w_take_picture = '0') then
      r_current_state          <= flush_fifos;
      r_ram_write_pointer      <= 0;
      r_ram_read_pointer       <= 0;
      r_values_written_to_fifo <= 0;
      r_current_byte           <= 0;
      r_data_written_to_uart   <= 0;
      r_i_x                    <= (others => '0');
      r_i_y                    <= (others => '0');
      r_requested_from_ram_count       <= 0;
		r_use_inverse         <= '1';
		r_start_rectification <= '0';
	   r_current_old_x <= 999;
		r_current_old_y <= 999;
		r_read_req_acknowledged <= '0';
		r_current_old_pixel_read_pointer <= 0;
		r_old_pixel <= (others => '0');
		r_current_original_image_row <= 0;
		r_current_original_image_column <= 0;
      r_disparity_generator_in <= (others => '0');
      r_disparity_start <= '0';
		
    elsif (rising_edge(w_clk_system)) then
      r_current_state <= w_next_state;

      if (w_sdram_rdval = '1') then
        if (r_values_written_to_fifo < 307199) then
          r_values_written_to_fifo <= r_values_written_to_fifo + 1;
        else
          r_values_written_to_fifo <= 0;
        end if;
      end if;

      if (w_vga_fifo_wrreq = '1' and r_values_written_to_fifo < c_max_rgb_count - 1) then
        r_values_written_to_fifo <= r_values_written_to_fifo + 1;
      elsif (r_values_written_to_fifo = c_max_rgb_count - 1 and w_sdram_rdval = '0') then
        r_values_written_to_fifo <= 0;
      end if;

      r_i_x                 <= (others => '0');
      r_i_y                 <= (others => '0');
      r_use_inverse         <= '1';
      r_start_rectification <= '0';
		r_disparity_generator_in <= (others => '0');
      r_disparity_start <= '0';

      case r_current_state is

        when FLUSH_FIFOS =>
          r_values_written_to_fifo <= 0;
          r_ram_write_pointer      <= 0;
          r_i_x                    <= (others => '0');
          r_i_y                    <= (others => '0');
          r_use_inverse            <= '1';
          r_start_rectification    <= '0';
			 r_requested_from_ram_count       <= 0;
		    r_ram_read_pointer <= 0;
			 r_ram_read_pointer_left  <= 0;
          r_ram_read_pointer_right  <= 0;

        when RECTIFICATION_CALCULATE_OLD_COORDINATE =>

          if (w_rect_valid = '1') then
            if (w_coordinate_invalid = '0') then
              r_current_old_x <= w_o_x;
              r_current_old_y <= w_o_y;
            else
              r_current_old_x <= 999;
              r_current_old_y <= 999;
            end if;
          end if;
          r_start_rectification <= '1';
          r_i_x                 <= r_current_new_x;
          r_i_y                 <= r_current_new_y;

        when RECTIFICATION_STORE_OLD_COORDINATE =>
          if (w_sdram_ack = '1') then
            if (r_ram_write_pointer < c_max_rgb_count - 1) then
              r_ram_write_pointer <= r_ram_write_pointer + 1;
            else
              r_ram_write_pointer <= 0;
            end if;

            if (r_current_new_x < 639) then
              r_current_new_x <= r_current_new_x + 1;
            else
              r_current_new_x <= r_target_area_x_start;
            end if;

            if (r_current_new_x = 639) then
              if (r_current_new_y < 479) then
                r_current_new_y <= r_current_new_y + 1;
              else
                r_current_new_y <= r_target_area_y_start;
              end if;
            end if;
          end if;

          if (w_sdram_ack = '1') then
            r_read_req_acknowledged <= '1';
          end if;

          if (w_next_state /= r_current_state) then
            r_read_req_acknowledged <= '0';
          end if;

          r_start_rectification <= '0';

        when WAIT_FOR_NEW_FRAME_LEFT =>
          r_values_written_to_fifo <= 0;
          r_ram_write_pointer      <= 0;

          r_i_x                 <= (others => '0');
          r_i_y                 <= (others => '0');
          r_use_inverse         <= '1';
          r_start_rectification <= '0';

        when WRITE_LEFT =>
          if (w_sdram_ack = '1') then
            if (r_ram_write_pointer < c_max_rgb_count - 1) then
              r_ram_write_pointer <= r_ram_write_pointer + 1;
            else
              r_ram_write_pointer <= 0;
            end if;
          end if;

          r_i_x                 <= (others => '0');
          r_i_y                 <= (others => '0');
          r_use_inverse         <= '1';
          r_start_rectification <= '0';
  
        when WAIT_FOR_NEW_FRAME_RIGHT =>
          r_values_written_to_fifo <= 0;
          r_ram_write_pointer      <= 0;
          r_i_x                    <= (others => '0');
          r_i_y                    <= (others => '0');
          r_use_inverse            <= '1';
          r_start_rectification    <= '0';

        when WRITE_RIGHT =>

          if (w_sdram_ack = '1') then
            if (r_ram_write_pointer < c_max_rgb_count - 1) then
              r_ram_write_pointer <= r_ram_write_pointer + 1;
            else
              r_ram_write_pointer <= 0;
            end if;
          end if;
          r_i_x                 <= (others => '0');
          r_i_y                 <= (others => '0');
          r_use_inverse         <= '1';
          r_start_rectification <= '0';

        when RECTIFICATION_LOAD_OLD_COORDINATE =>
          r_start_rectification <= '0';

          if (w_sdram_rdval = '1') then
            r_current_old_x <= to_integer(unsigned(w_sdram_readdata(31 downto 16)));
            r_current_old_y <= to_integer(unsigned(w_sdram_readdata(15 downto 0)));

            r_current_old_pixel_read_pointer <= r_current_old_y * 640 + r_current_old_x;
            r_start_rectification            <= '0';
          end if;

          if (w_sdram_ack = '1') then
            r_read_req_acknowledged <= '1';
          end if;

          if (w_next_state /= r_current_state) then
            r_read_req_acknowledged <= '0';
          end if;

        when RECTIFICATION_LOAD_OLD_PIXEL =>
          if (w_sdram_rdval = '1') then
            if (r_current_old_x = 999 or r_current_old_y = 999) then
              r_old_pixel <= (others => '0');
            else
              r_old_pixel <= w_sdram_readdata(7 downto 0);
            end if;
          end if;

          if (w_sdram_ack = '1') then
            r_read_req_acknowledged <= '1';
          end if;

          if (w_next_state /= r_current_state) then
            r_read_req_acknowledged <= '0';
          end if;

          r_start_rectification <= '0';


        when RECTIFICATION_STORE_NEW_PIXEL =>

          if (w_sdram_ack = '1') then
            if (r_ram_write_pointer < c_max_rgb_count - 1) then
              r_ram_write_pointer <= r_ram_write_pointer + 1;
            else
              r_ram_write_pointer <= 0;
            end if;

            r_read_req_acknowledged <= '1';

            if (r_current_new_write_col < 639) then
              r_current_new_write_col <= r_current_new_write_col + 1;
            else
              r_current_new_write_col <= 0;
            end if;

            if (r_current_new_write_col = 639) then
              if (r_current_new_write_row < 479) then
                r_current_new_write_row <= r_current_new_write_row + 1;
              else
                r_current_new_write_row <= 0;
              end if;
            end if;
          end if;

          if (w_next_state /= r_current_state) then
            r_read_req_acknowledged <= '0';
          end if;

          r_start_rectification <= '0';
			 
 when TRANSMIT_TO_DISPARITY_GENERATOR_LEFT =>

          if (w_sdram_rdval = '1') then
            r_read_from_ram_count <= r_read_from_ram_count + 1;
          end if;

          if (w_next_state = TRANSMIT_TO_DISPARITY_GENERATOR_RIGHT) then
            r_read_from_ram_count      <= 0;
            r_requested_from_ram_count <= 0;
				    r_ram_read_pointer <= 0;
          end if;

          if (w_sdram_ack = '1') then
            r_requested_from_ram_count <= r_requested_from_ram_count + 1;
            if (r_ram_read_pointer_left  < c_max_rgb_count - 1) then
              r_ram_read_pointer_left  <= r_ram_read_pointer_left  + 1;
            else
              r_ram_read_pointer_left  <= 0;
            end if;

            if (r_current_original_image_column < c_image_width - 1) then
              r_current_original_image_column <= r_current_original_image_column + 1;
            else
              r_current_original_image_column <= 0;
            end if;

            if (r_current_original_image_column = c_image_width - 1 and r_current_original_image_row < c_image_height - 1) then
              if (r_current_original_image_row < c_image_width - 1) then
                r_current_original_image_row <= r_current_original_image_row + 1;
              else
                r_current_original_image_row <= 0;
              end if;
            end if;
          end if;

          r_disparity_generator_in <= std_logic_vector(to_signed(to_integer(unsigned(w_sdram_readdata)), 10));
          r_disparity_start <= w_sdram_rdval;
----			 
        when TRANSMIT_TO_DISPARITY_GENERATOR_RIGHT =>

          if (w_sdram_rdval = '1') then
            r_read_from_ram_count <= r_read_from_ram_count + 1;
          end if;

          if (w_next_state = LOAD_DISPARITY) then
            r_read_from_ram_count      <= 0;
            r_requested_from_ram_count <= 0;
				    r_ram_read_pointer <= 0;
          end if;

          if (w_sdram_ack = '1') then
            r_requested_from_ram_count <= r_requested_from_ram_count + 1;
            if (r_ram_read_pointer_right  < c_max_rgb_count - 1) then
              r_ram_read_pointer_right  <= r_ram_read_pointer_right  + 1;
            else
              r_ram_read_pointer_right  <= 0;
            end if;

            if (r_current_original_image_column < c_image_width - 1) then
              r_current_original_image_column <= r_current_original_image_column + 1;
            else
              r_current_original_image_column <= 0;
            end if;

            if (r_current_original_image_column = c_image_width - 1 and r_current_original_image_row < c_image_height - 1) then
              if (r_current_original_image_row < c_image_width - 1) then
                r_current_original_image_row <= r_current_original_image_row + 1;
              else
                r_current_original_image_row <= 0;
              end if;
            end if;
          end if;

          r_disparity_generator_in <= std_logic_vector(to_signed(to_integer(unsigned(w_sdram_readdata)), 10));
          r_disparity_start <= w_sdram_rdval;
--
		when LOAD_DISPARITY =>

          if (w_sdram_ack = '1') then
			 
				r_lock_sdram_request <= '0';
            if (r_ram_write_pointer < c_disparity_pixel_amount - 1) then
              r_ram_write_pointer <= r_ram_write_pointer + 1;
            else
              r_ram_write_pointer <= 0;
            end if;

            if (r_current_disparity_image_column < c_disparity_width - 1) then
              r_current_disparity_image_column <= r_current_disparity_image_column + 1;
            else
              r_current_disparity_image_column <= 0;
            end if;

            if (r_current_disparity_image_column = c_disparity_width - 1) then
              if (r_current_disparity_image_row < c_disparity_height - 1) then
                r_current_disparity_image_row <= r_current_disparity_image_row + 1;
              else
                r_current_disparity_image_row <= 0;
              end if;
            end if;
          end if;
			 
			if(w_disparity_pixel_valid = '1') then 
				r_lock_sdram_request <= '1';
				r_ram_disparity_data_in <= w_disparity_pixel;
			end if;

          if (w_next_state = READ_LEFT or w_next_state = FINISHED) then
            r_ram_write_pointer <= 0;
				r_ram_read_pointer <= 0;

            r_disparity_ready_for_output <= '1';
          end if;

          r_disparity_generator_in <= (others => '0');
          r_disparity_start <= '0';



        when READ_LEFT =>

          if (w_sdram_ack = '1') then
            -- Count one more than "needed" on purpose. The last count works as stop signal.
            if (r_ram_read_pointer < c_max_rgb_count) then
              r_ram_read_pointer <= r_ram_read_pointer + 1;
            end if;
          end if;

          if (w_next_state = READ_RIGHT) then
            r_ram_read_pointer <= 0;
          end if;

          if (w_tx_done = '1') then
            if (r_data_written_to_uart < c_max_rgb_count - 1) then
              r_data_written_to_uart <= r_data_written_to_uart + 1;
            else
              r_data_written_to_uart <= 0;
            end if;
          end if;

          r_i_x                 <= c_0;
          r_i_y                 <= c_0;
          r_use_inverse         <= '1';
          r_start_rectification <= '0';

        when READ_RIGHT =>

          if (w_sdram_ack = '1') then
            -- Count one more than "needed" on purpose. The last count works as stop signal.
            if (r_ram_read_pointer < c_max_rgb_count) then
              r_ram_read_pointer <= r_ram_read_pointer + 1;
            end if;
          end if;

          if (w_next_state = READ_RECTIFIED) then
            r_ram_read_pointer <= 0;
          end if;

          if (w_tx_done = '1') then
            if (r_data_written_to_uart < c_max_rgb_count - 1) then
              r_data_written_to_uart <= r_data_written_to_uart + 1;
            else
              r_data_written_to_uart <= 0;
            end if;
          end if;

          r_i_x                 <= c_0;
          r_i_y                 <= c_0;
          r_use_inverse         <= '1';
          r_start_rectification <= '0';

        when READ_RECTIFIED =>
          if (w_sdram_ack = '1') then
            -- Count one more than "needed" on purpose. The last count works as stop signal.
            if (r_ram_read_pointer < c_max_rgb_count) then
              r_ram_read_pointer <= r_ram_read_pointer + 1;
            end if;
          end if;

          if (w_next_state = READ_DISPARITY) then
            r_ram_read_pointer <= 0;
          end if;

          if (w_tx_done = '1') then
            if (r_data_written_to_uart < c_max_rgb_count - 1) then
              r_data_written_to_uart <= r_data_written_to_uart + 1;
            else
              r_data_written_to_uart <= 0;
            end if;
          end if;

          r_i_x                 <= c_0;
          r_i_y                 <= c_0;
          r_use_inverse         <= '1';
          r_start_rectification <= '0';
			 
        when READ_DISPARITY =>
          if (w_sdram_ack = '1') then
            -- Count one more than "needed" on purpose. The last count works as stop signal.
            if (r_ram_read_pointer < c_disparity_pixel_amount) then
              r_ram_read_pointer <= r_ram_read_pointer + 1;
            end if;
          end if;

          if (w_next_state = finished) then
            r_ram_read_pointer <= 0;
          end if;

          if (w_tx_done = '1') then
            if (r_data_written_to_uart < c_disparity_pixel_amount - 1) then
              r_data_written_to_uart <= r_data_written_to_uart + 1;
            else
              r_data_written_to_uart <= 0;
            end if;
          end if;

          r_i_x                 <= c_0;
          r_i_y                 <= c_0;
          r_use_inverse         <= '1';
          r_start_rectification <= '0';

        when finished =>
          r_i_x                 <= c_0;
          r_i_y                 <= c_0;
          r_use_inverse         <= '1';
          r_start_rectification <= '0';

      end case;

    end if;

  end process PROC_STATE_FF;

  w_uart_in <= w_vga_fifo_q(7 downto 0);

  w_start_transmission <= '1' when (r_current_state = read_left or r_current_state = read_right or r_current_state = read_rectified or r_current_state = read_disparity) and w_vga_fifo_rdempty = '0' else
                          '0';

--  w_start_transmission <= '1' when (r_current_state = read_left or r_current_state = read_right or r_current_state = read_rectified) and w_vga_fifo_rdempty = '0' else
--                          '0';

  -----------------
  -- vga & fifo control --
  -----------------
  w_vga_fifo_data_in <= w_sdram_readdata(23 downto 0);
  w_vga_fifo_wrreq   <= '1' when w_sdram_rdval = '1' and ((r_data_written_to_uart < c_max_rgb_count and (r_current_state = read_left or r_current_state = read_right or r_current_state = read_rectified)) or (r_data_written_to_uart < c_disparity_pixel_amount and r_current_state = read_disparity)) else
                        '0';

--  w_vga_fifo_wrreq   <= '1' when w_sdram_rdval = '1' and ((r_data_written_to_uart < c_max_rgb_count and (r_current_state = read_left or r_current_state = read_right or r_current_state = read_rectified))) else
--                        '0';

  w_vga_fifo_rdreq <= '1' when w_vga_fifo_rdempty = '0' and w_tx_done = '1' else
                      '0';

  -------------------------------
  -- process independent wires --
  -------------------------------

  w_left_input_image_valid <= '1' when w_left_camera_pixel_valid = '1' else
                              '0';

  w_right_input_image_valid <= '1' when w_right_camera_pixel_valid = '1' else
                               '0';

  --------------------------------------------
  --- Connect I/O with registers and wires ---
  --------------------------------------------
  O_LED_GREEN   <= (others => '0');
  O_LED_RED     <= (others => '0');
  O_7_SEGMENT_0 <= (others => '1');
  O_7_SEGMENT_1 <= (others => '1');
  O_7_SEGMENT_2 <= (others => '1');
  O_7_SEGMENT_3 <= (others => '1');
  O_7_SEGMENT_4 <= (others => '1');
  O_7_SEGMENT_5 <= (others => '1');
  O_7_SEGMENT_6 <= (others => '1');
  O_7_SEGMENT_7 <= (others => '1');

  w_continous_write <= I_SLIDE_SWITCH(0);
  w_reset_n         <= I_BUTTON(0);
  O_VGA_CLOCK       <= w_clk_vga;
  O_DRAM_LDQM_1     <= w_dqml;
  O_DRAM_UDQM_1     <= w_dqmh;

  O_DRAM_LDQM_0 <= w_dqml;
  O_DRAM_UDQM_0 <= w_dqmh;

  O_DRAM_CLK <= w_clk_sdram;

  w_vga_blank_n <= I_SLIDE_SWITCH(1);

  w_right_camera_pixclk      <= I_GPIO_0;
  w_right_camera_out_raw(11) <= I_GPIO_1;
  -- 2 NC
  w_right_camera_out_raw(10) <= I_GPIO_3;
  w_right_camera_out_raw(9)  <= I_GPIO_4;
  w_right_camera_out_raw(8)  <= I_GPIO_5;
  w_right_camera_out_raw(7)  <= I_GPIO_6;
  w_right_camera_out_raw(6)  <= I_GPIO_7;
  w_right_camera_out_raw(5)  <= I_GPIO_8;
  w_right_camera_out_raw(4)  <= I_GPIO_9;
  w_right_camera_out_raw(3)  <= I_GPIO_10;
  w_right_camera_out_raw(2)  <= I_GPIO_11;
  w_right_camera_out_raw(1)  <= I_GPIO_12;
  w_right_camera_out_raw(0)  <= I_GPIO_13;
  -- 14 & 15 NC
  O_GPIO_16 <= w_clk_camera;
  O_GPIO_17 <= w_right_camera_reset_n;
  -- 18 NC
  O_GPIO_19            <= w_right_camera_trigger;
  w_right_camera_strobe <= I_GPIO_20;
  w_right_camera_lval   <= I_GPIO_21;
  w_right_camera_fval   <= I_GPIO_22;
-----------------------------------------------------------------------------
  w_left_camera_pixclk      <= I_HSMC_J3_0;
  w_left_camera_out_raw(11) <= I_HSMC_J3_1;
  -- 2 NC
  w_left_camera_out_raw(10) <= I_HSMC_J3_3;
  w_left_camera_out_raw(9)  <= I_HSMC_J3_4;
  w_left_camera_out_raw(8)  <= I_HSMC_J3_5;
  w_left_camera_out_raw(7)  <= I_HSMC_J3_6;
  w_left_camera_out_raw(6)  <= I_HSMC_J3_7;
  w_left_camera_out_raw(5)  <= I_HSMC_J3_8;
  w_left_camera_out_raw(4)  <= I_HSMC_J3_9;
  w_left_camera_out_raw(3)  <= I_HSMC_J3_10;
  w_left_camera_out_raw(2)  <= I_HSMC_J3_11;
  w_left_camera_out_raw(1)  <= I_HSMC_J3_12;
  w_left_camera_out_raw(0)  <= I_HSMC_J3_13;
  -- 14 & 15 NC
  O_HSMC_J3_16 <= w_clk_camera;
  O_HSMC_J3_17 <= w_left_camera_reset_n;
  -- 18 NC
  O_HSMC_J3_19          <= w_left_camera_trigger;
  w_left_camera_strobe <= I_HSMC_J3_20;
  w_left_camera_lval   <= I_HSMC_J3_21;
  w_left_camera_fval   <= I_HSMC_J3_22;

  w_take_picture <= I_BUTTON(3);
-- Rest NC

end architecture RTL;
