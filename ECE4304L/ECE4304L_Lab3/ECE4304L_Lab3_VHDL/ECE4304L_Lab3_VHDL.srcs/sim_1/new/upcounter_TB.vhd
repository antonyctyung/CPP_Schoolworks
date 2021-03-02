----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2021 01:53:56 PM
-- Design Name: 
-- Module Name: upcounter_TB - Behavioral
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

entity upcounter_TB is
    generic(N_TB:integer:=18);
--  Port ( );
end upcounter_TB;

architecture Behavioral of upcounter_TB is

    signal clk_TB:  std_logic;
    signal rst_TB:  std_logic;
    signal cnt_TB:  std_logic_vector(N_TB-1 downto 0);
    
    constant clock_period: time:= 10 ns;

    component upcounter is
        generic(WIDTH:integer:=18);
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (WIDTH-1 downto 0));
    end component;

begin

    CNT_GEN: upcounter
        generic map(WIDTH => N_TB)
        port map(
            clk => clk_TB,
            rst => rst_TB,
            Q => cnt_TB
        );

    CLK_GEN: process
    begin
        clk_TB <= '0';
        wait for clock_period;
        clk_TB <= '1';
        wait for clock_period;
    end process;

    TB_GEN: process
    begin
        rst_TB <='1';
        wait for 2*clock_period;
        rst_TB <='0';
        wait;
    end process;

end Behavioral;
