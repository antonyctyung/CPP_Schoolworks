----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2021 02:07:56 PM
-- Design Name: 
-- Module Name: hex7seg_tb - Behavioral
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

entity hex7seg_tb is
--  Port ( );
end hex7seg_tb;

architecture Behavioral of hex7seg_tb is

    component hex7seg is
        Port ( digit : in STD_LOGIC_VECTOR (3 downto 0);
               a_to_g : out STD_LOGIC_VECTOR (6 downto 0)); -- (CA downto CG)
    end component;

    signal digit_tb: std_logic_vector(3 downto 0) := (others => '0');
    signal a_to_g_tb: std_logic_vector(6 downto 0);
    constant tb_time : time:= 10ns;

begin

    uut: hex7seg port map (
        digit => digit_tb,
        a_to_g => a_to_g_tb
    );

    TEST2: process 
    begin
        digit_tb <= "0000"; 
        wait for tb_time;
        digit_tb <= "0001"; 
        wait for tb_time;
        digit_tb<= "0010";
        wait for tb_time;
        digit_tb <= "0011";
        wait for tb_time;
        digit_tb<= "0100";
        wait for tb_time;
        digit_tb<= "0101";
        wait for tb_time;
        digit_tb<= "0110";
        wait for tb_time;
        digit_tb<= "0111";
        wait for tb_time;
        digit_tb <= "1000";
        wait for tb_time;
        digit_tb<= "1001";
        wait for tb_time;
        digit_tb<= "1010";
        wait for tb_time; 
        digit_tb<= "1011";
        wait for tb_time; 
        digit_tb<= "1100"; 
        wait for tb_time;
        digit_tb<= "1101"; 
        wait for tb_time;
        digit_tb<= "1110"; 
        wait for tb_time;
        digit_tb<= "1111"; 
        wait for tb_time;
        wait;
    end process;

end Behavioral;
