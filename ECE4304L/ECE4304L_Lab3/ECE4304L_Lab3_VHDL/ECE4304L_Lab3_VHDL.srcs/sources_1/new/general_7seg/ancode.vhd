----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2021 05:45:13 PM
-- Design Name: 
-- Module Name: ancode - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ancode is
    Port (
        s: in std_logic_vector(2 downto 0);
        aen: in std_logic_vector(7 downto 0);
        an: out std_logic_vector(7 downto 0)
    );
end ancode;

architecture Behavioral of ancode is

begin

    MAIN: process(s, aen)
    begin
        an <= (others => '1');
        an(to_integer(unsigned(s))) <= not(aen(to_integer(unsigned(s))));
    end process;

end Behavioral;
