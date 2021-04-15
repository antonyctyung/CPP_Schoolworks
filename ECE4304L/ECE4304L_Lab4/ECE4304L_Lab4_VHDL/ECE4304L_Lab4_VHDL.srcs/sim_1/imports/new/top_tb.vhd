----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2021 01:26:21 PM
-- Design Name: 
-- Module Name: top_tb - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;
USE STD.textio.ALL;
USE IEEE.std_logic_textio.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY top_tb IS
    --  Port ( );
END top_tb;

ARCHITECTURE Behavioral OF top_tb IS

    COMPONENT top IS
        PORT (
            top_clk : IN STD_LOGIC;
            top_rst : IN STD_LOGIC;
            top_c7s_rst_in : IN STD_LOGIC;
            top_bcd_rst_in : IN STD_LOGIC;
            top_ud : IN STD_LOGIC;
            top_a_to_g : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            top_an : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            top_dp : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL top_clk_tb : STD_LOGIC;
    SIGNAL top_rst_tb : STD_LOGIC;
    SIGNAL top_c7s_rst_in_tb : STD_LOGIC;
    SIGNAL top_bcd_rst_in_tb : STD_LOGIC;
    SIGNAL top_ud_tb : STD_LOGIC;
    SIGNAL top_a_to_g_tb : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL top_an_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL top_dp_tb : STD_LOGIC;

    CONSTANT clock_period : TIME := 10 ps;

    FILE file_vectors : text;
    FILE file_results : text;

BEGIN

    TOP_GEN : top
    PORT MAP(
        top_clk => top_clk_tb,
        top_rst => top_rst_tb,
        top_c7s_rst_in => top_c7s_rst_in_tb,
        top_bcd_rst_in => top_bcd_rst_in_tb,
        top_ud => top_ud_tb,
        top_a_to_g => top_a_to_g_tb,
        top_an => top_an_tb,
        top_dp => top_dp_tb
    );

    CLK_GEN : PROCESS
    BEGIN
        top_clk_tb <= '0';
        WAIT FOR clock_period;
        top_clk_tb <= '1';
        WAIT FOR clock_period;
    END PROCESS;

    TEXTIO_GEN : PROCESS
    BEGIN
        top_rst <= '0'
            top_c7s_rst_in <= '0'
            top_bcd_rst_in <= '0'
            WAIT FOR clock_period;
        top_rst <= '1'
            top_c7s_rst_in <= '1'
            top_bcd_rst_in <= '1'
            WAIT FOR clock_period;
        top_rst <= '0'
            top_c7s_rst_in <= '0'
            top_bcd_rst_in <= '0'
            WAIT FOR clock_period;
        VARIABLE v_ILINE : line;
        VARIABLE v_OLINE : line;

        VARIABLE v_INP0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE v_INP1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE v_space : CHARACTER;
    BEGIN

        file_open(file_vectors, "", read_mode);
        file_open(file_results, "", write_mode);
        WHILE NOT endfile(file_vectors) LOOP
            write(v_OLINE, top_a_to_g_tb);
            write(v_OLINE, v_SPACE);
            write(v_OLINE, top_an_tb);
            write(v_OLINE, v_SPACE);
            write(v_OLINE, top_dp_tb);

            writeline(file_results, v_OLINE);

            WAIT FOR clock_period;
            write(v_OLINE, top_a_to_g_tb);
            write(v_OLINE, v_SPACE);
            write(v_OLINE, top_an_tb);
            write(v_OLINE, v_SPACE);
            write(v_OLINE, top_dp_tb);

            writeline(file_results, v_OLINE);

            WAIT FOR (2 ** 18) * clock_period;

            write(v_OLINE, top_a_to_g_tb);
            write(v_OLINE, v_SPACE);
            write(v_OLINE, top_an_tb);
            write(v_OLINE, v_SPACE);
            write(v_OLINE, top_dp_tb);

            writeline(file_results, v_OLINE);

        END LOOP;
        file_close(file_vectors);
        file_close(file_results);

        WAIT;
    END PROCESS;

END Behavioral;