LIBRARY ieee;
USE STD.textio.ALL;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY filter_16_base_tb IS
END filter_16_base_tb;
ARCHITECTURE arch OF filter_16_base_tb IS

    TYPE cycle_array is array (39 DOWNTO 0) of std_logic_vector(15 downto 0);
    
    --- COMPONNETS 
    COMPONENT filter_16_base IS
        GENERIC (
            bit_depth           :       INTEGER := 16
        );
        PORT (
            clk                 :       IN STD_LOGIC;
            reset               :       IN STD_LOGIC;
            filter_en           :       IN STD_LOGIC;
            filter_type         :       IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            data_in             :       IN STD_LOGIC_VECTOR(bit_depth - 1 DOWNTO 0);
            data_out            :       OUT STD_LOGIC_VECTOR(bit_depth - 1 DOWNTO 0)
        );
    END COMPONENT filter_16_base;
    ---END OF COMPONENTS

    --- CONSTANTS 
    constant period : time := 20ns; -- used when waiting in the main process for tb
    ---EMD OF CONSTANTS

    --- SIGNALS
    signal clk                  :       std_logic := '0';
    signal reset                :       std_logic := '1';
    signal filter_en            :       std_logic := '0';
    signal filter_type          :       std_logic_vector(1 downto 0):= "10";
    signal data_in              :       std_logic_vector(15 downto 0) := (others =>'0');
    signal data_out             :       std_logic_vector(15 downto 0);
    signal audioSampleArray     :       cycle_array;
    --- END OF SIGNALS
BEGIN

    uut : filter_16_base 
    generic map (
        bit_depth       =>          16
    )
    port map (
        clk             =>          clk, 
        reset           =>          reset,
        filter_en       =>          filter_en, 
        filter_type     =>          filter_type,
        data_in         =>          data_in,
        data_out        =>          data_out
    );


    --- CLOCK PROCESS
    clock : PROCESS
    BEGIN
        clk <= NOT clk;
        WAIT FOR period/2;
    END PROCESS;
    --END OF CLOCK PROCESS 

    --- RESET PROCESS
    async_reset : PROCESS
    BEGIN
        WAIT FOR 2 * period;
        reset <= '0';
        WAIT;
    END PROCESS;
    --END OF RESET PROCESS

    ---This is the main process for testing the program
    stimulus : PROCESS IS
        FILE read_file : text OPEN read_mode IS "./src/verification_src/one_cycle_integer.csv";
        FILE results_file : text OPEN write_mode IS "./src/verification_src/output_waveform.csv";
        VARIABLE lineIn : line;
        VARIABLE lineOut : line;
        VARIABLE readValue : INTEGER;
        VARIABLE writeValue : INTEGER;

    BEGIN
        WAIT FOR 100 ns;
        reset <= '1';

        -- Read data from file into an array
        FOR i IN 0 TO 39 LOOP
            readline(read_file, lineIn);
            read(lineIn, readValue);
            audioSampleArray(i) <= to_signed(readValue, 16);
            WAIT FOR 50 ns;
        END LOOP;

        file_close(read_file);

        -- Apply the test data and put the result into an output file
        FOR i IN 1 TO 10 LOOP
            FOR j IN 0 TO 39 LOOP
                -- Your code here...
                -- Read the data from the array and apply it to Data_In
                -- Remember to provide an enable pulse with each new sample
                data_in <= audioSampleArr(j);
                filter_en <= '1';
                WAIT FOR period;

                -- Write filter output to file
                writeValue := to_integer(data_out);
                write(lineOut, writeValue);
                writeline(results_file, lineOut);

                -- Your code here...
                filter_en <= '0';
                WAIT FOR period;
            END LOOP;
        END LOOP;

        file_close(results_file);
        -- end simulation
        sim_done <= true;
        WAIT FOR 100 ns;
        -- last wait statement needs to be here to prevent the process
        -- sequence from restarting at the beginning
        WAIT;

    END PROCESS stimulus;
END arch; -- arch