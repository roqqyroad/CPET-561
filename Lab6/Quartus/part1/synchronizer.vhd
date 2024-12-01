-- RJD Synchronizer from HDL

library ieee;
use ieee.std_logic_1164.all;      

entity synchronizer is
  generic (
      bits    : integer := 4
    );
  port (
    clk               : in  std_logic;
    reset             : in  std_logic;
    reset_value       : in  std_logic_vector (bits-1 downto 0);
    async_in          : in  std_logic_vector (bits-1 downto 0);
    sync_out          : out std_logic_vector (bits-1 downto 0)
  );
end synchronizer;

architecture beh of synchronizer is
signal flop1     : std_logic_vector (bits-1 downto 0);
signal flop2     : std_logic_vector (bits-1 downto 0);
signal flop3     : std_logic_vector (bits-1 downto 0);

begin 

double_flop :process(reset,clk,async_in)
  begin
    if reset = '0' then
      flop1 <= reset_value;
      flop2 <= reset_value;
      flop3 <= reset_value;
    elsif rising_edge(clk) then
      flop1 <= async_in;
      flop2 <= flop1;
      flop3 <= flop2;
    end if;
end process;

sync_out <= flop3;
end beh; 