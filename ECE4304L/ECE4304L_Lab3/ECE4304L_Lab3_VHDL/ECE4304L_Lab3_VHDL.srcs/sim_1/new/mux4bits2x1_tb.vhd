----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2021 02:19:42 PM
-- Design Name: 
-- Module Name: mux4bits2x1_tb - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux4bits2x1_tb is
--  Port ( );
end mux4bits2x1_tb;

architecture Behavioral of mux4bits2x1_tb is

    component mux4bits2x1 is
        Port (
            x0  : in std_logic_vector(3 downto 0); 
            x1  : in std_logic_vector(3 downto 0); 
            sel : in std_logic;
            y   : out std_logic_vector(3 downto 0)
        );
    end component;

    signal x0_tb  : std_logic_vector(3 downto 0) := (others => '0'); 
    signal x1_tb  : std_logic_vector(3 downto 0) := (others => '0'); 
    signal sel_tb : std_logic;
    signal y_tb   : std_logic_vector(3 downto 0);

    constant tb_time:time := 10ns;

begin

    GEN_MUX: mux4bits2x1
        port map(
            x0 => x0_tb,
            x1 => x1_tb,
            sel => sel_tb,
            y => y_tb
        );

    SWITCH: process
    begin
        sel_tb <= '0';
        wait for tb_time;
        sel_tb <= '1';
        wait for tb_time;
    end process;

    X0GEN: process
    begin
        wait for 2*tb_time;
        x0_tb <= x0_tb + 1;
    end process;

    X1GEN: process
    begin
        wait for 32*tb_time;
        x1_tb <= x1_tb + 1;
    end process;

end Behavioral;
