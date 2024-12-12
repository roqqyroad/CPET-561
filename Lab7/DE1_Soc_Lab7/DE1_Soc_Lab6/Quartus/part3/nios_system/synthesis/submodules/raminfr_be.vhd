-----------------------------------------------------------
-- Matthew Cells
-- Memory(Lab#7 Edition)
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

Entity raminfr_be is 
    PORT(
        clk                 : in std_logic;
        reset_n             : in std_logic;
        writebyteenable_n   : IN std_logic_vector(3 DOWNTO 0);
        address             : in std_logic_vector(11 downto 0);
        writedata           : in std_logic_vector(31 downto 0);
---------------------------------------------------------
        readdata            : out std_logic_vector(31 downto 0)
        );
End entity raminfr_be;

architecture rtl of raminfr_be is 

    Type ram_type is array (4095 downto 0) of std_logic_vector(7 downto 0); -- 4Kx8 RAM
---------------------------------------------------------------------------
    signal RAM_1          : ram_type; -- signals for the 4 independent 4Kx8 RAMs
    signal RAM_2          : ram_type;
    signal RAM_3          : ram_type;
    signal RAM_4          : ram_type;
----------------------------------------------------------------------------
    signal read_addr    : std_logic_vector(11 downto 0); --same read_addr from old raminfr

begin
---------------------------------------------------------------------------------
RamBlock_1 :process(clk) --creating each process for the rams having 8 bits each in the 32bit ouput (first Ram)
    begin
    if(clk'event and clk = '1') then
        if(reset_n = '0') then 
            read_addr <=(others => '0');
         
        elsif(writebyteenable_n(0) = '0') then   
            RAM_1(conv_integer(address))<=writedata(7 downto 0);
        end if;
        read_addr <= address;
    end if;
end process RamBlock_1;
--------------------------------------------------------------------------------
RamBlock_2 :process(clk) --(second Ram)
    begin
    if(clk'event and clk = '1') then
        if(writebyteenable_n(1) = '0') then   
            RAM_2(conv_integer(address))<=writedata(15 downto 8);
        end if;
    end if;
end process RamBlock_2;
--------------------------------------------------------------------------------
RamBlock_3 :process(clk) --(third Ram)
    begin
    if(clk'event and clk = '1') then
        if(writebyteenable_n(2) = '0') then   
            RAM_3(conv_integer(address))<=writedata(23 downto 16);
        end if;
    end if;
end process RamBlock_3;
--------------------------------------------------------------------------------

RamBlock_4 :process(clk) --(fourth Ram)
    begin
    if(clk'event and clk = '1') then
        if(writebyteenable_n(3) = '0') then   
            RAM_4(conv_integer(address))<=writedata(31 downto 24);
        end if;
    end if;
end process RamBlock_4;
--------------------------------------------------------------------------------

readdata <= RAM_4(conv_integer(address)) & RAM_3(conv_integer(address)) & RAM_2(conv_integer(address)) & RAM_1(conv_integer(address));

end architecture rtl;