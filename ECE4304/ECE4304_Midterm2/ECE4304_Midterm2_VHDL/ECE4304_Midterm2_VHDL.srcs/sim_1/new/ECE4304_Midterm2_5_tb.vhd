LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ECE4304_Midterm2_5_tb IS
    --  Port ( );
END ECE4304_Midterm2_5_tb;

ARCHITECTURE Behavioral OF ECE4304_Midterm2_5_tb IS

    COMPONENT ECE4304_Midterm2_5 IS
        PORT (
            fsm_clk : IN STD_LOGIC;
            fsm_rst : IN STD_LOGIC;
            fsm_in : IN STD_LOGIC;
            fsm_out : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL fsm_clk_tb : STD_LOGIC;
    SIGNAL fsm_rst_tb : STD_LOGIC;
    SIGNAL fsm_in_tb  : STD_LOGIC;
    SIGNAL fsm_out_tb : STD_LOGIC;

    CONSTANT clk_period : TIME := 10ns;

BEGIN

    UUT: ECE4304_Midterm2_5
    PORT MAP(
        fsm_clk => fsm_clk_tb,
        fsm_rst => fsm_rst_tb,
        fsm_in  => fsm_in_tb,
        fsm_out => fsm_out_tb
    );

    CLK_GEN : PROCESS
    BEGIN
        fsm_clk_tb <= '0';
        WAIT FOR 0.5 * clk_period;
        fsm_clk_tb <= '1';
        WAIT FOR 0.5 * clk_period;
    END PROCESS;

    RST_GEN : PROCESS
    BEGIN
        fsm_rst_tb <= '0';
        WAIT FOR 0.25 * clk_period;
        fsm_rst_tb <= '1';
        WAIT FOR 0.75 * clk_period;
        fsm_rst_tb <= '0';
        WAIT;
    END PROCESS;

    MAIN : PROCESS
    BEGIN
        -- goal is to test each edge
        fsm_in_tb <= '0';
        WAIT FOR clk_period;
        -- now in s0 after reset
        WAIT FOR clk_period; -- 0/0, s0 to s0, new
        fsm_in_tb <= '1';
        WAIT FOR clk_period; -- 1/0, s0 to s1, new
        WAIT FOR clk_period; -- 1/0, s1 to s1, new
        fsm_in_tb <= '0';
        WAIT FOR clk_period; -- 0/0, s1 to s2, new
        fsm_in_tb <= '1';
        WAIT FOR clk_period; -- 1/0, s2 to s0, new
        WAIT FOR clk_period; -- 1/0, s0 to s1
        fsm_in_tb <= '0';
        WAIT FOR clk_period; -- 0/0, s1 to s2
        WAIT FOR clk_period; -- 0/0, s2 to s3, new
        fsm_in_tb <= '1';
        WAIT FOR clk_period; -- 1/0, s3 to s1, new
        fsm_in_tb <= '0';
        WAIT FOR clk_period; -- 0/0, s1 to s2
        WAIT FOR clk_period; -- 0/0, s2 to s3
        WAIT FOR clk_period; -- 0/1, s3 to s0, new, only clock cycle with output = 1
        WAIT; -- output should revert back to 0
        -- all 8 transitions were tested


    END PROCESS;

END Behavioral;