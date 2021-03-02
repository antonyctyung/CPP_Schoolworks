----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2021 04:52:39 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    generic(top_WIDTH:integer:=8);
  Port (
      top_clk: in std_logic;
      top_rst: in std_logic;
      load: in std_logic;
      top_inp: in std_logic_vector(top_WIDTH-1 downto 0)
   );
end top;

architecture Behavioral of top is

    component clk_wiz_0
    Port (
        clk_sys: in std_logic;
        reset: in std_logic;
        locked: out std_logic;
        clk_out1: out std_logic
    );
    end component;

    signal pll_lock: std_logic;
    signal pll_clk_tmp: std_logic;
    signal stable_clock: std_logic;

begin

    CLK_GEN: clk_wiz_0  port map (
        clk_sys  => top_clk,
        reset    => pll_rst,
        locked   => pll_lock,
        clk_out1 => pll_clk_tmp
    );

    stable_clock <= pll_clk_tmp and pll_lock;

end Behavioral;
