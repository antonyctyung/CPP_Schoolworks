LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY dffr IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        d : IN STD_LOGIC;
        q : OUT STD_LOGIC
    );
END dffr;

ARCHITECTURE arch OF dffr IS

BEGIN

    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN -- asynchronous reset
            q <= '0';
        ELSIF (rising_edge(clk)) THEN -- d get clocked to q when rising and not reset
            q <= d;
        END IF;
    END PROCESS;

END arch;