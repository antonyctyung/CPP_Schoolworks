LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ECE4304_Midterm2_1 IS
    PORT (
        clk : IN STD_LOGIC;
        ctrl : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        r1_reg_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        r2_reg_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
    );
END ECE4304_Midterm2_1;

ARCHITECTURE Behavioral OF ECE4304_Midterm2_1 IS

    SIGNAL r1_reg : STD_LOGIC_VECTOR(0 DOWNTO 0);
    SIGNAL r1_next : STD_LOGIC_VECTOR(0 DOWNTO 0);
    SIGNAL r2_reg : STD_LOGIC_VECTOR(0 DOWNTO 0);

    COMPONENT mux4x1 IS
        PORT (
            x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            y : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL sum : STD_LOGIC_VECTOR(0 DOWNTO 0);
    SIGNAL inc : STD_LOGIC_VECTOR(0 DOWNTO 0);

BEGIN

    -- mux here
    MUX : mux4x1
    PORT MAP(
        x => r1_reg & sum & inc & "1",
        sel => ctrl,
        y => r1_next(0)
    );

    -- arithmetics (+ and +1)
    sum <= r1_reg + r2_reg;
    inc <= r1_reg + "1";

    -- clock r1 and r2
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            r1_reg <= r1_next;
            r2_reg <= "Z";
        END IF;
    END PROCESS;

    -- produce output to produce RTL schematic
    r1_reg_out <= r1_reg;
    r2_reg_out <= r2_reg;

END Behavioral;