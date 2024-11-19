--------------------------------------------------------------------------------------------------------
-- This is the top level for the arbitration_demo part2.  It instantiates the nios_system, 
-- and the bus arbiter.  Its only interface to the board is the clock and reset.  All other 
-- logic and memory is in the FPGA
--------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Arbitration_part2 is
	port( CLOCK_50          : in std_logic;
	      KEY               : in std_logic_vector(3 downto 0));
	end Arbitration_part2;
	
architecture structure of Arbitration_part2 is

   --in the nios_system there are two bridge interfaces, one for CPU_0 and one for CPU_1. They are both trying
	--to access the same RAM module, which is the reason an arbitrater is needed
	component nios_system is
		port (
			avalon_bridge0_acknowledge : in  std_logic                     := 'X';             -- acknowledge
			avalon_bridge0_irq         : in  std_logic                     := 'X';             -- irq
			avalon_bridge0_address     : out std_logic_vector(10 downto 0);                    -- address
			avalon_bridge0_bus_enable  : out std_logic;                                        -- bus_enable
			avalon_bridge0_byte_enable : out std_logic_vector(1 downto 0);                     -- byte_enable
			avalon_bridge0_rw          : out std_logic;                                        -- rw
			avalon_bridge0_write_data  : out std_logic_vector(15 downto 0);                    -- write_data
			avalon_bridge0_read_data   : in  std_logic_vector(15 downto 0) := (others => 'X'); -- read_data
			clk_clk                    : in  std_logic                     := 'X';             -- clk
			reset_reset_n              : in  std_logic                     := 'X';             -- reset_n
			avalon_bridge1_acknowledge : in  std_logic                     := 'X';             -- acknowledge
			avalon_bridge1_irq         : in  std_logic                     := 'X';             -- irq
			avalon_bridge1_address     : out std_logic_vector(10 downto 0);                    -- address
			avalon_bridge1_bus_enable  : out std_logic;                                        -- bus_enable
			avalon_bridge1_byte_enable : out std_logic_vector(1 downto 0);                     -- byte_enable
			avalon_bridge1_rw          : out std_logic;                                        -- rw
			avalon_bridge1_write_data  : out std_logic_vector(15 downto 0);                    -- write_data
			avalon_bridge1_read_data   : in  std_logic_vector(15 downto 0) := (others => 'X')  -- read_data
		);
	end component nios_system;
	
	--The purpose of the bus_arbiter is to give control of the RAM to one of the CPUs
	component Bus_Arbiter IS
	   port(
			-- Inputs
			clk                  : IN STD_LOGIC;
			reset_n              : IN STD_LOGIC;
			cpu_0_address        : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
			cpu_0_bus_enable     : IN STD_LOGIC;
			cpu_0_byte_enable    : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			cpu_0_rw             : IN STD_LOGIC;
			cpu_0_write_data     : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			cpu_1_address        : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
			cpu_1_bus_enable     : IN STD_LOGIC;
			cpu_1_byte_enable    : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			cpu_1_rw             : IN STD_LOGIC;
			cpu_1_write_data     : IN STD_LOGIC_VECTOR (15 DOWNTO 0);	
			-- Outputs
			cpu_0_acknowledge    : OUT STD_LOGIC;
			cpu_0_read_data      : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			cpu_1_acknowledge    : OUT STD_LOGIC;
			cpu_1_read_data      : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
			);
	END component;
	
	signal acknowledge0, acknowledge1 : std_logic;  
	signal irq0, irq1                 : std_logic;
	signal address0, address1         : std_logic_vector(10 downto 0);
	signal bus_enable0, bus_enable1   : std_logic; 
	signal byte_enable0, byte_enable1 : std_logic_vector(1 downto 0);                  
	signal rw0, rw1                   : std_logic;                                     
	signal write_data0, write_data1   : std_logic_vector(15 downto 0);                   
	signal read_data0, read_data1     : std_logic_vector(15 downto 0);

	

	begin
		u0 :  nios_system
		port map (
			avalon_bridge0_acknowledge => acknowledge0, -- avalon_bridge0.acknowledge
			avalon_bridge0_irq         => irq0,         --               .irq
			avalon_bridge0_address     => address0,     --               .address
			avalon_bridge0_bus_enable  => bus_enable0,  --               .bus_enable
			avalon_bridge0_byte_enable => byte_enable0, --               .byte_enable
			avalon_bridge0_rw          => rw0,          --               .rw
			avalon_bridge0_write_data  => write_data0,  --               .write_data
			avalon_bridge0_read_data   => read_data0,   --               .read_data
			clk_clk                    => CLOCK_50,                    --            clk.clk
			reset_reset_n              => KEY(0),              --          reset.reset_n
			avalon_bridge1_acknowledge => acknowledge1, -- avalon_bridge1.acknowledge
			avalon_bridge1_irq         => irq1,         --               .irq
			avalon_bridge1_address     => address1,     --               .address
			avalon_bridge1_bus_enable  => bus_enable1,  --               .bus_enable
			avalon_bridge1_byte_enable => byte_enable1, --               .byte_enable
			avalon_bridge1_rw          => rw1,          --               .rw
			avalon_bridge1_write_data  => write_data1,  --               .write_data
			avalon_bridge1_read_data   => read_data1    --               .read_data
		);
		
		u1: Bus_Arbiter 
		PORT map(
			-- Inputs
			clk                 => CLOCK_50,
			reset_n             => KEY(0),
			cpu_0_address       => address0,
			cpu_0_bus_enable    => bus_enable0,
			cpu_0_byte_enable   => byte_enable0,
			cpu_0_rw            => rw0,
			cpu_0_write_data    => write_data0,
			cpu_1_address       => address1,
			cpu_1_bus_enable    => bus_enable1,
			cpu_1_byte_enable   => byte_enable1,
			cpu_1_rw            => rw1,
			cpu_1_write_data    => write_data1,
			-- Outputs
			cpu_0_acknowledge    => acknowledge0,
			cpu_0_read_data      => read_data0,
			cpu_1_acknowledge    => acknowledge1,
			cpu_1_read_data      => read_data1
			);
end structure;