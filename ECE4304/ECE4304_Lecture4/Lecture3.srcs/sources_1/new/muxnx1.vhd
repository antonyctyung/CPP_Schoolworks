----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/15/2021 04:32:51 PM
-- Design Name: 
-- Module Name: muxnx1 - Behavioral
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
use IEEE.math_real."log2";
use IEEE.math_real."ceil";

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity muxnx1 is
    generic (WIDTH:integer := 16);
    Port ( 
        Muxnx1_sel: in STD_LOGIC;
        Muxnx1_inp: in STD_LOGIC_VECTOR(integer(ceil(log2(real(WIDTH))))-1 downto 0);
        Muxnx1_op: out STD_LOGIC
    );
end muxnx1;

architecture Behavioral of muxnx1 is

    signal tmp_muxnx1: std_logic_vector(WIDTH-3 downto 0);

begin


end Behavioral;
