	component nios_system is
		port (
			clk_clk            : in  std_logic                    := 'X';             -- clk
			reset_reset_n      : in  std_logic                    := 'X';             -- reset_n
			switches_export    : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			pushbuttons_export : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			hex0_export        : out std_logic_vector(6 downto 0);                    -- export
			hex1_export        : out std_logic_vector(6 downto 0);                    -- export
			hex2_export        : out std_logic_vector(6 downto 0);                    -- export
			hex3_export        : out std_logic_vector(6 downto 0);                    -- export
			hex4_export        : out std_logic_vector(6 downto 0)                     -- export
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk            => CONNECTED_TO_clk_clk,            --         clk.clk
			reset_reset_n      => CONNECTED_TO_reset_reset_n,      --       reset.reset_n
			switches_export    => CONNECTED_TO_switches_export,    --    switches.export
			pushbuttons_export => CONNECTED_TO_pushbuttons_export, -- pushbuttons.export
			hex0_export        => CONNECTED_TO_hex0_export,        --        hex0.export
			hex1_export        => CONNECTED_TO_hex1_export,        --        hex1.export
			hex2_export        => CONNECTED_TO_hex2_export,        --        hex2.export
			hex3_export        => CONNECTED_TO_hex3_export,        --        hex3.export
			hex4_export        => CONNECTED_TO_hex4_export         --        hex4.export
		);

