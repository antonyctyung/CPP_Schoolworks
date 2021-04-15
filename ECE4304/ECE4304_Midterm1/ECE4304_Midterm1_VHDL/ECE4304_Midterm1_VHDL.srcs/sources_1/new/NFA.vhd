LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY NFA IS
    GENERIC (N : INTEGER := 1);
    PORT (
        cin : IN STD_LOGIC;
        X : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Y : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        S : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        cout : OUT STD_LOGIC
    );
END NFA;

ARCHITECTURE Structural OF NFA IS

    SIGNAL C : STD_LOGIC_VECTOR(N DOWNTO 0);

BEGIN

    cout <= C(N);
    C(0) <= cin;
    FA_GEN : FOR i IN 0 TO N - 1 GENERATE
        C(i + 1) <= (X(i) AND Y(i)) OR (X(i) AND C(i)) OR (Y(i) AND C(i));
        S(i) <= X(i) XOR Y(i) XOR C(i);
    END GENERATE;

END Structural;