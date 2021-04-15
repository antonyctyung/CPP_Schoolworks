LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ECE4304_Midterm1_5 IS
    GENERIC (N : INTEGER := 3);
    PORT (
        X : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Y : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        P : OUT STD_LOGIC_VECTOR((2 * N) - 1 DOWNTO 0)
    );
END ECE4304_Midterm1_5;

ARCHITECTURE Structural OF ECE4304_Midterm1_5 IS

    COMPONENT NFA IS
        GENERIC (N : INTEGER := N);
        PORT (
            cin : IN STD_LOGIC;
            X : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Y : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            S : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            cout : OUT STD_LOGIC
        );
    END COMPONENT;

    TYPE vector_array IS ARRAY (N - 1 DOWNTO 0) OF STD_LOGIC_VECTOR((2 * N) - 1 DOWNTO 0);
    SIGNAL sum_vecar : vector_array;
    SIGNAL X_expand_vecar : vector_array; -- expand X(i) to match width for bitwise and
    SIGNAL summand_vecar : vector_array;

BEGIN

    P <= sum_vecar(N - 1);

    X_expand_vecar(0) <= (OTHERS => X(0)); -- expand X(i) to match width for bitwise and
    SIG_PREP_1 : FOR i IN 0 TO N - 1 GENERATE
    BEGIN
        sum_vecar(0)(i) <= Y(i) AND X_expand_vecar(0)(i);
    END GENERATE;
    sum_vecar(0)(N) <= '0';

    SIG_PREP : FOR i IN 1 TO N - 1 GENERATE
    BEGIN
        X_expand_vecar(i) <= (OTHERS => X(i)); -- expand X(i) to match width for bitwise and
        summand_vecar(i)(N + i - 1 DOWNTO i) <= X_expand_vecar(i)(N + i - 1 DOWNTO i) AND Y;
        summand_vecar(i)(i - 1 DOWNTO 0) <= (OTHERS => '0');
        summand_vecar(i)(N + i) <= '0';
    END GENERATE;

    NFA_GEN : FOR i IN 1 TO N - 1 GENERATE
    BEGIN
        NFAUnit : NFA
        GENERIC MAP(N => N + i)
        PORT MAP(
            cin => '0',
            X => sum_vecar(i - 1)(N - 1 + i DOWNTO 0),
            Y => summand_vecar(i)(N - 1 + i DOWNTO 0),
            S => sum_vecar(i)(N - 1 + i DOWNTO 0),
            cout => sum_vecar(i)(N + i)
        );
    END GENERATE;
END Structural;