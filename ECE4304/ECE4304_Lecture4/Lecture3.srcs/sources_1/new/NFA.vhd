----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/03/2021 04:29:10 PM
-- Design Name: 
-- Module Name: NFA - NFA_ARCH
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

entity NFA is
       generic (WIDTH:integer:= 4); 
       Port (
              NFA_CIN      : in  std_logic; 
              NFA_PORT_A   : in  std_logic_vector(WIDTH-1 downto 0); 
              NFA_PORT_B   : in  std_logic_vector(WIDTH-1 downto 0); 
              NFA_PORT_Sum : out std_logic_vector(WIDTH-1 downto 0); 
              NFA_PORT_COUT: out std_logic     
            );
end NFA;

architecture NFA_ARCH of NFA is

component FA 
           Port ( 
                  sel: in  std_logic; 
                  Cin: in  std_logic; 
                  A  : in  std_logic; 
                  B  : in  std_logic; 
                Sum  : out std_logic; 
                Cout : out std_logic  
                );
end component;

signal Internal_carry: std_logic_vector(WIDTH downto 0); 

begin
Internal_carry(0) <= NFA_CIN; 

    GEN_WRAPPER: for i in 0 to WIDTH-1 generate 

        SINGFA: FA port map (
                              sel => Internal_carry(0),
                              A   => NFA_PORT_A(i),
                              Cin => Internal_carry(i),
                              B   => NFA_PORT_B(i),
                             Sum  => NFA_PORT_Sum(i),
                             Cout => Internal_carry(i+1)
                            );
      end generate;   

    NFA_PORT_COUT <= Internal_carry(WIDTH); 


end NFA_ARCH;
