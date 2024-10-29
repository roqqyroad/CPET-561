
module nios_system (
	clk_clk,
	reset_reset_n,
	switches_export,
	pushbuttons_export,
	hex0_export,
	hex1_export,
	hex2_export,
	hex3_export,
	hex4_export);	

	input		clk_clk;
	input		reset_reset_n;
	input	[7:0]	switches_export;
	input	[3:0]	pushbuttons_export;
	output	[6:0]	hex0_export;
	output	[6:0]	hex1_export;
	output	[6:0]	hex2_export;
	output	[6:0]	hex3_export;
	output	[6:0]	hex4_export;
endmodule
