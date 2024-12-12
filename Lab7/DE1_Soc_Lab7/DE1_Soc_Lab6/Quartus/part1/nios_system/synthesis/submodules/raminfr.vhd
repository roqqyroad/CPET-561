-----------------------------------------------------------
-- Matthew Cells
-- Memory 
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

Entity raminfr is 
    PORT(
        clk         : in std_logic;
        reset_n     : in std_logic;
        write_n     : in std_logic;
        address     : in std_logic_vector(11 downto 0);
        writedata   : in std_logic_vector(31 downto 0);
---------------------------------------------------------
        readdata    : out std_logic_vector(31 downto 0)
        );
End Entity raminfr;


architecture rtl of raminfr is 

    Type ram_type is array (4095 downto 0) of std_logic_vector(31 downto 0);
    signal RAM          : ram_type;
    signal read_addr    : std_logic_vector(11 downto 0);
    
begin
    RamBlock :process(clk)
    begin
    if(clk'event and clk = '1') then
        if(reset_n = '0') then 
            read_addr <=(others => '0');
        elsif(write_n = '0') then   
            RAM(conv_integer(address))<=writedata;
        end if;
        read_addr <= address;
    end if;
end process RamBlock;

readdata <= RAM(conv_integer(read_addr));

end architecture rtl;