LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY labsix IS
  PORT(
    CLOCK_50         : IN  std_logic;                      -- 50 Mhz system clock
    KEY              : IN  std_logic_vector( 3 downto 0); 
    LEDR             : OUT std_logic_vector( 9 downto 0) 
    );
END ENTITY labsix;

ARCHITECTURE arch OF labsix IS

  --COMPONENTS
  component nios_system is
    port (
      clk_clk       : in  std_logic                    := 'X';             -- clk
      keys_export  : in  std_logic_vector(3 downto 0) := (others => 'X'); -- key pbs
      leds_export  : out std_logic_vector(7 downto 0);                    -- leds
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
  --END OF COMPONENTS

  signal ctr           : std_logic_vector(25 downto 0); --counter signal
BEGIN

  
  counter_proc : process (CLOCK_50) begin
    if (KEY(0) = '0') then --if key 0 is 0 then 
      ctr <= "00" & x"000000"; --reset the counter
    elsif (rising_edge(CLOCK_50)) then --if we have a rising edge
      ctr <= ctr + ("00" & x"000001"); --and with one!
    end if;
  end process counter_proc;
  LEDR(9) <= ctr(25); --led add one to toggle on or off

  nios_processor : component nios_system
    port map (
      clk_clk       => CLOCK_50,          --   clk gets clock
      keys_export  => KEY_sync,          -- key 0 for pb 0
      leds_export  => LEDR(7 downto 0),  --leds for leds
      reset_reset_n => KEY(0)        -- reset for reset_n
      );

END ARCHITECTURE arch;