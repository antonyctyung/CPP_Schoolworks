----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2021 04:42:28 PM
-- Design Name: 
-- Module Name: mux2x1_tb - Behavioral
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

entity mux2x1_tb is
--  Port ( );
end mux2x1_tb;

architecture Behavioral of mux2x1_tb is

    component mux2x1
        Port ( 
            inp_0   :   in    std_logic;
            inp_1   :   in    std_logic;
            sel     :   in    std_logic;
            op      :   out   std_logic
        );
    end component;

    --- internal signals to force inputs and receive ouput from the selected component (MUX2x1)
    signal      tb_inp_1    : std_logic ;
    signal      tb_inp_2    : std_logic ;
    signal      tb_sel      : std_logic ;
    signal      tb_op       : std_logic ;
    constant    tb_time     : time      := 10 ns;

begin

    MUX_1:  mux2x1 port map (
        inp_0   => tb_inp_1,
        inp_1   => tb_inp_2,
        sel     => tb_sel,
        op      => tb_op
    );

    GEN_TB_SIGNALS: process
        begin
            tb_inp_1 <= '1'; -- 1'b1; in verilog
            tb_inp_2 <= '0';
            tb_sel   <= '1';
            wait for tb_time;
            tb_inp_1 <= '1'; -- 1'b1; in verilog
            tb_inp_2 <= '0';
            tb_sel   <= '0';
            wait for tb_time;
            tb_inp_1 <= 'X'; -- 1'b1; in verilog
            tb_inp_2 <= 'X';
            tb_sel   <= 'X';
            wait;               -- loop if without this line
            end process GEN_TB_SIGNALS;

end Behavioral;
