--------------------------------------------------------------------------------------------------------
-- This is the top level for the arbitration_demo part1.  It instantiates the nios_system, 
-- the RAM controller and the external RAM
--------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Arbitration_part1 is
	port( CLOCK_50          : in std_logic;
	      KEY               : in std_logic_vector(3 downto 0);
			LEDR              : out std_logic_vector(9 downto 0));
	end Arbitration_part1;
	
architecture structure of Arbitration_part1 is

	component nios_system is
		port (
			clk_clk                   : in  std_logic                     := 'X';             -- clk
			reset_reset_n             : in  std_logic                     := 'X';             -- reset_n
			avalon_bridge_acknowledge : in  std_logic                     := 'X';             -- acknowledge
			avalon_bridge_irq         : in  std_logic                     := 'X';             -- irq
			avalon_bridge_address     : out std_logic_vector(10 downto 0);                    -- address
			avalon_bridge_bus_enable  : out std_logic;                                        -- bus_enable
			avalon_bridge_byte_enable : out std_logic_vector(1 downto 0);                     -- byte_enable
			avalon_bridge_rw          : out std_logic;                                        -- rw
			avalon_bridge_write_data  : out std_logic_vector(15 downto 0);                    -- write_data
			avalon_bridge_read_data   : in  std_logic_vector(15 downto 0);                    -- read_data
			ledr_export               : out std_logic_vector(9 downto 0)                      -- export
		);
	end component nios_system;
	
	component external_RAM IS
		PORT(
			address		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			wren		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END Component;
	
	component RAM_controller is
		PORT( clk                : in  std_logic                     := 'X';             -- clk
			reset_n            : in  std_logic                     := 'X';             -- reset_n
         ---- Bridge Interface 
			bridge_acknowledge : out  std_logic                     := 'X';             -- acknowledge
			bridge_irq         : out  std_logic                     := 'X';             -- irq
			bridge_address     : in std_logic_vector(10 downto 0);                    -- address
			bridge_bus_enable  : in std_logic;                                        -- bus_enable
			bridge_byte_enable : in std_logic_vector(1 downto 0);                     -- byte_enable
			bridge_rw          : in std_logic;                                        -- rw (0 = write, 1= read)
			bridge_write_data  : in std_logic_vector(15 downto 0);                    -- write_data
			bridge_read_data   : out  std_logic_vector(15 downto 0) := (others => 'X');  -- read_data
			---- RAM interface
			ram_address		: out STD_LOGIC_VECTOR (10 DOWNTO 0);
			ram_data		   : out STD_LOGIC_VECTOR (15 DOWNTO 0);
			ram_wren		   : out STD_LOGIC;
			ram_q		      : in STD_LOGIC_VECTOR (15 DOWNTO 0));
	end component;
	
	signal acknowledge : std_logic;  
	signal irq         : std_logic;
	signal address     : std_logic_vector(10 downto 0);
	signal bus_enable  : std_logic; 
	signal byte_enable : std_logic_vector(1 downto 0);                  
	signal rw          : std_logic;                                     
	signal write_data  : std_logic_vector(15 downto 0);                   
	signal read_data   : std_logic_vector(15 downto 0);
	signal ram_address : STD_LOGIC_VECTOR (10 DOWNTO 0);
	signal ram_data	 : STD_LOGIC_VECTOR (15 DOWNTO 0);
	signal ram_wren	 : STD_LOGIC;
	signal ram_q		 : STD_LOGIC_VECTOR (15 DOWNTO 0);

	begin
		u0 : nios_system
		port map (
			clk_clk                   => CLOCK_50,                   --           clk.clk
			reset_reset_n             => KEY(0),           --         reset.reset_n
			avalon_bridge_acknowledge => acknowledge, -- avalon_bridge.acknowledge
			avalon_bridge_irq         => irq,         --              .irq
			avalon_bridge_address     => address,     --              .address
			avalon_bridge_bus_enable  => bus_enable,  --              .bus_enable
			avalon_bridge_byte_enable => byte_enable, --              .byte_enable
			avalon_bridge_rw          => rw,          --              .rw
			avalon_bridge_write_data  => write_data,  --              .write_data
			avalon_bridge_read_data   => read_data,   --              .read_data
			ledr_export               => LEDR
		);
		u1: RAM_controller 
		PORT map ( clk               => CLOCK_50,
			reset_n                   => KEY(0),                   
         ---- Bridge Interface 
			bridge_acknowledge => acknowledge,
			bridge_irq         => irq,
			bridge_address     => address,
			bridge_bus_enable  => bus_enable,
			bridge_byte_enable => byte_enable,
			bridge_rw          => rw,
			bridge_write_data  => write_data,
			bridge_read_data   => read_data,
			---- RAM interface
			ram_address		=> ram_address,
			ram_data		   => ram_data,
			ram_wren		   => ram_wren,
			ram_q		      => ram_q
		);
		u2: external_RAM 
		PORT map (
			address	=> ram_address,
			clock		=> CLOCK_50,
			data		=> ram_data,
			wren		=> ram_wren,
			q		   => ram_q
		); 
end structure;