
library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY filter_base_16_tap IS
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
END ENTITY filter_base_16_tap;

ARCHITECTURE rtl OF filter_base_16_tap IS
  
  constant FIR_size         :integer := 16;
  
  TYPE filter_signal IS ARRAY (FIR_size DOWNTO 0) OF std_logic_vector(bit_depth-1 DOWNTO 0);
  TYPE MULT_signal IS ARRAY (FIR_size DOWNTO 0) OF std_logic_vector(2*bit_depth-1 DOWNTO 0);
 
  component generic_laterial_shift is
    generic (
      bits : integer := 8
    );
    port (
      clk             : in  std_logic; 
      reset           : in  std_logic;
      enable          : in  std_logic;
      preset          : in  std_logic_vector(bits-1 downto 0);
      shift_in        : in  std_logic_vector(bits-1 downto 0);
      shift_out       : out std_logic_vector(bits-1 downto 0)
    );
  end component;
  
  COMPONENT MULT IS
    PORT (
      dataa           : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      datab           : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      result          : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;
  
  signal preset       : std_logic_vector(bit_depth-1 DOWNTO 0):= (others => '0');
  signal register_q   : filter_signal := (others => x"0000");
  signal add_q        : filter_signal := (others => x"0000");
  signal multiplier_q : MULT_signal   := (others => x"00000000");
  signal coeff_q      : filter_signal;
  constant mov_avg    : filter_signal := (others => x"0788");
  constant low_pass   : filter_signal := (x"0051",x"00ba",x"01e1",x"0408",
                                          x"071a",x"0aac",x"0e11",x"107f",
                                          x"1161",x"107f",x"0e11",x"0aac",
                                          x"071a",x"0408",x"01e1",x"00ba",x"0051");
  constant high_pass  : filter_signal := (x"003e",x"ff9b",x"fe9f",x"0000",
                                          x"0535",x"05b2",x"f5ac",x"dab7",
                                          x"4c91",x"dab7",x"f5ac",x"05b2",
                                          x"0535",x"0000",x"fe9f",x"ff9b",x"003e");
  constant bypass     : filter_signal := (x"0000",x"0000",x"0000",x"0000",
                                          x"0000",x"0000",x"0000",x"0000",
                                          x"0000",x"0000",x"0000",x"0000",
                                          x"0000",x"0000",x"0000",x"0000",x"7fff");
BEGIN
  register_q(0) <= data_in;
  data_out <= add_q(16);
  add_q(0) <= multiplier_q(0)(30 downto 15);
  
  coeff_mux : process (filter_type,coeff_q) 
  begin 
    case(filter_type) is
      when "00"    => coeff_q <= bypass;
      when "01"    => coeff_q <= low_pass;
      when "10"    => coeff_q <= high_pass;
      when others  => coeff_q <= mov_avg;
    end case;
  end process;
  
  shifter : for i in 0 to FIR_size-1 generate
    shift : generic_laterial_shift
      generic map(
        bits => bit_depth
      )
      port map(
        clk         => clk,
        reset       => reset,
        enable      => filter_en,
        preset      => preset,
        shift_in    => register_q(i),
        shift_out   => register_q(i+1)
      );
  end generate;
  
  multiplier : for i in 0 to FIR_size generate
    multi : MULT
      port map(
        dataa    => coeff_q(i),
        datab    => register_q(i),
        result   => multiplier_q(i)
      );
  end generate;
  
  adder : for i in 0 to FIR_size-1 generate
    add_q(i+1) <= add_q(i) + multiplier_q(i+1)(30 downto 15);
  end generate;
  
END rtl;