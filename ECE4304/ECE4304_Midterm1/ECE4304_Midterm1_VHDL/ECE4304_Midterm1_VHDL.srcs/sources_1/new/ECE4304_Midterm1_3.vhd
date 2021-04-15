LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ECE4304_Midterm1_3 IS
    PORT (
        clk200MHZ : IN STD_LOGIC;
        top_rst : IN STD_LOGIC;
        clk1M563HZ : OUT STD_LOGIC
    );
END ECE4304_Midterm1_3;

ARCHITECTURE Structural OF ECE4304_Midterm1_3 IS

    -- upcounter as clock divider circuit
    -- each flip-flop divide clock by 2
    -- 2^n * 1.563 = 200 
    -- with n being the number of flip-flop needed
    -- log(200/1.563)/log(2) = log(128)/log(2) = 7
    -- 7 flip-flops needed

    COMPONENT DFlipflop IS
        PORT (
            D : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            Q : OUT STD_LOGIC
        );
    END COMPONENT;

    CONSTANT N : INTEGER := 7;
    SIGNAL top_Q : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL top_notQ : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL top_clk_FF : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

BEGIN

    top_notQ <= NOT top_Q;
    top_clk_FF <= top_notQ(N - 2 DOWNTO 0) & clk200MHZ; -- carry when falling edge
    clk1M563HZ <= top_Q(N - 1);
    DFF_GEN : FOR i IN 0 TO N - 1 GENERATE
    BEGIN
        DFF : DFlipflop
        PORT MAP(
            D => top_notQ(i), -- toggle each clock
            clk => top_clk_FF(i),
            rst => top_rst,
            Q => top_Q(i)
        );
    END GENERATE;

END Structural;