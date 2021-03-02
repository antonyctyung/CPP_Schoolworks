----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2021 05:30:18 PM
-- Design Name: 
-- Module Name: gcounter_tb - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gcounter_tb is
    generic (C_WIDTH_TB:integer:=8);
--  Port ( );
end gcounter_tb;

architecture Behavioral of gcounter_tb is

    component generic_counter is
        generic(C_WIDTH:integer:=4);
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               load : in STD_LOGIC;
               ud : in STD_LOGIC;
               i_cont: in STD_LOGIC_VECTOR(C_WIDTH-1 downto 0);
               count : out STD_LOGIC_VECTOR (C_WIDTH-1 downto 0));
    end component;

    constant clock_period:time:=10ns;

    -- Injecting the input vectors into the assigned ports

    signal clk_tb: std_logic;
    signal rst_tb: std_logic;
    signal  ud_tb: std_logic;
    
    -- receiving the outputs which belongs to the assinged inputs

    signal count_tb: std_logic_vector(C_WIDTH_TB-1 downto 0);

begin

    -- Generated 100 MHz
    CLOCK_GEN: process
    begin
        clk_tb <='1';
        wait for clock_period/2;
        clk_tb <='0';
        wait for clock_period/2;
    end process;

    GCOUNT: generic_counter
        generic map (C_WIDTH => C_WIDTH_TB)
        port map (
            clk => clk_tb,
            rst => rst_tb,
             ud =>  ud_tb,
            count => count_tb
        );

    TST_CASE_1: process
    begin
        rst_tb <= '1';
         ub_tb <= '0';
        wait for clock_period;
        rst_tb <= '0';
        
        while (count_tb < 15) loop
            ud_tb <= '0';
            wait for clock_period;
        end loop;
        
        while (count_tb > 15) loop
            ud_tb <= '1';
            wait for clock_period;
        end loop;
        wait;
    end process;

end Behavioral;
