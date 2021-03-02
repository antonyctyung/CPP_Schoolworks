----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2021 06:11:29 PM
-- Design Name: 
-- Module Name: mux4bits2x1 - Behavioral
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

entity mux4bits2x1 is
    Port (
        x0  : in std_logic_vector(3 downto 0); 
        x1  : in std_logic_vector(3 downto 0); 
        sel : in std_logic;
        y   : out std_logic_vector(3 downto 0)
    );
end mux4bits2x1;

architecture Behavioral of mux4bits2x1 is

begin

    MAIN: process(x0,x1,sel)
    begin
        if (sel = '0') then
            y <= x0;
        else
            y <= x1;
        end if;
    end process;

end Behavioral;
