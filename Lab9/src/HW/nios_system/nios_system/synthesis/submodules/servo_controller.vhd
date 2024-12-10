--*****************************************************************************
--*****************************************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY servo_controller IS
  PORT(
    clk              : IN  std_logic;                      -- 50 Mhz system clock
    reset_n          : IN  std_logic;                      -- active low system reset
    write            : IN  std_logic;                      -- active high write enable
    address          : IN  std_logic_vector(0 DOWNTO 0);   -- address of register to be written to (from CPU)
    writedata        : IN  std_logic_vector(31 DOWNTO 0);   -- data from the CPU to be stored in the component
    irq              : OUT std_logic;
    pwm              : OUT std_logic
    );
END ENTITY servo_controller;

ARCHITECTURE rtl OF servo_controller IS
  COMPONENT read_only_ram IS
    GENERIC(
      bits             : integer := 2
      );
    PORT(
      clk              : IN  std_logic;                           -- 50 Mhz system clock
      reset_n          : IN  std_logic;                           -- active low system reset
      write            : IN  std_logic;                           -- active high write enable
      address          : IN  std_logic_vector(bits-1 DOWNTO 0);   -- address of register to be written to (from CPU)
      writedata        : IN  std_logic_vector(31 DOWNTO 0);       -- data from the CPU to be stored in the component
      max_out          : OUT std_logic_vector(31 DOWNTO 0);
      min_out          : OUT std_logic_vector(31 DOWNTO 0)
      );
  END COMPONENT;
  
  COMPONENT finite_state_machine IS
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
  END COMPONENT finite_state_machine;
  
  COMPONENT pwm_generator IS
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
  END COMPONENT pwm_generator;
  
  COMPONENT angle_counter IS
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
  END COMPONENT angle_counter;
  
  CONSTANT bits           : integer := 1;
  CONSTANT register_width : integer := 32;
  CONSTANT pluse_period   : std_logic_vector(register_width-1 downto 0) := x"000F4240";
  SIGNAL   pluse_width    : std_logic_vector(register_width-1 downto 0);
  SIGNAL   max_count      : std_logic_vector(register_width-1 downto 0);
  SIGNAL   min_count      : std_logic_vector(register_width-1 downto 0);
  SIGNAL   angle_count    : std_logic_vector(register_width-1 downto 0);
  SIGNAL   angle_cntrl    : std_logic_vector(2 downto 0);
  SIGNAL   overflow       : std_logic;
  SIGNAL   pwm_enable     : std_logic;

BEGIN
  pluse_width <= angle_count;
  
  ram : read_only_ram
    GENERIC MAP(
      bits             => bits
    )
    PORT MAP(    
      clk              => clk,
      reset_n          => reset_n,
      write            => write,
      address          => address,
      writedata        => writedata,
      max_out          => max_count,
      min_out          => min_count
    );
  
  fsm : finite_state_machine
    PORT MAP(    
      clk              => clk,
      reset_n          => reset_n,
      write            => write,
      overflow         => overflow,
      angle_count      => angle_count,
      max_count        => max_count,
      min_count        => min_count,
      angle_cntrl      => angle_cntrl,
      pwm_enable       => pwm_enable,
      irq              => irq
    );
  
  period_cnt: pwm_generator
    GENERIC MAP(
      bits             => register_width
    )
    PORT MAP(    
      clk              => clk,
      reset_n          => reset_n,
      enable           => pwm_enable,
      pulse_period     => pluse_period,
      pulse_width      => pluse_width,
      overflow         => overflow,
      pwm              => pwm
    );
    
  
  angle_cnt: angle_counter
    GENERIC MAP(
      bits             => register_width
    )
    PORT MAP(    
      clk              => clk,
      reset_n          => reset_n,
      cntrl_pin        => angle_cntrl,
      min_count        => min_count,
      max_count        => max_count,
      angle_count      => angle_count
    );
END ARCHITECTURE rtl;