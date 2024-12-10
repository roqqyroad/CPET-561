
library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY FIR_filter IS
  PORT(
    clk             : IN  std_logic;                      -- 50 Mhz system clock
    reset            : IN  std_logic; 
    write            : IN  std_logic;
    address          : IN  std_logic_vector(0 downto 0);
    writedata        : IN  std_logic_vector(15 downto 0);
    readdata         : OUT std_logic_vector(15 downto 0)
  );
END ENTITY FIR_filter;

ARCHITECTURE rtl OF FIR_filter IS
  TYPE registers is array (1 DOWNTO 0) of std_logic_vector(15 downto 0);
  
  COMPONENT filter_base_16_tap IS
    GENERIC(
      bit_depth        :integer := 16
    );
    PORT(
      clk              : IN  std_logic;                      -- 50 Mhz system clock
      reset            : IN  std_logic; 
      filter_en        : IN  std_logic;
      filter_type      : IN  std_logic_vector(1 downto 0);
      data_in          : IN  std_logic_vector(bit_depth-1 downto 0);
      data_out         : OUT std_logic_vector(bit_depth-1 downto 0)
    );
  END COMPONENT filter_base_16_tap;
  
  signal memory        : registers := (others => x"0000");
  signal enable        : std_logic;
BEGIN

  reg_process : process (clk,reset)
  begin
    if (reset = '1') then
      memory <= (others => x"0000");
    elsif (rising_edge(clk))then
      if (write = '1') then
        memory(to_integer(unsigned(address))) <= writedata;
      end if;
    end if;
  end process;

  en_process : process (address,write)
  begin
    case (address) is 
      when "0"    => enable <= write;
      when others => enable <= '0';
    end case;
  end process;

  filter : filter_base_16_tap
    generic map(
      bit_depth  => 16
    )
    port map(
      clk              => clk,                     -- 50 Mhz system clock
      reset            => reset, 
      filter_en        => enable,
      filter_type      => memory(1)(1 downto 0),
      data_in          => memory(0),
      data_out         => readdata
    );
  
END rtl;