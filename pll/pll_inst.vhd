	component pll is
		port (
			clk_clk               : in  std_logic := 'X'; -- clk
			clk_camera_clk        : out std_logic;        -- clk
			clk_i2c_clk           : out std_logic;        -- clk
			clk_i2c_double_clk    : out std_logic;        -- clk
			clk_sdram_clk         : out std_logic;        -- clk
			clk_system_clk        : out std_logic;        -- clk
			clk_system_double_clk : out std_logic;        -- clk
			clk_vga_clk           : out std_logic;        -- clk
			reset_reset_n         : in  std_logic := 'X'  -- reset_n
		);
	end component pll;

	u0 : component pll
		port map (
			clk_clk               => CONNECTED_TO_clk_clk,               --               clk.clk
			clk_camera_clk        => CONNECTED_TO_clk_camera_clk,        --        clk_camera.clk
			clk_i2c_clk           => CONNECTED_TO_clk_i2c_clk,           --           clk_i2c.clk
			clk_i2c_double_clk    => CONNECTED_TO_clk_i2c_double_clk,    --    clk_i2c_double.clk
			clk_sdram_clk         => CONNECTED_TO_clk_sdram_clk,         --         clk_sdram.clk
			clk_system_clk        => CONNECTED_TO_clk_system_clk,        --        clk_system.clk
			clk_system_double_clk => CONNECTED_TO_clk_system_double_clk, -- clk_system_double.clk
			clk_vga_clk           => CONNECTED_TO_clk_vga_clk,           --           clk_vga.clk
			reset_reset_n         => CONNECTED_TO_reset_reset_n          --             reset.reset_n
		);

