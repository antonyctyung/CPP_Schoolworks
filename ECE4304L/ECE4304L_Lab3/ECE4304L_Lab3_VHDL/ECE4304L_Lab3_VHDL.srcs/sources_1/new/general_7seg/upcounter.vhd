----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2021 05:07:58 PM
-- Design Name: 
-- Module Name: upcounter - Behavioral
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

entity upcounter is
    generic(WIDTH:integer:=18);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (WIDTH-1 downto 0));
end upcounter;

architecture Behavioral of upcounter is

    signal Q_buf: STD_LOGIC_VECTOR (WIDTH-1 downto 0);

begin

    MAIN: process(clk, rst)
    begin
        if (rst = '1') then
            Q_buf <= (others => '0');
        elsif (rising_edge(clk)) then
            Q_buf <= Q_buf+1;
        end if;
    end process;
    
    Q <= Q_buf;

end Behavioral;
