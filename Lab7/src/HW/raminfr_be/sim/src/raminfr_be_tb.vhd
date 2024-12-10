library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity raminfr_be_tb is
end raminfr_be_tb; --entity is needed to make run

architecture arch of raminfr_be_tb is
  
  COMPONENT raminfr_be IS
    PORT(
      clk                 : IN  std_logic;
      reset_n             : IN  std_logic;
      writebyteenable_n   : IN  std_logic_vector(3 DOWNTO 0);
      address             : IN  std_logic_vector(11 DOWNTO 0);
      writedata           : IN  std_logic_vector(31 DOWNTO 0);
      --output
      readdata            : OUT std_logic_vector(31 DOWNTO 0)
    );
  END COMPONENT raminfr_be;

  constant period         : time := 20ns;
  SIGNAL   clk                 :std_logic := '0';
  SIGNAL   reset_n             :std_logic := '0';
  SIGNAL   writebyteenable_n   :std_logic_vector(3 DOWNTO 0) := "1111";
  SIGNAL   writedata           :std_logic_vector(31 DOWNTO 0):= (others => '0');
  SIGNAL   readdata            :std_logic_vector(31 DOWNTO 0);
  SIGNAL   address             :std_logic_vector(11 DOWNTO 0):= (others => '0');
  SIGNAL   flag                :std_logic_vector( 2 DOWNTO 0):= (others => '0');
  SIGNAL   DONE                :std_logic := '0';
  
  TYPE write_enable_type IS ARRAY (3 DOWNTO 0) OF std_logic_vector ( 3 DOWNTO 0);
  TYPE test_words_type   IS ARRAY (3 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);
  
  constant uint32_test_words  :test_words_type := (x"00000000",x"00000000",x"00000000",x"ABCDEF90");
  constant uint16_test_words  :test_words_type := (x"00000000",x"00000000",x"12340000",x"00001234");
  constant uint08_test_words  :test_words_type := (x"00000000",x"00000000",x"00000000",x"00000000");
  
  constant uint32_check       :test_words_type := (x"00000000",x"00000000",x"00000000",x"ABCDEF90");
  constant uint16_check       :test_words_type := (x"00000000",x"00000000",x"12341234",x"ABCD1234");
  constant uint08_check       :test_words_type := (x"00000000",x"12000000",x"12340000",x"12341200");
  
  constant write_disable        :std_logic_vector( 3 DOWNTO 0) := "1111";
  constant uint32_write_enable  :write_enable_type := ("1111","1111","1111","0000");
  constant uint16_write_enable  :write_enable_type := ("1111","1111","0011","1100");
  constant uint08_write_enable  :write_enable_type := ("0111","1011","1101","1110");

begin
  
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
      reset_n <= '1';
      wait;
  end process; 
  
  stimulus: process
    variable check                  : std_logic_vector (31 DOWNTO 0) := (others =>'0');
    begin
    wait for 2 * period;
    for i in 0 to 4096 loop
      for j in 0 to 0 loop
        address <= std_logic_vector(to_unsigned(i,12));
        writebyteenable_n  <= uint32_write_enable(j);
        writedata          <= uint32_test_words(j);
        wait for period;
        check := readdata;
        if(not(uint32_check(j) = check))THEN
          flag(0) <= '1';
          report "Ram test failure" & CR &
                 "Expected : " &  to_hstring(uint32_check(j)) & CR &
                 "Actual   : " &  to_hstring(check) & CR;
        end if; 
        DONE <= '0';
      end loop;
    end loop;
    DONE <= '1';
    
    for i in 0 to 4095 loop
      for j in 0 to 1 loop
        address <= std_logic_vector(to_unsigned(i,12));
        writebyteenable_n  <= uint16_write_enable(j);
        writedata          <= uint16_test_words(j);
        wait for period;
        check := readdata;
        if(not(check = uint16_check(j)))THEN
          flag(1) <= '1';
          report "Ram test failure" & CR &
                 "Expected : " &  to_hstring(uint16_check(j)) & CR &
                 "Actual   : " &  to_hstring(check) & CR;
        end if;
        DONE <= '0';
      end loop;
    end loop;
    DONE <= '1';
    
    for i in 0 to 4095 loop
      for j in 0 to 3 loop
        address <= std_logic_vector(to_unsigned(i,12));
        writebyteenable_n  <= uint08_write_enable(j);
        writedata          <= uint08_test_words(j);
        wait for period;
        check := readdata;
        if(not(check = uint08_check(j)))THEN
          flag(2) <= '1';
          report "Ram test failure" & CR &
                 "Expected : " &  to_hstring(uint08_check(j)) & CR &
                 "Actual   : " &  to_hstring(check) & CR;
        end if;
        DONE <= '0';
      end loop;
    end loop;
    DONE <= '1';
    
    IF(flag(0) <= '0') THEN
      report "32bit RAM test passed" & CR;
    ELSE
      report "32bit RAM test failed" & CR;
    END IF;
    
    IF(flag(1) <= '0') THEN
      report "16bit RAM test passed" & CR;
    ELSE
      report "16bit RAM test failed" & CR;
    END IF;
    
    IF(flag(2) <= '0') THEN
      report "8bit RAM test passed" & CR;
    ELSE
      report "8bit RAM test failed" & CR;
    END IF;
    wait;
  end process;
  
  uut: raminfr_be
    port map(    
      clk              => clk,
      reset_n          => reset_n,
      writebyteenable_n=> writebyteenable_n,
      address          => address,
      writedata        => writedata,
      readdata         => readdata
    );
end arch;