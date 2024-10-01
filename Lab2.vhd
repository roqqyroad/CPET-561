LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Lab2 IS
  PORT 
  (	
    CLOCK_50 						: IN  std_logic;
	 --RESET_N 						: IN  std_logic; 
    SW      						: IN  std_logic_vector(7 DOWNTO 0);
    KEY     						: IN  std_logic_vector(3 DOWNTO 0);
    --
    HEX0     						: OUT std_logic_vector(6 DOWNTO 0)
   );
END ENTITY Lab2;

ARCHITECTURE arch OF Lab2 IS

	component nios_system is
		port (
			clk_clk            : in  std_logic                    := 'X';             -- clk
			reset_reset_n      : in  std_logic                    := 'X';             -- reset_n
			switches_export    : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			pushbuttons_export : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			hex0_export        : out std_logic_vector(6 downto 0)                     -- export
		);
	end component nios_system;

BEGIN
	-- You can copy this from the nios_system_inst.vhd that is created when you generate VHDL for it
  	u0 : component nios_system
		port map 
		(
			clk_clk            => CLOCK_50,            --         clk.clk
			reset_reset_n      => KEY(0),      			 --       reset.reset_n
			switches_export    => SW,    					 --    switches.export
			pushbuttons_export => KEY, 					 -- pushbuttons.export
			hex0_export        => HEX0         			 --        hex0.export
		);
END ARCHITECTURE arch;