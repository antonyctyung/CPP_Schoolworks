LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.math_real.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ECE4304_Midterm1_1_tb IS
    --  Port ( );
END ECE4304_Midterm1_1_tb;

ARCHITECTURE Behavioral OF ECE4304_Midterm1_1_tb IS

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL top_clk_tb : STD_LOGIC;
    SIGNAL top_rst_tb : STD_LOGIC;
    SIGNAL Z_tb : STD_LOGIC;
    SIGNAL ctrl_tb : STD_LOGIC;

    SIGNAL in_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mismatch_tb : STD_LOGIC;

    COMPONENT ECE4304_Midterm1_1 IS
        PORT (
            top_clk : IN STD_LOGIC;
            top_rst : IN STD_LOGIC;
            A : IN STD_LOGIC;
            B : IN STD_LOGIC;
            C : IN STD_LOGIC;
            D : IN STD_LOGIC;
            Z : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN

    UUT : ECE4304_Midterm1_1
    PORT MAP(
        top_clk => top_clk_tb,
        top_rst => top_rst_tb,
        A => in_tb(3),
        B => in_tb(2),
        C => in_tb(1),
        D => in_tb(0),
        Z => Z_tb
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

    TEST_MAIN : PROCESS
    BEGIN
        FOR i IN 0 TO 2 ** 4 - 1 LOOP -- all possible combination of 4 input
            in_tb <= STD_LOGIC_VECTOR(to_unsigned(i, 4));
            ctrl_tb <= ((in_tb(3) AND in_tb(2) AND in_tb(1)) OR in_tb(0)) XOR (in_tb(3) AND (in_tb(2) NOR in_tb(1)));
            mismatch_tb <= Z_tb XOR ctrl_tb; -- can be found using "Next Transition" button in sim
            WAIT FOR clock_period;
        END LOOP;
    END PROCESS;

END Behavioral;