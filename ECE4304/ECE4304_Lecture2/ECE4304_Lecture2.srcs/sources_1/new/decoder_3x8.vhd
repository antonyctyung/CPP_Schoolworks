----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2021 04:48:34 PM
-- Design Name: 
-- Module Name: decoder_3x8 - Lecture_2
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

entity decoder_3x8 is
    Port 
    (
        ---- single bit/wire representation
        --s_0: in std_logic;
        --s_1: in std_logic;
        --s_2: in std_logic;\
        clk: in std_logic;
        rst: in std_logic;
        s: in std_logic_vector(2 downto 0); --- input ports (same category)
        p: out std_logic_vector(7 downto 0) --- output ports (same category)
    );
end decoder_3x8;



architecture Lecture_2 of decoder_3x8 is

constant zeros_7:std_logic_vector(6 downto 0) := (others => '0');
constant zeros_6:std_logic_vector(5 downto 0) := (others => '0');
constant zeros_5:std_logic_vector(4 downto 0) := (others => '0');
constant zeros_4:std_logic_vector(3 downto 0) := (others => '0');
constant zeros_3:std_logic_vector(2 downto 0) := (others => '0');
constant zeros_2:std_logic_vector(1 downto 0) := (others => '0');
constant zeros_1:std_logic_vector(0 downto 0) := (others => '0');

-- signal x: std_logic_vector(7 downto 0);

begin

    DECOD: process(clk, rst, s) -- process(all) equiv to alwyas(*) in verilog, not supported universally
        variable x: std_logic_vector(7 downto 0):=x"00"; -- x"00" is 8-bit 0 in hex
    begin
        if (rst = '1') then
            x := (others => '0');
        elsif (rising_edge(clk)) then

                case s is
                -- when "000" => p <= zeros_7 & '1'; -- "00000001"; with concat
                -- when "001" => p <= zeros_6 & '1' & ; -- "00000001"; with concat
                -- when "010" => p <= zeros_5 & '1'; -- "00000001"; with concat
                -- when "011" => p <= zeros_4 & '1'; -- "00000001"; with concat
                -- when "100" => p <= zeros_3 & '1'; -- "00000001"; with concat
                -- when "101" => p <= zeros_2 & '1'; -- "00000001"; with concat
                -- when "110" => p <= zeros & '1'; -- "00000001"; with concat
                -- when "111" => p <= zeros & '1'; -- "00000001"; with concat
                when others => p <= (others => 'Z'); -- "ZZZZZZZZ"; -- default: in verilog
                end case;
        end if;
        p<=x;
    end process;

end Lecture_2;
