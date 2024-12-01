LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY lab6_top IS
  PORT(
    CLOCK_50         : IN  std_logic;                      -- 50 Mhz system clock
    KEY              : IN  std_logic_vector( 3 downto 0); 
    LEDS             : OUT std_logic_vector( 9 downto 0) 
    );
END ENTITY lab6_top;

ARCHITECTURE arch OF lab6_top IS

  component nios_system is
    port (
      clk_clk       : in  std_logic                    := 'X';             -- clk
      key_0_export  : in  std_logic_vector(3 downto 0) := (others => 'X'); -- key pbs
      led_0_export  : out std_logic_vector(7 downto 0);                    -- leds
      reset_reset_n : in  std_logic                    := 'X'              -- reset_n
    );
  end component nios_system;
  
  component synchronizer is
    generic (
        bits    : integer := 4
      );
    port (
      clk               : in  std_logic;
      reset             : in  std_logic;
      reset_value       : in  std_logic_vector (bits-1 downto 0);
      async_in          : in  std_logic_vector (bits-1 downto 0);
      sync_out          : out std_logic_vector (bits-1 downto 0)
    );
  end component synchronizer;
  
  signal ctr           : std_logic_vector(25 downto 0);
  signal KEY_sync       : std_logic_vector( 3 downto 0);
BEGIN

  
  counter_proc : process (CLOCK_50) begin
    if (KEY_sync(0) = '0') then
      ctr <= "00" & x"000000";
    elsif (rising_edge(CLOCK_50)) then
      ctr <= ctr + ("00" & x"000001");
    end if;
  end process counter_proc;
  LEDS(9) <= ctr(25);

    
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
      clk_clk       => CLOCK_50,          --   clk gets clock
      key_0_export  => KEY_sync,          -- key_0 for pb 0
      led_0_export  => LEDS(7 downto 0),  
      reset_reset_n => KEY_sync(0)        -- reset for reset_n
      );

END ARCHITECTURE arch;