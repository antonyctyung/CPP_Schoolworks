----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2021 06:31:34 PM
-- Design Name: 
-- Module Name: top_tb - Behavioral
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

entity top_tb is
    generic(top_WIDTH_TB:integer:= 4); 
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is

component top 
    generic (top_WIDTH:integer:= 4);
    Port ( 
            top_clk      : in std_logic; 
            top_rst      : in std_logic; 
            top_inst     : in std_logic_vector(4 downto 0); 
            top_port_A   : in std_logic_vector(top_WIDTH-1 downto 0); 
            top_port_B   : in std_logic_vector(top_WIDTH-1 downto 0); 
            top_port_out : out std_logic_vector(top_width-1 downto 0);
            top_port_cout: out std_logic
         );
end component;

constant clock_period: time:=10 ns; 

signal top_clk_tb: std_logic; 
signal top_rst_tb: std_logic; 

signal top_inst_tb: std_logic_vector(4 downto 0); 

signal top_port_A_tb: std_logic_vector(top_WIDTH_TB-1 downto 0); 
signal top_port_B_tb: std_logic_vector(top_WIDTH_TB-1 downto 0); 
signal top_port_out_tb: std_logic_vector(top_WIDTH_TB-1 downto 0); 
signal top_port_count: std_logic; 


begin

TOP_COMP: top generic map (top_WIDTH => top_WIDTH_TB)
              port    map (
                            top_clk       => top_clk_tb,
                            top_rst       => top_rst_tb,
                            top_inst      => top_inst_tb,
                            top_port_A    => top_port_A_tb,
                            top_port_B    => top_port_B_tb,
                            top_port_out  => top_port_out_tb,
                            top_port_cout => top_port_count   -- if you don't want this port anymore replace the signal connected to it by using open phrase there 
                          ); 
                          
CLK_GEN: process
         begin 
            top_clk_tb <= '1';
            wait for clock_period/2; 
            top_clk_tb <= '0'; 
            wait for clock_period/2; 
         end process; 


TST_CASE_1: process
            begin 
                top_rst_tb <= '1'; 
                top_inst_tb <=(others =>'0'); 
                
                wait for clock_period; 
                top_rst_tb <='0'; 
                top_port_A_tb <= x"5";
                top_port_B_tb <= x"7"; 
                top_inst_tb <= "1010X";
                wait for clock_period; 
                top_inst_tb <= "00000";
                wait; 
                
            end process; 


end Behavioral;
