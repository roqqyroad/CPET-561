--*****************************************************************************
--*****************************************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY angle_counter IS
  GENERIC(
    bits             : integer := 32
    );
  PORT(
    clk              : IN  std_logic;                      -- 50 Mhz system clock
    reset_n          : IN  std_logic;                      -- active low system reset
    cntrl_pin        : IN  std_logic_vector(2 downto 0);
    min_count        : IN  std_logic_vector(bits-1 downto 0);
    max_count        : IN  std_logic_vector(bits-1 downto 0);
    angle_count      : OUT std_logic_vector(bits-1 downto 0)
    );
END ENTITY angle_counter;

ARCHITECTURE rtl OF angle_counter IS
  
  CONSTANT zero               : std_logic_vector(bits-1 downto 0):= (others => '0');
  SIGNAL   jmp2count          : std_logic_vector(bits-1 downto 0):= (others => '0');
  SIGNAL   angle_count_sig    : std_logic_vector(bits-1 downto 0):= (others => '0');
  SIGNAL   pwm_sig            : std_logic;
  
  ALIAS    cntrl_sig          : std_logic_vector(1 downto 0) IS cntrl_pin(1 DOWNTO 0);
  ALIAS    jmp2sel            : std_logic IS cntrl_pin(2);
  
  COMPONENT generic_counter IS
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
  END COMPONENT generic_counter;
  
BEGIN
  
  angle_count <= angle_count_sig;
  
  counter : generic_counter
    GENERIC MAP(
      bits             => 32
      )
    PORT MAP(    
      clk              => clk,
      reset_n          => reset_n,
      cntrl_pin        => cntrl_sig,
      jmp2count        => jmp2count,
      offset           => x"000001F4",
      count            => angle_count_sig
      );
  
  PROCESS(jmp2sel,min_count,max_count) 
  BEGIN
    CASE jmp2sel IS
      WHEN '0'    => jmp2count <=  min_count;
      WHEN OTHERS => jmp2count <=  max_count;
    END CASE;
  END PROCESS;
END ARCHITECTURE rtl;