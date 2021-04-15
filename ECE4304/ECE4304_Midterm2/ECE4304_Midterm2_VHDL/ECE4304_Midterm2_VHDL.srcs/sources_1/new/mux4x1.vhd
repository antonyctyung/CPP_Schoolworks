LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux4x1 IS
    PORT (
        x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        y : OUT STD_LOGIC
    );
END mux4x1;

ARCHITECTURE Behavioral OF mux4x1 IS

BEGIN

    PROCESS (x, sel)
    BEGIN
        CASE sel IS
            WHEN "00" => y <= x(0);
            WHEN "01" => y <= x(1);
            WHEN "10" => y <= x(2);
            WHEN "11" => y <= x(3);
        END CASE;
    END PROCESS;

END Behavioral;