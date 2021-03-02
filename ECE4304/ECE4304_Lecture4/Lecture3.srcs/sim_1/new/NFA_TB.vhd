----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/03/2021 04:51:29 PM
-- Design Name: 
-- Module Name: NFA_TB - TESTING
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
use IEEE.NUMERIC_STD.ALL; 
use STD.textio.all; 
use IEEE.std_logic_textio.all; 


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NFA_TB is
       generic(WIDTH_TB:integer:=8); 
--  Port ( );
end NFA_TB;

architecture TESTING of NFA_TB is

component NFA 
       generic (WIDTH:integer:= 256); 
       Port (
              NFA_CIN      : in  std_logic; 
              NFA_PORT_A   : in  std_logic_vector(WIDTH-1 downto 0); 
              NFA_PORT_B   : in  std_logic_vector(WIDTH-1 downto 0); 
              NFA_PORT_Sum : out std_logic_vector(WIDTH-1 downto 0); 
              NFA_PORT_COUT: out std_logic     
            );
end component;


signal NFA_CIN_TB      : std_logic; 
signal NFA_PORT_A_TB   : std_logic_vector(WIDTH_TB-1 downto 0); 
signal NFA_PORT_B_TB   : std_logic_vector(WIDTH_TB-1 downto 0); 
signal NFA_PORT_Sum_TB : std_logic_vector(WIDTH_TB-1 downto 0); 
signal NFA_PORT_COUT_TB: std_logic; 

constant clock_period:time:=10 ns; 

begin


--CLOCK_GEN: process
--           begin 
--            
--           end process; 


    NFA_GEN: NFA 
                generic map (WIDTH => WIDTH_TB)
                port map (
                           NFA_CIN       => NFA_CIN_TB,
                           NFA_PORT_A    => NFA_PORT_A_TB,
                           NFA_PORT_B    => NFA_PORT_B_TB,
                           NFA_PORT_Sum  => NFA_PORT_Sum_TB,
                           NFA_PORT_COUT => NFA_PORT_COUT_TB
                         ); 

   TSB_CS1: process
            begin  
                 NFA_CIN_TB     <= '0';      
                 NFA_PORT_A_TB  <=  (others =>'0'); --x"00";
                 NFA_PORT_B_TB  <=  (others =>'0'); 
              wait for clock_period; 
                NFA_PORT_A_TB  <= x"55";
                NFA_PORT_B_TB  <= x"67";
              wait for clock_period; 
                  NFA_CIN_TB     <= '1';
                  NFA_PORT_A_TB  <= x"FF";
                  NFA_PORT_B_TB  <= x"FF";
              wait for clock_period;
                  NFA_CIN_TB     <= '0'; 
                  NFA_PORT_A_TB  <= x"50";
                  NFA_PORT_B_TB  <= x"60";
              wait for 10*clock_period;                
                  NFA_PORT_A_TB  <= x"01";
                  NFA_PORT_B_TB  <= x"10";
             wait; 
            end process; 

end TESTING;
