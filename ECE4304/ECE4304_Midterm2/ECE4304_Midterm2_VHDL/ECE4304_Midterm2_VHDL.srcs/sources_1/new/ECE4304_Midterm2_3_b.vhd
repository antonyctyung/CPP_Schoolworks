LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ECE4304_Midterm2_3_b IS
    PORT (
        a : IN STD_LOGIC;
        b : IN STD_LOGIC;
        c : IN STD_LOGIC;
        d : IN STD_LOGIC;
        y : OUT STD_LOGIC);
END ECE4304_Midterm2_3_b;

ARCHITECTURE Behavioral OF ECE4304_Midterm2_3_b IS

BEGIN

    PROCESS (a, b, c, d)
    BEGIN
        y <= a OR c;
        y <= a AND b;
        y <= c AND d;
    END PROCESS;

END Behavioral;