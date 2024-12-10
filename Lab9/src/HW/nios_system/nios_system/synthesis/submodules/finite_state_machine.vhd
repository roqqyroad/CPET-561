--*****************************************************************************
--*****************************************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY finite_state_machine IS
  GENERIC(
    bits             : integer := 32
    );
  PORT(
    clk              : IN  std_logic;                      -- 50 Mhz system clock
    reset_n          : IN  std_logic;                      -- active low system reset
    write            : IN  std_logic;
    overflow         : IN  std_logic;
    angle_count      : IN  std_logic_vector(bits-1 downto 0);
    max_count        : IN  std_logic_vector(bits-1 downto 0);
    min_count        : IN  std_logic_vector(bits-1 downto 0);
    angle_cntrl      : OUT std_logic_vector(2 downto 0);
    pwm_enable       : OUT std_logic;
    irq              : OUT std_logic
  );
END ENTITY finite_state_machine;

ARCHITECTURE rtl OF finite_state_machine IS
  CONSTANT STATE                : integer := 5;
  CONSTANT IDLE                 : std_logic_vector(STATE-1 DOWNTO 0) := "00001";
  CONSTANT SWEEP_RIGHT          : std_logic_vector(STATE-1 DOWNTO 0) := "00010";
  CONSTANT INT_RIGHT            : std_logic_vector(STATE-1 DOWNTO 0) := "00100";
  CONSTANT SWEEP_LEFT           : std_logic_vector(STATE-1 DOWNTO 0) := "01000";
  CONSTANT INT_LEFT             : std_logic_vector(STATE-1 DOWNTO 0) := "10000";

  SIGNAL current_states         : std_logic_vector(STATE-1 DOWNTO 0) := IDLE;
  SIGNAL next_states            : std_logic_vector(STATE-1 DOWNTO 0) := IDLE;
  
  ALIAS idle_bit                : std_logic is current_states(0);
  ALIAS sweep_right_bit         : std_logic is current_states(1);
  ALIAS int_right_bit           : std_logic is current_states(2);
  ALIAS sweep_left_bit          : std_logic is current_states(3);
  ALIAS int_left_bit            : std_logic is current_states(4);
BEGIN
  pwm_enable   <= not idle_bit;
  irq          <= int_right_bit or int_left_bit;
  
  state_register:PROCESS(reset_n ,clk)
  BEGIN
    IF (reset_n = '0') THEN 
      current_states <= IDLE;
    ELSIF(RISING_EDGE(CLK))THEN
      current_states <= next_states;
    END IF;
  END PROCESS;
  
  
  next_register:PROCESS(current_states,angle_count,max_count,min_count,write,overflow)
  BEGIN
    CASE(current_states)IS
      WHEN IDLE        => next_states <= SWEEP_RIGHT;
      WHEN SWEEP_RIGHT =>  
        IF(overflow = '0') THEN
          next_states  <= current_states;
        ELSIF((angle_count >=  max_count)) THEN
          next_states  <= INT_RIGHT;
        ELSE 
          next_states  <= current_states;
        END IF;
      WHEN INT_RIGHT   => 
        IF (write = '1') THEN 
          next_states    <= SWEEP_LEFT;
        ELSE
          next_states    <= current_states;
        END IF;
      WHEN SWEEP_LEFT  => 
        IF(overflow = '0') THEN
          next_states  <= current_states;
        ELSIF((angle_count <=  min_count)) THEN
          next_states  <= INT_LEFT;
        ELSE 
          next_states  <= current_states;
        END IF;
      WHEN INT_LEFT    => 
        IF (write = '1') THEN 
          next_states    <= SWEEP_RIGHT;
        ELSE
          next_states    <= current_states;
        END IF;
      WHEN OTHERS      => next_states <= IDLE;
    END CASE;
  END PROCESS;
  
  PROCESS(current_states,overflow)
  BEGIN
    CASE(current_states) IS
      WHEN SWEEP_RIGHT => 
        IF(overflow = '1') THEN
          angle_cntrl <= "001";
        ELSE 
          angle_cntrl <= "000";
        END IF;
      WHEN INT_RIGHT   => angle_cntrl <= "111";
      WHEN SWEEP_LEFT  => 
        IF(overflow = '1') THEN
          angle_cntrl <= "010";
        ELSE 
          angle_cntrl <= "000";
        END IF;
      WHEN INT_LEFT    => angle_cntrl <= "011";
      WHEN OTHERS      => angle_cntrl <= "011";
    END CASE;
  END PROCESS;

END ARCHITECTURE rtl;