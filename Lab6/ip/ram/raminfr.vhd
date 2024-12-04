LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY raminfr IS

    PORT (
        clk : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;
        write_n : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        --
        readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY raminfr;


ARCHITECTURE rtl OF raminfr IS

    TYPE ram_type IS ARRAY (4095 DOWNTO 0) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL RAM : ram_type;
    SIGNAL read_addr : STD_LOGIC_VECTOR(11 DOWNTO 0);

BEGIN

    RamBlock : PROCESS (clk)

    BEGIN

        IF (clk'event AND clk = '1') THEN
            IF (reset_n = '0') THEN
                read_addr <= (OTHERS => '0');
            ELSIF (write_n = '0') THEN
                RAM(conv_integer(address)) <= writedata;
            END IF;
            read_addr <= address;
        END IF;

    END PROCESS RamBlock;

    readdata <= RAM(conv_integer(read_addr));
    
END ARCHITECTURE rtl;