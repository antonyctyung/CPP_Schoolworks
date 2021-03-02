----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2021 02:02:32 PM
-- Design Name: 
-- Module Name: BCDdec_TB - Behavioral
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

entity BCDdec_TB is
--  Port ( );
end BCDdec_TB;

architecture Behavioral of BCDdec_TB is

    component BCDdec is
        Port ( B : in STD_LOGIC_VECTOR (3 downto 0);
               P : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    signal B_tb  : std_logic_vector(3 downto 0);
    Signal P_tb  :  std_logic_vector(3 downto 0);
    constant tb_time : time:= 10ns;

begin

    BDEC: BCDdec  port map ( 
        B => B_tb,
        P =>P_tb
        );

    TEST_Signal: process -- like always block
    begin 
        B_tb  <= "0000";
        wait for tb_time;  
        B_tb <= "0001";
        wait for tb_time;
        B_tb <= "0010";
        wait for tb_time; 
         B_tb  <= "0011";
        wait for tb_time;
        B_tb <= "0100";
        wait for tb_time;
        B_tb <= "0101";
        wait for tb_time;
         B_tb  <= "0110";
        wait for tb_time;
        B_tb <= "0111";
        wait for tb_time;
        B_tb <= "1000";
        wait for tb_time;
          B_tb <= "1001";
        wait for tb_time;
        B_tb <= "1010";
        wait for tb_time;
         B_tb  <= "1011";
        wait for tb_time;
        B_tb <= "1100";
        wait for tb_time;
        B_tb <= "1101";
        wait for tb_time;
        B_tb <= "1110";
        wait for tb_time;
        B_tb <= "1111";
        wait for tb_time;
        wait;
    end process;

end Behavioral;
