----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2021 03:36:58 PM
-- Design Name: 
-- Module Name: hex7seg - Behavioral
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

entity hex7seg is
    Port ( digit : in STD_LOGIC_VECTOR (3 downto 0);
           a_to_g : out STD_LOGIC_VECTOR (6 downto 0)); -- (CA downto CG)
end hex7seg;

-- architecture ROM of hex7seg is

-- begin
    
--     Cases: process(digit)
--     begin
--         case digit is
--             when "0000" => a_to_g <= "0000001";
--             when "0001" => a_to_g <= "1001111";
--             when "0010" => a_to_g <= "0010010";
--             when "0011" => a_to_g <= "0000110";
--             when "0100" => a_to_g <= "1001100";
--             when "0101" => a_to_g <= "0100100";
--             when "0110" => a_to_g <= "0100000";
--             when "0111" => a_to_g <= "0001111";
--             when "1000" => a_to_g <= "0000000";
--             when "1001" => a_to_g <= "0000100";
--             when "1010" => a_to_g <= "0001000";
--             when "1011" => a_to_g <= "1100000";
--             when "1100" => a_to_g <= "0110001";
--             when "1101" => a_to_g <= "1000010";
--             when "1110" => a_to_g <= "0110000";
--             when "1111" => a_to_g <= "0111000";
--             when others => a_to_g <= (others => '1');
--         end case;
--     end process;
    
-- end ROM;

architecture Gate_level of hex7seg is

    signal A:std_logic := digit(3);
    signal B:std_logic := digit(2);
    signal C:std_logic := digit(1);
    signal D:std_logic := digit(0);
    signal nA:std_logic := not(digit(3));
    signal nB:std_logic := not(digit(2));
    signal nC:std_logic := not(digit(1));
    signal nD:std_logic := not(digit(0));

begin
    
    a_to_g(6) <= (nA and B and nC and nD) or (A and B and C and D) or (nB and nC and D);
    a_to_g(5) <= (nA and B  and nC and D) or (A and C and D) or (B and C and nD) or (A and B and nD);
    a_to_g(4) <= (nB and C and nD) or (A and nB and C) or (A and nB and nD);     
    a_to_g(3) <= (nA and B and nC and nD) or (nA and nB and nC and D) or (A and nB and C and nD) or (B and C and D);    
    a_to_g(2) <= (nB and nC and D) or (nA and B and nC) or (nA and D);    
    a_to_g(1) <= (A and B and nC and D) or (nA and C and D) or (nA and nB and D) or (nA and nB and C);    
    a_to_g(0) <= (A and B and nC and nD) or (nA and B and C and D) or (nA and nB and nC);   

end Gate_level;
    