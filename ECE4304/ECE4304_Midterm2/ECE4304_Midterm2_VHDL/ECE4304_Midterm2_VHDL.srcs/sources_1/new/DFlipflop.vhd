LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DFlipflop IS
    PORT (
        D : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT STD_LOGIC
    );
END DFlipflop;

ARCHITECTURE Behavioral OF DFlipflop IS
BEGIN

    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
                Q <= '0';
        ELSIF (rising_edge(clk)) THEN
                Q <= D;
        END IF;
    END PROCESS;

END Behavioral;