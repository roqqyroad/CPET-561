--*****************************************************************************
--*****************************************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY read_only_ram IS
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
END ENTITY read_only_ram;

ARCHITECTURE rtl OF read_only_ram IS
  -- ram_type is a 2-dimensional array or inferred ram.  
  -- It stores eight 32-bit values
  TYPE ram_type IS ARRAY ((2**bits)-1 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);
  SIGNAL Registers : ram_type;          --instance of ram_type
  ALIAS  max_value : std_logic_vector(31 DOWNTO 0)is Registers(1);
  ALIAS  min_value : std_logic_vector(31 DOWNTO 0)is Registers(0);
BEGIN
  max_out <= max_value;
  min_out <= min_value;
  --this process loads data from the CPU. The CPU provides the address, 
  --the data and the write enable signal
  PROCESS(clk, reset_n)
  BEGIN
    IF (reset_n = '0') THEN
      max_value <= x"000186A0";
      min_value <= x"0000C350";
    ELSIF (clk'event AND clk = '1') THEN
      IF (write = '1') THEN
        Registers(to_integer(unsigned(address))) <= writedata;
        --when write enable is active, the ram location at the given address
        --is loaded with the input data
      END IF;
    END IF;
  END PROCESS; 
END ARCHITECTURE rtl;