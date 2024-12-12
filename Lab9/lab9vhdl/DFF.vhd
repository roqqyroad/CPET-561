library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity DFF is
port(
	D			: in std_logic_vector(15 downto 0); 
	clk, clr    : in std_logic;
	filter_en	: in std_logic;
	Q    		: out std_logic_vector(15 downto 0)
	);
end DFF;




architecture bhv of DFF is

begin 
	process(clk, clr, filter_en) is	
	begin
		if (clr = '0') then
			Q <= x"0000";
		elsif rising_edge(clk) then
			if(filter_en = '1')then
				Q <= D;
			end if;
		end if;
	end process;
end bhv; 