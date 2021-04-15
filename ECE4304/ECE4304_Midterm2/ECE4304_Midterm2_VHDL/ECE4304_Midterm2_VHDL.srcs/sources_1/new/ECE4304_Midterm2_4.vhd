LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ECE4304_Midterm2_4 IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        A : IN STD_LOGIC_VECTOR(0 downto 0);
        B : IN STD_LOGIC_VECTOR(0 downto 0);
        C : IN STD_LOGIC;
        CE : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(0 downto 0)
        );
END ECE4304_Midterm2_4;

ARCHITECTURE Behavioral OF ECE4304_Midterm2_4 IS

BEGIN

    TST : PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            Q <= (OTHERS => '0');
        ELSIF (falling_edge(clk)) THEN
            IF (CE = '1') THEN
                IF (C = '0') THEN
                    Q <= A OR B;
                ELSE
                    Q <= A AND B;
                END IF;
            END IF;
        END IF;
    END PROCESS TST;

END Behavioral;