LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.math_real.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ECE4304_Midterm1_5_tb IS
    --  Port ( );
END ECE4304_Midterm1_5_tb;

ARCHITECTURE Behavioral OF ECE4304_Midterm1_5_tb IS

    CONSTANT clock_period : TIME := 10 ns;
    CONSTANT N_tb : INTEGER := 3;

    SIGNAL top_clk_tb : STD_LOGIC;
    SIGNAL top_rst_tb : STD_LOGIC;

    SIGNAL X_tb : STD_LOGIC_VECTOR(N_tb - 1 DOWNTO 0);
    SIGNAL Y_tb : STD_LOGIC_VECTOR(N_tb - 1 DOWNTO 0);
    SIGNAL P_tb : STD_LOGIC_VECTOR((2 * N_tb) - 1 DOWNTO 0);

    SIGNAL mismatch_tb : STD_LOGIC;

    COMPONENT ECE4304_Midterm1_5 IS
        GENERIC (N : INTEGER := N_tb);
        PORT (
            X : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Y : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            P : OUT STD_LOGIC_VECTOR((2 * N) - 1 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    UUT : ECE4304_Midterm1_5
    GENERIC MAP(N => N_tb)
    PORT MAP(
        X => X_tb,
        Y => Y_tb,
        P => P_tb
    );

    CLK_GEN : PROCESS
    BEGIN
        top_clk_tb <= '0';
        WAIT FOR 0.5 * clock_period;
        top_clk_tb <= '1';
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
        FOR i IN 0 TO 2 ** N_tb - 1 LOOP -- all possible combination of inputs
            FOR j IN 0 TO 2 ** N_tb - 1 LOOP
                X_tb <= STD_LOGIC_VECTOR(to_unsigned(i, N_tb));
                Y_tb <= STD_LOGIC_VECTOR(to_unsigned(j, N_tb));
                WAIT FOR clock_period;
                IF (conv_integer(P_tb) = i * j) THEN
                    mismatch_tb <= '0';
                ELSE
                    mismatch_tb <= '1';
                END IF;
            END LOOP;
        END LOOP;
    END PROCESS;

END Behavioral;