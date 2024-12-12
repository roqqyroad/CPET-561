
-- raminfr_be_tb
-------------------------------------------------------------------------------
library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity raminfr_be_tb is
end entity;

architecture beh of raminfr_be_tb is 

component raminfr_be is
    PORT(
        clk                 : in std_logic;
        reset_n             : in std_logic;
        writebyteenable_n   : IN std_logic_vector(3 DOWNTO 0);
        address             : in std_logic_vector(11 downto 0);
        writedata           : in std_logic_vector(31 downto 0);
---------------------------------------------------------
        readdata            : out std_logic_vector(31 downto 0)
        );
end component raminfr_be;
----------------------------------------------------------------------------------------
--signals 
signal period                  : time := 20 ns;   
signal clk_tb        	       : std_logic := '0';
signal reset    	           : std_logic := '0';
signal complete                : BOOLEAN := FALSE;
signal writedata_tb            : std_logic_vector(31 downto 0);  
signal writebyteenable_n_tb    :std_logic_vector(3 downto 0)  := "0000";  
signal address_tb	           : std_logic_vector(11 downto 0):= "000000000000";
signal readdata_tb             : std_logic_vector(31 DOWNTO 0);
signal checkdata               : std_logic_vector(31 DOWNTO 0);
----------------------------------------------------------------------------------------

begin
----------------------------------------------------------------------------------------
uut:raminfr_be
port map(
	clk                  =>clk_tb,
    reset_n              =>reset,
    writebyteenable_n    =>writebyteenable_n_tb,
    writedata            =>writedata_tb,
    address              =>address_tb,
    ----------------------
	 readdata             => readdata_tb
	 );
--------------------------------------------------------------------------------------
clk_tb <= not clk_tb after period/2;
testing : process 
begin 
   report "testbench start";
    writedata_tb         <= x"12345678";
    checkdata            <= x"12345678";
   reset <= '1';
   wait for 10 ns; 
 for i in 0 to 6 loop
     case(i) is 
----------------------------------------------------------------------------------
       when 0 =>  -- Full Word test
      for j in 0 to 4095 loop
       writebyteenable_n_tb <= "0000";
       writedata_tb         <= x"12345678";
       checkdata            <= x"12345678";
       wait for 40 ns; 
     assert checkdata = readdata_tb report "Data Wrong"severity ERROR;
     address_tb <= address_tb + x"001";
     end loop;
    address_tb <= x"000";
-----------------------------------------------------------------------------------
      when 1 =>  --Half Word Test
      for j in 0 to 4095 loop
      writebyteenable_n_tb <= "0011"; --Top half bits are High
      writedata_tb         <= X"AAAAAAAA";
      checkdata            <= X"AAAA5678";
      wait for 40 ns; 
    assert checkdata = readdata_tb report "Data Wrong"severity ERROR;
     address_tb <= address_tb + x"001";
     end loop;
    address_tb <= x"000";
------------------------------------------------------------------------------------
      when 2 =>  --Half Word Test
      for j in 0 to 4095 loop
      writebyteenable_n_tb <= "1100"; --Bottom half bits are High
      writedata_tb         <= X"22222222";
      checkdata            <= X"AAAA2222";
      wait for 40 ns;
     assert checkdata = readdata_tb report "Data Wrong"severity ERROR;
     address_tb <= address_tb + x"001";
     end loop;
    address_tb <= x"000";
------------------------------------------------------------------------------------
      when 3 =>   --Btye Test
      for j in 0 to 4095 loop
      writebyteenable_n_tb <=    "1110"; --bottom  bit is High
      writedata_tb         <=   X"DDDDDDDD";
      checkdata            <=   X"AAAA22DD";
     wait for 40 ns;
     assert checkdata = readdata_tb report "Data Wrong"severity ERROR;
     address_tb <= address_tb + x"001";
     end loop;
    address_tb <= x"000";
-----------------------------------------------------------------------------------
      when 4 =>   --Btye Test
      for j in 0 to 4095 loop
      writebyteenable_n_tb <=    "1101"; --bottom  bit is High
      writedata_tb         <=    X"CCCCCCCC";
      checkdata            <=    X"AAAACCDD";
      wait for 40 ns;
      assert checkdata = readdata_tb report "Data Wrong"severity ERROR;
     address_tb <= address_tb + x"001";
     end loop;
    address_tb <= x"000";
-----------------------------------------------------------------------------------
      when 5 =>   --Btye Test
      for j in 0 to 4095 loop
      writebyteenable_n_tb <=    "1011"; --Top  bit is High
      writedata_tb         <=   X"FFFFFFFF";
      checkdata            <=   X"AAFFCCDD";
    wait for 40 ns;
      assert checkdata = readdata_tb report "Data Wrong"severity ERROR;
     address_tb <= address_tb + x"001";
     end loop;
    address_tb <= x"000";
-----------------------------------------------------------------------------------
      when 6 =>   --Btye Test
      for j in 0 to 4095 loop
      writebyteenable_n_tb <=    "0111"; --Top  bit is High
      writedata_tb         <=   X"BBBBBBBB";
      checkdata            <=   X"BBFFCCDD";
  wait for 40 ns;
      assert checkdata = readdata_tb report "Data Wrong"severity ERROR;
     address_tb <= address_tb + x"001";
     end loop;
     address_tb <= x"000";
-----------------------------------------------------------------------------------
   end case;
   wait for period;
-----------------------------------------------------------------------------------
end loop;
   	report " test complete,testbench stop ";
 end process;
end beh;