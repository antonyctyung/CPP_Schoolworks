----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/15/2021 04:30:53 PM
-- Design Name: 
-- Module Name: mux2x1 - Behavioral
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

entity mux2x1 is
    Port ( sel : in STD_LOGIC;
           inp_0 : in STD_LOGIC;
           inp_1 : in STD_LOGIC;
           op : out STD_LOGIC);
end mux2x1;

architecture Behavioral of mux2x1 is

begin

    op <= (sel and inp_1) or ((not sel) and inp_0);

end Behavioral;
