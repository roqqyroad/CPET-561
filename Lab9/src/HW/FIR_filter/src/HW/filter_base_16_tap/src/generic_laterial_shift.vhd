-------------------------------------------------------------------------------
-- Nathaniel Valla
-- Lab_7 top
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


entity generic_laterial_shift is
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
end;

architecture beh of generic_laterial_shift is
begin
  process(reset,clk)
  begin
    if reset = '1' then
      shift_out <= preset;
    elsif clk'event and clk = '1' then
      if enable = '1' then  
        shift_out <= shift_in;
      end if;
    end if;
  end process;
end;