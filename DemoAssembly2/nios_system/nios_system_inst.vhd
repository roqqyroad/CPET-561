	component nios_system is
		port (
			clk_clk                                   : in  std_logic                     := 'X';             -- clk
			reset_reset_n                             : in  std_logic                     := 'X';             -- reset_n
			leds_export                               : out std_logic_vector(7 downto 0);                     -- export
			switches_export                           : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			jtag_uart_0_avalon_jtag_slave_chipselect  : in  std_logic                     := 'X';             -- chipselect
			jtag_uart_0_avalon_jtag_slave_address     : in  std_logic                     := 'X';             -- address
			jtag_uart_0_avalon_jtag_slave_read_n      : in  std_logic                     := 'X';             -- read_n
			jtag_uart_0_avalon_jtag_slave_readdata    : out std_logic_vector(31 downto 0);                    -- readdata
			jtag_uart_0_avalon_jtag_slave_write_n     : in  std_logic                     := 'X';             -- write_n
			jtag_uart_0_avalon_jtag_slave_writedata   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			jtag_uart_0_avalon_jtag_slave_waitrequest : out std_logic                                         -- waitrequest
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk                                   => CONNECTED_TO_clk_clk,                                   --                           clk.clk
			reset_reset_n                             => CONNECTED_TO_reset_reset_n,                             --                         reset.reset_n
			leds_export                               => CONNECTED_TO_leds_export,                               --                          leds.export
			switches_export                           => CONNECTED_TO_switches_export,                           --                      switches.export
			jtag_uart_0_avalon_jtag_slave_chipselect  => CONNECTED_TO_jtag_uart_0_avalon_jtag_slave_chipselect,  -- jtag_uart_0_avalon_jtag_slave.chipselect
			jtag_uart_0_avalon_jtag_slave_address     => CONNECTED_TO_jtag_uart_0_avalon_jtag_slave_address,     --                              .address
			jtag_uart_0_avalon_jtag_slave_read_n      => CONNECTED_TO_jtag_uart_0_avalon_jtag_slave_read_n,      --                              .read_n
			jtag_uart_0_avalon_jtag_slave_readdata    => CONNECTED_TO_jtag_uart_0_avalon_jtag_slave_readdata,    --                              .readdata
			jtag_uart_0_avalon_jtag_slave_write_n     => CONNECTED_TO_jtag_uart_0_avalon_jtag_slave_write_n,     --                              .write_n
			jtag_uart_0_avalon_jtag_slave_writedata   => CONNECTED_TO_jtag_uart_0_avalon_jtag_slave_writedata,   --                              .writedata
			jtag_uart_0_avalon_jtag_slave_waitrequest => CONNECTED_TO_jtag_uart_0_avalon_jtag_slave_waitrequest  --                              .waitrequest
		);

