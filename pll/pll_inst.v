	pll u0 (
		.clk_clk               (<connected-to-clk_clk>),               //               clk.clk
		.clk_camera_clk        (<connected-to-clk_camera_clk>),        //        clk_camera.clk
		.clk_i2c_clk           (<connected-to-clk_i2c_clk>),           //           clk_i2c.clk
		.clk_i2c_double_clk    (<connected-to-clk_i2c_double_clk>),    //    clk_i2c_double.clk
		.clk_sdram_clk         (<connected-to-clk_sdram_clk>),         //         clk_sdram.clk
		.clk_system_clk        (<connected-to-clk_system_clk>),        //        clk_system.clk
		.clk_system_double_clk (<connected-to-clk_system_double_clk>), // clk_system_double.clk
		.clk_vga_clk           (<connected-to-clk_vga_clk>),           //           clk_vga.clk
		.reset_reset_n         (<connected-to-reset_reset_n>)          //             reset.reset_n
	);

