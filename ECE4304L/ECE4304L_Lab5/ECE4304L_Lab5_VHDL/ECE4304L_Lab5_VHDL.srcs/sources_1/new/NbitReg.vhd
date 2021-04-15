----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2021 11:53:00 AM
-- Design Name: 
-- Module Name: NbitReg - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY NbitReg IS
    GENERIC (N : INTEGER := 8);
    PORT (
        D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END NbitReg;

ARCHITECTURE Structural OF NbitReg IS

    COMPONENT DFlipflop IS
        PORT (
            D : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            Q : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN

    DFF_GEN : FOR i IN 0 TO N - 1 GENERATE
        DFF : DFlipflop
        PORT MAP
        (
            D => D(i),
            Q => Q(i),
            clk => clk,
            rst => rst
        );
    END GENERATE;

END Structural;