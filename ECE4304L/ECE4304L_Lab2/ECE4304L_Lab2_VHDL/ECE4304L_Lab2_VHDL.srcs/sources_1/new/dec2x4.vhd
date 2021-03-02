----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2021 02:01:17 PM
-- Design Name: 
-- Module Name: dec2x4 - Behavioral
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

entity dec2x4 is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        s: in std_logic_vector(1 downto 0);
        p: out std_logic_vector (3 downto 0)
    );
end dec2x4;

architecture Behavioral of dec2x4 is

begin

    DECOD: process(clk, rst) -- process(all) equiv to alwyas(*) in verilog, not supported universally
    begin
        if (rst = '1') then
            p <= (others => '0');
        elsif (rising_edge(clk)) then
            case s is
                when "00" => p <= "0001";
                when "01" => p <= "0010";
                when "10" => p <= "0100";
                when "11" => p <= "1000";
                when others => p <= (others => 'Z'); -- "ZZZZZZZZ"; -- default: in verilog
            end case;
        end if;
    end process;

end Behavioral;
