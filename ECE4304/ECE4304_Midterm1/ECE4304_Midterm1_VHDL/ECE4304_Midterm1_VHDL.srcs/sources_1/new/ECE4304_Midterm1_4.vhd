LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ECE4304_Midterm1_4 IS
    PORT (
        A : IN STD_LOGIC;
        B : IN STD_LOGIC;
        C : IN STD_LOGIC;
        D : IN STD_LOGIC;
        E : IN STD_LOGIC;
        maj : OUT STD_LOGIC
    );
END ECE4304_Midterm1_4;

ARCHITECTURE Structural OF ECE4304_Midterm1_4 IS

    -- 5 input majority circuit output 1 when
    -- there are >= 3 input on high
    -- we can implement this as sum of product of 
    -- all possible 3 input combinations since
    -- if there is no majority none of the products
    -- will output high, whereas if there is a majority
    -- at least three of the inputs will be high and will
    -- trigger at least one of the products

BEGIN

    maj <= (A AND B AND C) OR
        (A AND B AND D) OR
        (A AND B AND E) OR
        (A AND C AND D) OR
        (A AND C AND E) OR
        (A AND D AND E) OR
        (B AND C AND D) OR
        (B AND C AND E) OR
        (B AND D AND E) OR
        (C AND D AND E);

END Structural;