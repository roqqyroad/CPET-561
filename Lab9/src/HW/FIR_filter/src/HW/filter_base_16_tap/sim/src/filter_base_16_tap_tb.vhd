library ieee;
use STD.textio.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity filter_base_16_tap_tb is
end filter_base_16_tap_tb;

architecture arch of filter_base_16_tap_tb is
  
  TYPE cycle_array is array (39 DOWNTO 0) of std_logic_vector(15 downto 0);
  
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
  
  constant period         : time := 20 ns;
  signal clk              : std_logic := '0';
  signal reset            : std_logic := '1';
  signal filter_en        : std_logic := '0';
  signal filter_type      : std_logic_vector(1 downto 0):= "10";
  signal data_in          : std_logic_vector(15 downto 0) := (others =>'0');
  signal data_out         : std_logic_vector(15 downto 0);
  signal audioSampleArray : cycle_array;
begin

   uut : filter_base_16_tap
    generic map(
      bit_depth  => 16
    )
    port map(
      clk              => clk,                     -- 50 Mhz system clock
      reset            => reset, 
      filter_en        => filter_en,
      filter_type      => filter_type,
      data_in          => data_in,
      data_out         => data_out
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
--  file results_file : text open write_mode is "../src/bypass.csv";
--  file results_file : text open write_mode is "../src/mov_average.csv";
--  file results_file : text open write_mode is "../src/low_pass.csv";
    file results_file : text open write_mode is "../src/high_pass.csv";
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
    
    -- Apply the test data and put the result into an output file
    for i in 1 to 10 loop
      for j in 0 to 39 loop
        -- Your code here...
        -- Read the data from the array and apply it to Data_In
        -- Remember to provide an enable pulse with each new sample
        data_in <= audioSampleArray(j);
        filter_en <= '1';
        wait for period;
        
        -- Write filter output to file
        writeValue := to_integer(signed(data_out));
        write(lineOut, writeValue);
        writeline(results_file, lineOut);
        
        -- Your code here...
        filter_en <= '0';
        wait for period;
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