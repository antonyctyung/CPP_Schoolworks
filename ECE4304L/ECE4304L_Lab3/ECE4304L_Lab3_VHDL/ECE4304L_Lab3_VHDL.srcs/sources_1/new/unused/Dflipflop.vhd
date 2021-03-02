----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2021 04:03:26 PM
-- Design Name: 
-- Module Name: Dflipflop - Behavioral
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

entity Dflipflop is
    Port ( D   : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Q   : out STD_LOGIC);
end Dflipflop;

------ASYNC RESET 1 LLUT 2 FFs
-- architecture Behavioral of Dflipflop is

-- begin

--     DFF: process(clk, rst)
--     begin
--         if (rst = '1') then
--             Q <= '0';
--             nQ <= '1';
--         elsif (rising_edge(clk)) then
--             if (D = '1') then
--                 Q <= '1';
--                 nQ <= '0';
--             else
--                 Q <= '0';
--                 nQ <= '1';
--             end if;
--         end if; 
--     end process;

-- end Behavioral;

architecture Behavioral of Dflipflop is

    signal tmp_Q: std_logic;

begin

    DFF: process(clk, rst)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then tmp_Q <= '0'; 
            elsif (D = '1') then tmp_Q <= '1';
            else tmp_Q <= '0';
            end if;
        end if; 
    end process;

    Q <= tmp_Q;

end Behavioral;