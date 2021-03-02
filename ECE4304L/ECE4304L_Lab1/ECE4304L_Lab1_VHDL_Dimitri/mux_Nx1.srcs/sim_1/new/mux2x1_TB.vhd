----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2021 12:05:22 AM
-- Design Name: 
-- Module Name: Mux_2x1_TB - Behavioral
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

entity mux2x1_TB is
--  Port ( );
end mux2x1_TB;

architecture Behavioral of mux2x1_TB is

component mux2x1
        port(
                clk     :   in  std_logic;
                rst     :   in  std_logic;
                inp_0   :   in  std_logic;
                inp_1   :   in  std_logic;
                sel     :   in  std_logic;
                op      :   out std_logic        
            );
end component;

signal clk_tb:   std_logic;
signal rst_tb:   std_logic;
signal inp_0_tb: std_logic;
signal inp_1_tb: std_logic;
signal sel_tb:   std_logic;
signal op_tb:    std_logic;

constant clock_period: time:= 10 ns;

begin
    MUX_GEN: mux2x1
            port map (
                        clk   => clk_tb,
                        rst   => rst_tb,
                        inp_0 => inp_0_tb,
                        inp_1   => inp_1_tb,
                        sel => sel_tb,
                        op  => op_tb 
                     );
                     
     TSB: process
          begin
            clk_tb <= '0';
            rst_tb <= '0';
            sel_tb <= '0';
            inp_1_tb  <= '0';
            inp_0_tb   <= '0';
            wait for clock_period;
            clk_tb <= '1';
            wait for clock_period;
            clk_tb <= '0';
            sel_tb <= '0';
            inp_1_tb   <= '0';
            inp_0_tb   <= '1';
            wait for clock_period;
            clk_tb <= '1';
            wait for clock_period;
            clk_tb <= '0';
            sel_tb <= '0';
            inp_1_tb   <= '1';
            inp_0_tb   <= '0';
            wait for clock_period;
            clk_tb <= '1';
            wait for clock_period;
            clk_tb <= '0';
            sel_tb <= '0';
            inp_1_tb   <= '1';
            inp_0_tb   <= '1';
            wait for clock_period;
            clk_tb <= '1';
            wait for clock_period;
            clk_tb <= '1';
            sel_tb <= '1';
            inp_1_tb   <= '0';
            inp_0_tb   <= '0';
            wait for clock_period;
            clk_tb <= '1';
            wait for clock_period;
            clk_tb <= '0';
            sel_tb <= '1';
            inp_1_tb   <= '0';
            inp_0_tb   <= '1';
            wait for clock_period;
            clk_tb <= '1';
            wait for clock_period;
            clk_tb <= '0';
            sel_tb <= '1';
            inp_1_tb   <= '1';
            inp_0_tb   <= '0';
            wait for clock_period;
            clk_tb <= '1';
            wait for clock_period;
            clk_tb <= '0';
            sel_tb <= '1';
            inp_1_tb   <= '1';
            inp_0_tb   <= '1';
            wait;
        end process;
end Behavioral;       