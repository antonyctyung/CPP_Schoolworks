LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.math_real.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ECE4304_Midterm1_3_tb IS
    --  Port ( );
END ECE4304_Midterm1_3_tb;

ARCHITECTURE Behavioral OF ECE4304_Midterm1_3_tb IS

    CONSTANT clock_period : TIME := 5 ns; -- 1/200MHZ is 5 ns
    SIGNAL top_clk_tb : STD_LOGIC;
    SIGNAL top_rst_tb : STD_LOGIC;
    SIGNAL top_clk_out_tb : STD_LOGIC;

    COMPONENT ECE4304_Midterm1_3 IS
        PORT (
            clk200MHZ : IN STD_LOGIC;
            top_rst : IN STD_LOGIC;
            clk1M563HZ : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN

    UUT : ECE4304_Midterm1_3
    PORT MAP(
        clk200MHZ => top_clk_tb,
        top_rst => top_rst_tb,
        clk1M563HZ => top_clk_out_tb
    );

    CLK_GEN : PROCESS
    BEGIN
        top_clk_tb <= '1';
        WAIT FOR 0.5 * clock_period;
        top_clk_tb <= '0';
        WAIT FOR 0.5 * clock_period;
    END PROCESS;

    INIT_RST : PROCESS
    BEGIN
        top_rst_tb <= '1';
        WAIT FOR 0.5 * clock_period;
        top_rst_tb <= '0';
        WAIT;
    END PROCESS;

END Behavioral;