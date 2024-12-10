library ieee;
use STD.textio.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Lab8_tb is
end Lab8_tb;

architecture arch of Lab8_tb is
  
  TYPE cycle_array is array (39 DOWNTO 0) of std_logic_vector(15 downto 0);
  TYPE registers is array (3 DOWNTO 0) of std_logic_vector(15 downto 0);
  
  COMPONENT lab8_top IS
    PORT(
      clk              : IN  std_logic;                      -- 50 Mhz system clock
      reset            : IN  std_logic; 
      write            : IN  std_logic;
      address          : IN  std_logic_vector(0 downto 0);
      writedata        : IN  std_logic_vector(15 downto 0);
      readdata         : OUT std_logic_vector(15 downto 0)
    );
  END COMPONENT lab8_top;
  
  constant period         : time := 20 ns;
  signal clk              : std_logic := '0';
  signal reset            : std_logic := '1';
  signal write_s          : std_logic := '0';
  signal address          : std_logic_vector(0 downto 0):= "0";
  signal writedata        : std_logic_vector(15 downto 0) := (others =>'0');
  signal readdata         : std_logic_vector(15 downto 0);
  signal audioSampleArray : cycle_array := (others => x"0000");
  signal mode             : registers := (x"0003",x"0002",x"0001",x"0000");
begin

  uut : lab8_top
    port map(
      clk              => clk,                     -- 50 Mhz system clock
      reset            => reset, 
      write            => write_s,
      address          => address,
      writedata        => writedata,
      readdata         => readdata
    );

  -- clock process
  clock: process
    begin
      clk <= not clk;
      wait for period/2;
  end process; 
  
  -- reset process
  async_reset: process
    begin
      wait for 2 * period;
      reset <= '0';
      wait;
  end process; 
  
  -- main test process
  
  stimulus : process is 
    file read_file : text open read_mode is "../src/one_cycle_200_8k.csv";
    file results_file : text open write_mode is "../src/component_design.csv";
    variable lineIn : line;
    variable lineOut : line;
    variable readValue : integer;
    variable writeValue : integer;
  begin
    report "--------------------------STARTED-------------------------------";
    wait for 6 * period;
    -- Read data from file into an array
    for i in 0 to 39 loop
      readline(read_file, lineIn);
      read(lineIn, readValue);
      audioSampleArray(i) <= std_logic_vector(to_signed(readValue, 16));
      wait for 3 * period;
    end loop;
    file_close(read_file);
    for k in 0 to 3 loop
      address <= "1";
      writedata <= mode(k);
      write_s <= '1';
      wait for period;
      write_s <= '0';
      address <= "0";
      -- Apply the test data and put the result into an output file
      for i in 1 to 10 loop
        for j in 0 to 39 loop
          -- Your code here...
          -- Read the data from the array and apply it to Data_In
          -- Remember to provide an enable pulse with each new sample
          writedata <= audioSampleArray(j);
          write_s <= '1';
          wait for period;
          
          -- Write filter output to file
          writeValue := to_integer(signed(readdata));
          write(lineOut, writeValue);
          writeline(results_file, lineOut);
          
          -- Your code here...
          write_s <= '0';
          wait for period;
        end loop;
      end loop;
    end loop;
    file_close(results_file);
    -- end simulation
    wait for 100 ns;
    report "--------------------------ENDED---------------------------------";
    -- last wait statement needs to be here to prevent the process
    -- sequence from restarting at the beginning
    wait;
  end process stimulus;
end arch;