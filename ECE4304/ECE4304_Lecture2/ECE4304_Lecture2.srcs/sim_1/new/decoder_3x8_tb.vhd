----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2021 05:40:37 PM
-- Design Name: 
-- Module Name: decoder_3x8_tb - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity decoder_3x8_tb is
--  Port ( );
end decoder_3x8_tb;

architecture Behavioral of decoder_3x8_tb is
component decoder_3x8
    Port (
        clk: in std_logic;
        rst: in std_logic;
        s: in std_logic_vector(2 downto 0);
        p: out std_logic_vector(7 downto 0)
    );
end component;

signal clk_tb:std_logic;
signal rst_tb:std_logic;
signal s_tb:std_logic_vector(2 downto 0);
signal p_tb:std_logic_vector(2 downto 0);

constant clock_period:time := 10 ns;

begin

CLK_GEN: process
    begin
        clk_tb <= '1';
        wait for clock_period/2;
        clk_tb <= '0';
        wait for clock_period/2;
    end process;

DECOD_COMP: decoder_3x8 port map (
        clk => clk_tb,
        rst => rst_tb,
        s => s_tb,
        p => p_tb
);

TEST_CASE_1: process
        begin
            rst_tb <= '1';
            wait for clock_period;
            rst_tb <='0';
            wait for clock_period;
            s_tb <= o"0";
            wait for clock_period;
            s_tb <= o"1";
            wait for clock_period;
            s_tb <= o"2";
            wait for clock_period;
            s_tb <= o"3";
            wait for clock_period;
            s_tb <= o"4";
            wait for clock_period;
            s_tb <= o"5";
            wait for clock_period;
            s_tb <= o"6";
            wait for clock_period;
            s_tb <= o"7";
            wait for clock_period;
            rst_tb <= '1';
            wait for clock_period;
            rst_tb <='0';
            wait;
        end process;

end Behavioral;
