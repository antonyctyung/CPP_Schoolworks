LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ECE4304_Midterm1_2 IS
    PORT (
        A : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        AGB : OUT STD_LOGIC; -- A>B
        AEB : OUT STD_LOGIC; -- A=B
        ALB : OUT STD_LOGIC -- A<B
    );
END ECE4304_Midterm1_2;

ARCHITECTURE Structural OF ECE4304_Midterm1_2 IS

    SIGNAL AGB_temp : STD_LOGIC;
    SIGNAL AEB_temp : STD_LOGIC;

BEGIN

    AGB_temp <= (A(1) AND (NOT B(1))) OR
        (A(0) AND (NOT B(1)) AND (NOT B(0))) OR
        (A(1) AND A(0) AND (NOT B(0)));
    AEB_temp <= (A(1) XNOR B(1)) AND (A(0) XNOR B(0));
    AGB <= AGB_temp;
    AEB <= AEB_temp;
    ALB <= AGB_temp NOR AEB_temp;

END Structural;