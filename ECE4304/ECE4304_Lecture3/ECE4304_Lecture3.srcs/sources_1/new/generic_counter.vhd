----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2021 05:13:47 PM
-- Design Name: 
-- Module Name: generic_counter - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity generic_counter is
    generic(C_WIDTH:integer:=4);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           load : in STD_LOGIC;
           ud : in STD_LOGIC;
           i_cont: in STD_LOGIC_VECTOR(C_WIDTH-1 downto 0);
           count : out STD_LOGIC_VECTOR(C_WIDTH-1 downto 0)
           );
end generic_counter;

architecture Behavioral of generic_counter is

begin

    GEN_COUNT: process(clk,rst)
        variable v_count: std_logic_vector(C_WIDTH-1 downto 0);
    begin
        if (rst = '1') then
            if (ud = '0') then
                v_count := (others => '0');
            else 
                v_count := (others => '1');
            end if;
        elsif (rising_edge(clk)) then
            if (load = '1') then
                v_count := i_cont;
            else
                if (ud = '1') then
                    v_count := v_count - '1';
                else
                    v_count := v_count + '1';
                end if;
            end if;
        end if;
        count <= v_count;
    end process;

end Behavioral;
