library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity servo_controller is
    port (
        clk             : in  std_logic;
        reset_n         : in  std_logic;
        address_bit     : in  std_logic_vector(1 downto 0);
        write           : in  std_logic;
        write_data      : in  std_logic_vector(31 downto 0);
        irq             : out std_logic;
        pwm_out         : out std_logic
    );
end entity;

architecture Behavioral of servo_controller is
    -- Constants
    constant PERIOD        : unsigned(31 downto 0) := x"000F4240"; --- 1,000,000 - 20 ms
    constant MIN_ANGLE     : unsigned(31 downto 0) := x"0000C350"; --- 50,000 - 1 ms
    constant MAX_ANGLE     : unsigned(31 downto 0) := x"000186A0"; --- 100,00 - 2 ms
    
    -- State Definitions
    type state_type is (SWEEP_RIGHT, INT_RIGHT, SWEEP_LEFT, INT_LEFT);
    signal current_state, next_state : state_type;

    -- Counters
    signal up_angle_cnt   : unsigned(31 downto 0) := MIN_ANGLE;
    signal down_angle_cnt : unsigned(31 downto 0) := MAX_ANGLE;
    signal period_cnt     : unsigned(31 downto 0) := (others => '0');
    
    -- Registers for angle limits
    signal Current_Lower_Angle_Limit    : unsigned(31 downto 0) := MIN_ANGLE;
    signal Current_Upper_Angle_Limit    : unsigned(31 downto 0) := MAX_ANGLE;

begin
    -- State register process
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            current_state <= SWEEP_RIGHT;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Next state logic
    process(current_state, Current_Lower_Angle_Limit, Current_Upper_Angle_Limit, write, address_bit, up_angle_cnt, down_angle_cnt)
    begin
        next_state <= current_state;
        irq <= '0';
        case current_state is
            when SWEEP_RIGHT =>
                if (up_angle_cnt >= Current_Upper_Angle_Limit) then
                    irq <= '1';
                    next_state <= INT_RIGHT;
                end if;
            
            when INT_RIGHT =>
                irq <= '1';
                if write = '1' then
                    irq <= '0';
                    next_state <= SWEEP_LEFT;
                end if;

            when SWEEP_LEFT =>
                if (down_angle_cnt <= Current_Lower_Angle_Limit) then
                    next_state <= INT_LEFT;
                end if;
            
            when INT_LEFT =>
                irq <= '1';
                if write = '1' then
                    irq <= '0';
                    next_state <= SWEEP_RIGHT;
                end if;
        end case;
    end process;

    -- Counter management
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            period_cnt <= (others => '0');
        elsif rising_edge(clk) then
            if period_cnt = PERIOD then
                period_cnt <= (others => '0');
            else
                period_cnt <= period_cnt + 1;
            end if;
        end if;
    end process;

    -- Angle Counter based on state
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            up_angle_cnt    <= MIN_ANGLE;
            down_angle_cnt  <= MAX_ANGLE;
        elsif rising_edge(clk) then
            case current_state is
                when SWEEP_RIGHT =>
                    if period_cnt <= up_angle_cnt then
                        pwm_out <= '1';
                    else
                        pwm_out <= '0';
                    end if;

                when SWEEP_LEFT =>
                    if period_cnt <= down_angle_cnt then
                        pwm_out <= '1';
                    else
                        pwm_out <= '0';
                    end if;

                when INT_RIGHT =>
                    -- if (address_bit = "00") and (write = '1') then
                        -- Current_Lower_Angle_Limit <= unsigned(write_data);
                    -- end if;
                    down_angle_cnt <= up_angle_cnt;

                when INT_LEFT =>
                    -- if (address_bit = "01") and (write = '1') then
                        -- Current_Upper_Angle_Limit <= unsigned(write_data);
                    -- end if;
                    up_angle_cnt <= down_angle_cnt;
            end case;

            -- Increment or decrement the angle count at the end of the period
            if period_cnt = PERIOD then
                if up_angle_cnt < Current_Upper_Angle_Limit then
                    up_angle_cnt <= up_angle_cnt + x"000001f4";
                elsif down_angle_cnt > Current_Lower_Angle_Limit then
                    down_angle_cnt <= down_angle_cnt - x"000001f4";
                end if;
            end if;
        end if;
    end process;
------ new process for write_data
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            Current_Lower_Angle_Limit <= MIN_ANGLE;
            Current_Upper_Angle_Limit <= MAX_ANGLE;
        elsif rising_edge(clk) then
            if write = '1' then
                if address_bit = "00" then
                    Current_Lower_Angle_Limit <= unsigned(write_data);
                elsif address_bit = "01" then
                    Current_Upper_Angle_Limit <= unsigned(write_data);
                end if;
            end if;
        end if;
    end process;

end architecture;
