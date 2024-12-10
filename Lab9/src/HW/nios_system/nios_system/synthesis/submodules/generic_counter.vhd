--*****************************************************************************
--*****************************************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY generic_counter IS
  GENERIC(
    bits             : integer := 32
    );
  PORT(
    clk              : IN  std_logic;                      -- 50 Mhz system clock
    reset_n          : IN  std_logic;                      -- active low system reset
    cntrl_pin        : IN  std_logic_vector(1 downto 0);
    jmp2count        : IN  std_logic_vector(bits-1 downto 0);
    offset           : IN  std_logic_vector(bits-1 downto 0);
    count            : OUT std_logic_vector(bits-1 downto 0)
    );
END ENTITY generic_counter;

ARCHITECTURE rtl OF generic_counter IS
  SIGNAL count_sig          : std_logic_vector(bits-1 downto 0):= (others => '0');
  SIGNAL next_count         : std_logic_vector(bits-1 downto 0):= (others => '0');
  SIGNAL plus_one           : std_logic_vector(bits   downto 0):= (others => '0');
  SIGNAL minus_one          : std_logic_vector(bits   downto 0):= (others => '0');

BEGIN
  plus_one  <= std_logic_vector(unsigned('0' & count_sig) + unsigned('0' & offset));
  minus_one <= std_logic_vector(unsigned('0' & count_sig) - unsigned('0' & offset));
  count     <= count_sig;
  
  count_reg : PROCESS(clk,reset_n,count_sig)
  BEGIN
    IF(reset_n = '0') THEN
      count_sig <= (others => '0');
    ELSIF(RISING_EDGE(CLK)) THEN
      count_sig <= next_count;
    END IF;
  END PROCESS;
  
  next_count_mux : PROCESS(cntrl_pin,plus_one,minus_one,jmp2count,count_sig)
  BEGIN
    CASE cntrl_pin IS
      WHEN "00"   => next_count <= count_sig;
      WHEN "01"   => next_count <= plus_one (bits-1 DOWNTO 0);
      WHEN "10"   => next_count <= minus_one(bits-1 DOWNTO 0);
      WHEN OTHERS => next_count <= jmp2count;
    END CASE;
  END PROCESS;
  
END ARCHITECTURE rtl;