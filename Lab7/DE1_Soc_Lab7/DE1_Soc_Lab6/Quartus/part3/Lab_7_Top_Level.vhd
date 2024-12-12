
--Lab_7 Top Level

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

Entity Lab_7_Top_level is
    port(
       CLOCK_50  : IN    std_logic;
       KEY       : IN    std_logic_vector(3 DOWNTO 0);
       LEDR      : OUT  std_logic_vector(9 downto 0)
       );
end entity Lab_7_Top_level;

architecture beh of Lab_7_Top_level is 

  signal reset_n : std_logic;
  signal key0_d1 : std_logic;
  signal key0_d2 : std_logic;
  signal key0_d3 : std_logic;
  signal key1_d1 : std_logic;
  signal key1_d2 : std_logic;
  signal key1_d3 : std_logic;

	component nios_system is
		port (
			clk_clk            : in  std_logic                    := 'X'; -- clk
			leds_export        : out std_logic_vector(7 downto 0);        -- export
			pushbuttons_export : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			reset_reset_n      : in  std_logic                    := 'X'  -- reset_n
		);
	end component nios_system;
    
 begin
  synchReset_proc : process (CLOCK_50) 
  begin
    if (rising_edge(CLOCK_50)) then
      key0_d1 <= KEY(0);
      key0_d2 <= key0_d1;
      key0_d3 <= key0_d2;
    end if;
  end process synchReset_proc;
  reset_n <= key0_d3;
  
  synchKey1_proc : process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      key1_d1 <= KEY(1);
      key1_d2 <= key1_d1;
      key1_d3 <= key1_d2;
    end if;
  end process synchKey1_proc;
  
 u0 : component nios_system
		port map (
			clk_clk       => CLOCK_50,       --   clk.clk
			reset_reset_n => reset_n,  -- reset.reset_n
			pushbuttons_export => "00" & key1_d3 & reset_n,
         leds_export => LEDR(7 downto  0)
		);
		end beh;