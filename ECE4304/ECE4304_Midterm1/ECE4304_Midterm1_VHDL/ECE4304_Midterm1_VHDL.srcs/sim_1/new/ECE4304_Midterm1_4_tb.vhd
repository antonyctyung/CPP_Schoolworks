LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.math_real.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ECE4304_Midterm1_4_tb IS
    --  Port ( );
END ECE4304_Midterm1_4_tb;

ARCHITECTURE Behavioral OF ECE4304_Midterm1_4_tb IS

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL top_clk_tb : STD_LOGIC;
    SIGNAL top_rst_tb : STD_LOGIC;

    SIGNAL in_tb : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal maj_tb : std_logic;
    signal maj_ctrl_tb : std_logic;
    SIGNAL mismatch_tb : STD_LOGIC;

    COMPONENT ECE4304_Midterm1_4 IS
        PORT (
            A : IN STD_LOGIC;
            B : IN STD_LOGIC;
            C : IN STD_LOGIC;
            D : IN STD_LOGIC;
            E : IN STD_LOGIC;
            maj : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN

    UUT : ECE4304_Midterm1_4
    PORT MAP(
        A => in_tb(4),
        B => in_tb(3),
        C => in_tb(2),
        D => in_tb(1),
        E => in_tb(0),
        maj => maj_tb
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
        variable high_num: integer; 
    BEGIN
        FOR i IN 0 TO 2 ** 5 - 1 LOOP -- all possible combination of 4 input
            in_tb <= STD_LOGIC_VECTOR(to_unsigned(i, 5));
            high_num := i/2**4 + ((i/2**3) mod 2)+ ((i/2**2) mod 2)+ ((i/2**1) mod 2)+ (i mod 2);
            if (high_num > 2) then maj_ctrl_tb <= '1'; else maj_ctrl_tb <= '0'; end if; 
            mismatch_tb <= maj_tb xor maj_ctrl_tb;
            -- can be found using "Next Transition" button in sim
            WAIT FOR clock_period;
        END LOOP;
    END PROCESS;

END Behavioral;