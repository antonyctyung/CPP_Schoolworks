----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2021 05:26:46 PM
-- Design Name: 
-- Module Name: mux4bits8x1 - Behavioral
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

entity muxNbits8x1 is
   generic(N:integer:=4);
  Port (
      x0 : in std_logic_vector(N-1 downto 0); 
      x1 : in std_logic_vector(N-1 downto 0); 
      x2 : in std_logic_vector(N-1 downto 0); 
      x3 : in std_logic_vector(N-1 downto 0); 
      x4 : in std_logic_vector(N-1 downto 0); 
      x5 : in std_logic_vector(N-1 downto 0); 
      x6 : in std_logic_vector(N-1 downto 0); 
      x7 : in std_logic_vector(N-1 downto 0); 
      sel: in std_logic_vector(2 downto 0); 
      y  :out std_logic_vector(N-1 downto 0)
   );
end muxNbits8x1;

architecture Behavioral of muxNbits8x1 is

begin

   MAIN: process(sel, x0, x1, x2,x3,x4,x5,x6,x7)
   begin
   case sel is
      when "000" => y <= x0;
      when "001" => y <= x1;
      when "010" => y <= x2;
      when "011" => y <= x3;
      when "100" => y <= x4;
      when "101" => y <= x5;
      when "110" => y <= x6;
      when "111" => y <= x7;
      when others => y <= (others => 'Z');
   end case;
   end process;

end Behavioral;
