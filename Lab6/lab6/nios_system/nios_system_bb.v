
module nios_system (
	clk_clk,
	reset_reset_n,
	leds_export,
	keys_export);	

	input		clk_clk;
	input		reset_reset_n;
	output	[7:0]	leds_export;
	input	[3:0]	keys_export;
endmodule