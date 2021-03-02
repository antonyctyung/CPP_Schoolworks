----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2021 04:01:24 PM
-- Design Name: 
-- Module Name: clockdiv - Behavioral
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

entity clockdiv is
    generic(N:integer:=18);
    Port (
        clk_in      :   in  std_logic;
        clkdiv_rst  :   in  std_logic;
        Q           :   out std_logic(N-1 downto 0);
        clk_out     :   out std_logic
    );
end clockdiv;

architecture Behavioral of clockdiv is

    component Dflipflop is
        Port ( D   : in STD_LOGIC;
               clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               Q   : out STD_LOGIC);
    end component;
    signal int_sig: std_logic_vector(N downto 0);

begin

    GEN_WRAPPER: for i in 0 to N-1 generate
    DFF: DFlipflop 
    port map(
        D => not(int_sig(i+1)),
        clk => int_sig(i),
        rst => clkdiv_rst,
        Q => int_sig(i+1)
    );
    end generate;

    int_sig(0) <= clk_in;
    clk_out <= int_sig(N);

end Behavioral;
