LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ECE4304_Midterm1_1 IS
    PORT (
        top_clk : IN STD_LOGIC;
        top_rst : IN STD_LOGIC;
        A : IN STD_LOGIC;
        B : IN STD_LOGIC;
        C : IN STD_LOGIC;
        D : IN STD_LOGIC;
        Z : OUT STD_LOGIC
    );
END ECE4304_Midterm1_1;

ARCHITECTURE Structural OF ECE4304_Midterm1_1 IS

    COMPONENT DFlipflop IS
        PORT (
            D : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            Q : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL E : STD_LOGIC;
    SIGNAL E_Q : STD_LOGIC;
    SIGNAL F : STD_LOGIC;
    SIGNAL F_Q : STD_LOGIC;

BEGIN

    E <= (A AND B AND C) OR D;
    F <= A NAND (B NOR C);

    EFF : DFlipflop
    PORT MAP(
        D => E,
        clk => top_clk,
        rst => top_rst,
        Q => E_Q
    );

    FFF : DFlipflop
    PORT MAP(
        D => F,
        clk => top_clk,
        rst => top_rst,
        Q => F_Q
    );

    Z <= E_Q XOR (NOT F_Q);

END Structural;