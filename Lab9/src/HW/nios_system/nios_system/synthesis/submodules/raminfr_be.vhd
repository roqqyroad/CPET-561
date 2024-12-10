-----------------------------------------------------------------------
--- your header goes here
-----------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY raminfr_be IS
  PORT(
    clk                 : IN  std_logic;
    reset_n             : IN  std_logic;
    writebyteenable_n   : IN  std_logic_vector(3 DOWNTO 0);
    address             : IN  std_logic_vector(11 DOWNTO 0);
    writedata           : IN  std_logic_vector(31 DOWNTO 0);
    --
    readdata            : OUT std_logic_vector(31 DOWNTO 0)
  );
END ENTITY raminfr_be;

ARCHITECTURE rtl OF raminfr_be IS
  
  COMPONENT raminfr IS
    PORT(
      clk       : IN std_logic;
      reset_n   : IN std_logic;
      write_n   : IN std_logic;
      address   : IN std_logic_vector(11 DOWNTO 0);
      writedata : IN std_logic_vector(7 DOWNTO 0);
      --
      readdata  : OUT std_logic_vector(7 DOWNTO 0)
    );
  END COMPONENT raminfr;

  CONSTANT byte    : integer := 4;
BEGIN
  
  ram_4bytes: for i in 0 to byte-1 generate
    ram_block: raminfr
      port map (
        clk         => clk,
        reset_n     => reset_n,
        write_n     => writebyteenable_n(i),
        address     => address,
        writedata   => writedata(7+i*8 downto i*8),
        readdata    => readdata(7+i*8 downto i*8)
      );
  end generate;
  
END ARCHITECTURE rtl;

