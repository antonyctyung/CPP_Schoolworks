LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.math_real.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ECE4304_Midterm1_2_tb IS
    --  Port ( );
END ECE4304_Midterm1_2_tb;

ARCHITECTURE Behavioral OF ECE4304_Midterm1_2_tb IS

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL top_clk_tb : STD_LOGIC;
    SIGNAL top_rst_tb : STD_LOGIC;
    SIGNAL AGB_tb : STD_LOGIC;
    SIGNAL AEB_tb : STD_LOGIC;
    SIGNAL ALB_tb : STD_LOGIC;
    SIGNAL AGB_ctrl_tb : STD_LOGIC;
    SIGNAL AEB_ctrl_tb : STD_LOGIC;
    SIGNAL ALB_ctrl_tb : STD_LOGIC;

    SIGNAL in_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mismatch_tb : STD_LOGIC;

    COMPONENT ECE4304_Midterm1_2 IS
        PORT (
            A : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            AGB : OUT STD_LOGIC; -- A>B
            AEB : OUT STD_LOGIC; -- A=B
            ALB : OUT STD_LOGIC -- A<B
        );
    END COMPONENT;

BEGIN

    UUT : ECE4304_Midterm1_2
    PORT MAP(
        A => in_tb(3 DOWNTO 2),
        B => in_tb(1 DOWNTO 0),
        AGB => AGB_tb,
        AEB => AEB_tb,
        ALB => ALB_tb
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
        VARIABLE A_int : INTEGER;
        VARIABLE B_int : INTEGER;
    BEGIN
        FOR i IN 0 TO 2 ** 4 - 1 LOOP -- all possible combination of 4 input
            in_tb <= STD_LOGIC_VECTOR(to_unsigned(i, 4));
            A_int := i/4;
            B_int := i MOD 4;
            IF (A_int > B_int) THEN
                AGB_ctrl_tb <= '1';
            ELSE
                AGB_ctrl_tb <= '0';
            END IF;
            IF (A_int = B_int) THEN
                AEB_ctrl_tb <= '1';
            ELSE
                AEB_ctrl_tb <= '0';
            END IF;
            IF (A_int < B_int) THEN
                ALB_ctrl_tb <= '1';
            ELSE
                ALB_ctrl_tb <= '0';
            END IF;
            mismatch_tb <= (AGB_ctrl_tb XOR AGB_tb) OR
                (AEB_ctrl_tb XOR AEB_tb) OR
                (ALB_ctrl_tb XOR ALB_tb);
            -- can be found using "Next Transition" button in sim
            WAIT FOR clock_period;
        END LOOP;
    END PROCESS;

END Behavioral;