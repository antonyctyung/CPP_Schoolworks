----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2021 09:38:05 AM
-- Design Name: 
-- Module Name: decoder8bit - Behavioral
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

entity decoder8bit is
    Port ( 
        x: in  std_logic_vector(2 downto 0);        
        y: out std_logic_vector(7 downto 0)        
    );
end decoder8bit;

architecture Behavioral of decoder8bit is

begin

    MAIN:process(x)
    begin
        y <= (others => '0');
        y(conv_integer(x)) <= '1';
    end process;

end Behavioral;
