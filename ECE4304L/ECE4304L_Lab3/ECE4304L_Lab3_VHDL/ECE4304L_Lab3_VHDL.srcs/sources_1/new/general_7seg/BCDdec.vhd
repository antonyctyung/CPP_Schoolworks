----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2021 02:39:03 PM
-- Design Name: 
-- Module Name: BCDdec - Gate-level
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
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BCDdec is
    Port ( B : in STD_LOGIC_VECTOR (3 downto 0);
           P : out STD_LOGIC_VECTOR (3 downto 0));
end BCDdec;

-- architecture Adding of BCDdec is

-- begin

--     Adding: process(B)
--     begin
--         P <= B when (to_integer(unsigned(B)) < 10) else std_logic_vector(to_unsigned(to_integer(unsigned(B)) - 10,B'length));
--     end process;

-- end Adding;

-- architecture ROM of BCDdec is

-- begin
    
--     Cases: process(B)
--     begin
--         case B is
--             when "1010" => P <= "0000";
--             when "1011" => P <= "0001";
--             when "1100" => P <= "0010";
--             when "1101" => P <= "0011";
--             when "1110" => P <= "0100";
--             when "1111" => P <= "0101";
--             when others => P <= B;
--         end case;
--     end process;
    
-- end ROM;

architecture Gate_level of BCDdec is

begin

    P(3) <= B(3) and not(B(2) or B(1));
    P(2) <= B(2) and (not(B(3)) or B(1));
    P(1) <= (B(3) and B(2) and not(B(1))) or (not(B(3)) and B(1));
    P(0) <= B(0);

end Gate_level;
