
module pll (
	clk_clk,
	clk_camera_clk,
	clk_i2c_clk,
	clk_i2c_double_clk,
	clk_sdram_clk,
	clk_system_clk,
	clk_system_double_clk,
	clk_vga_clk,
	reset_reset_n);	

	input		clk_clk;
	output		clk_camera_clk;
	output		clk_i2c_clk;
	output		clk_i2c_double_clk;
	output		clk_sdram_clk;
	output		clk_system_clk;
	output		clk_system_double_clk;
	output		clk_vga_clk;
	input		reset_reset_n;
endmodule
