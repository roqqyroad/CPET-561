LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY lab7_top IS
  PORT(
    CLOCK_50          : IN      std_logic;                      -- 50 Mhz system clock
    KEY               : IN      std_logic_vector( 3 downto 0); 
    LEDR              : OUT     std_logic_vector( 9 downto 0) 
    );
END ENTITY lab7_top;

ARCHITECTURE arc OF lab7_top IS

  component nios_system is
    port (
      clk_clk           : IN      std_logic                       := 'X';            
      key_0_export      : IN      std_logic_vector(3 downto 0)    := (others => 'X'); 
      led_0_export      : OUT     std_logic_vector(7 downto 0);                    
      reset_reset_n     : IN      std_logic                       := 'X'              
    );
  end component nios_system;
  
  component synchronizer is
    generic (
        bits    : integer := 4
      );
    port (
      clk               : IN  std_logic;
      reset             : IN  std_logic;
      reset_value       : IN  std_logic_vector (bits-1 downto 0);
      async_in          : IN  std_logic_vector (bits-1 downto 0);
      sync_out          : OUT std_logic_vector (bits-1 downto 0)
    );
  end component synchronizer;
  
  signal cntr           : std_logic_vector(25 downto 0); --counter signals
  signal KEY_sync       : std_logic_vector( 3 downto 0); --sync up key signals

BEGIN

  counter_proc : process (CLOCK_50) begin
    if (KEY_sync(0) = '0') then
      cntr <= "00" & x"000000";
    elsif (rising_edge(CLOCK_50)) then
      cntr <= cntr + ("00" & x"000001");
    end if;
  end process counter_proc;

  LEDR(9) <= cntr(25);

    
  KEY_synchronizer : synchronizer
    generic map(
      bits => 4
    )
    port map(
      clk               => CLOCK_50,
      reset             => KEY_sync(0),
      reset_value       => x"F",
      async_in          => KEY,
      sync_out          => KEY_sync
    );
  
  nios_processor : component nios_system
    port map (
      clk_clk       => CLOCK_50,          
      key_0_export  => KEY_sync,          
      led_0_export  => LEDR(7 downto 0),  
      reset_reset_n => KEY_sync(0)        
      );

END ARCHITECTURE arc;