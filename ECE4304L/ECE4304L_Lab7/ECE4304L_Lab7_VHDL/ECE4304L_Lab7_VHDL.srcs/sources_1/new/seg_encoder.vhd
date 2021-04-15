----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2019 05:49:32 PM
-- Design Name: 
-- Module Name: 7_seg_encoder - Behavioral
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

entity seg_encoder is
    Port ( s : in STD_LOGIC_VECTOR (3 downto 0);
           dig : out STD_LOGIC_VECTOR (6 downto 0));
end seg_encoder;

architecture Behavioral of seg_encoder is

begin

ENCODER:process(s)
        begin 
           CASE_ENCODER: case s is 
            when "0000" => dig <= "1111110";
            when "0001" => dig <= "1100000";
            when "0010" => dig <= "1011011";
            when "0011" => dig <= "1110011";
            when "0100" => dig <= "1100101";
            when "0101" => dig <= "0110111";
            when "0110" => dig <= "0111111";
            when "0111" => dig <= "1100010";
            when "1000" => dig <= "1111111";
            when "1001" => dig <= "1110111";
            when "1010" => dig <= "0000000";
            when "1011" => dig <= "0000000";
            when "1100" => dig <= "0000000";
            when "1101" => dig <= "0000000";
            when "1110" => dig <= "0000000";
            when "1111" => dig <= "0000000";
            when others => dig <= (others =>'Z'); 
            end case CASE_ENCODER; 
        end process ENCODER; 
end Behavioral;
