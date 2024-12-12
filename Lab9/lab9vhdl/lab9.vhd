-------------------------------------------------------------------------------
-- Anna Welton
-- Low-Pass-Filter
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_signed.ALL;

entity lab9 is 
  port (
    clk               : in std_logic;
    reset_n           : in std_logic;
	write   		  : in std_logic;
	address			  : in std_logic;
	writedata		  : in std_logic_vector(15 downto 0);
    data_out          : out std_logic_vector(15 downto 0)
  );
end lab9;

architecture rtl of lab9 is
-- signal declarations

type fixed_point is array (16 downto 0) of std_logic_vector(15 downto 0);
constant low_pass : fixed_point := (x"0051",x"00BA",x"01E1",x"0408",x"071A",x"0AAC",x"0E11",x"107F",
								  x"1161",x"107F",x"0E11",x"0AAC",x"071A",x"0408",x"01E1",x"00BA",x"0051");
constant high_pass : fixed_point := (x"003E",x"FF9B",x"FE9F",x"0000",x"0535",x"05B2",x"F5AC",x"DAB7",
								  x"4C91",x"DAB7",x"F5AC",x"05B2",x"0535",x"0000",x"FE9F",x"FF9B",x"003E");
								  
signal filter : fixed_point;

signal filter_enable : std_logic;
signal switch : std_logic_vector(15 downto 0);
signal D_IN : std_logic_vector(15 downto 0);

type D_Array is array (16 downto 0) of std_logic_vector(15 downto 0);
signal data_array : D_Array := (others => (others => '0'));

type Sign_Array is array (16 downto 0) of signed(15 downto 0);
signal add_sign   : Sign_Array:= (others => (others => '0'));

type mul_array is array (16 downto 0) of std_logic_vector(31 downto 0);
signal mul_res : mul_array:= (others => (others => '0'));


signal sum : signed(19 downto 0);


component Multiplier is
	port(
		 dataa		: in std_logic_vector(15 downto 0);
		 datab		: in std_logic_vector(15 downto 0);
		 result		: out std_logic_vector(31 downto 0)
		);
end component Multiplier;

component D_FF is
	port(
		 D			: in std_logic_vector(15 downto 0);
		 clk		: in std_logic;
		 clr		: in std_logic;
		 filter_en  : in std_logic;
		 Q			: out std_logic_vector(15 downto 0)
		);
end component D_FF;

begin

	--data in
	process(clk,reset_n)
	  begin
		if(reset_n = '0')then
			D_IN   <= x"0000";
			switch <= x"0000";
	 elsif(clk'event and clk = '1')then
			if(write = '1')then
				if(address = '0')then
					D_IN <= writedata;
				else
					switch <= writedata;
				end if;
			end if;
		end if;
	end process;

	-- filter select
	process(clk, reset_n)
		begin
			if(reset_n = '0')then
				filter <= low_pass;
		 elsif(clk'event and clk = '1')then
				if(switch(0) = '1')then
					filter <= low_pass;
			    else
					filter <= high_pass;
			end if;
		end if;
	end process;
	
	--filter_en and write
	process(clk,reset_n)
	  begin
		if(reset_n = '0')then
			filter_enable <= '0';
	 elsif(clk'event and clk = '1')then
			if(write = '1' and address = '0')then
				filter_enable <= '1';
			else
				filter_enable <= '0';
			end if;
		end if;
	end process;
				

	data_array(0) <= D_IN;

	DFF_loop:for i in 0 to 15 generate			
		DFF1:D_FF
			port map(
					 D         => data_array(i),
					 clk	   => clk,
					 clr	   => reset_n,
					 filter_en => filter_enable,
					 Q		   => data_array(i+1)
					);
	end generate;
				
	Multi_loop:for i in 0 to 16 generate
		Mul0:Multiplier
			port map(
					dataa  => data_array(i),
					datab  => filter(i),
					result => mul_res(i)
					);
			add_sign(i) <= signed(mul_res(i)(30 downto 15));
	end generate;
	
	sum <= resize(add_sign(0),20)+resize(add_sign(1),20)+resize(add_sign(2),20)+resize(add_sign(3),20)+resize(add_sign(4),20)+resize(add_sign(5),20)+
			resize(add_sign(6),20)+resize(add_sign(7),20)+resize(add_sign(8),20)+resize(add_sign(9),20)+resize(add_sign(10),20)+resize(add_sign(11),20)+
			resize(add_sign(12),20)+resize(add_sign(13),20)+resize(add_sign(14),20)+resize(add_sign(15),20)+resize(add_sign(16),20);
	
	process(clk,reset_n)
		begin 
			if(reset_n = '0')then
				data_out <= x"0000";
		 elsif(clk'event and clk = '1')then
				data_out <= std_logic_vector(sum(15 downto 0));
		end if;
	end process;

end architecture rtl;