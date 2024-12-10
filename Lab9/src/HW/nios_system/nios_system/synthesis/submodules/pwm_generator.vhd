--*****************************************************************************
--*****************************************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY pwm_generator IS
  GENERIC(
    bits             : integer := 32
    );
  PORT(
    clk              : IN  std_logic;                      -- 50 Mhz system clock
    reset_n          : IN  std_logic;                      -- active low system reset
    enable           : IN  std_logic;
    pulse_period     : IN  std_logic_vector(bits-1 downto 0);
    pulse_width      : IN  std_logic_vector(bits-1 downto 0);
    pwm              : OUT std_logic;
    overflow         : OUT std_logic
    );
END ENTITY pwm_generator;

ARCHITECTURE rtl OF pwm_generator IS
  
  CONSTANT zero               : std_logic_vector(bits-1 downto 0):= (others => '0');
  SIGNAL   count_sig          : std_logic_vector(bits-1 downto 0):= (others => '0');
  SIGNAL   cntrl_sig          : std_logic_vector(1 downto 0);
  SIGNAl   overflow_sig       : std_logic;
  SIGNAL   overwidth          : std_logic;
  SIGNAL   pwm_sig            : std_logic;
  
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
  overflow <= overflow_sig;
  cntrl_sig <= overflow_sig & enable;
  pwm <= pwm_sig;
  
  counter: generic_counter
    GENERIC MAP(
      bits             => 32
    )
    PORT MAP(    
      clk              => clk,
      reset_n          => reset_n,
      cntrl_pin        => cntrl_sig,
      jmp2count        => zero,
      offset           => x"00000001",
      count            => count_sig
    );
  
  overflow_check: PROCESS(reset_n,count_sig,pulse_period)
  BEGIN
    IF(reset_n = '0') THEN
      overflow_sig  <= '0';
    ELSIF(count_sig = pulse_period) THEN
      overflow_sig  <= '1';
    ELSE 
      overflow_sig <= '0';
    END IF;
  END PROCESS;
  
  overwidth_check :PROCESS(reset_n,count_sig,pulse_width)
  BEGIN
    IF(reset_n = '0') THEN
      overwidth   <= '0';
    ELSIF(count_sig = pulse_width) THEN
      overwidth  <= '1';
    ELSE 
      overwidth  <= '0';
    END IF;
  END PROCESS;
  
  pwm_logic :PROCESS(reset_n,clk,overflow_sig,overwidth)
  BEGIN
    IF(reset_n = '0') THEN
      pwm_sig <= '0';
    ELSIF(RISING_EDGE(CLK)) THEN
      IF(overflow_sig   = '1') THEN
        pwm_sig  <=  '1';
      ELSIF(overwidth  = '1') THEN
        pwm_sig  <=  '0';
      ELSE 
        pwm_sig <= pwm_sig;
      END IF;
    END IF;
  END PROCESS;
  
END ARCHITECTURE rtl;