----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/03/2021 04:17:47 PM
-- Design Name: 
-- Module Name: FA - SFA
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FA is
    Port (
        sel :   in  std_logic;
        Cin :   in  std_logic;
        A   :   in  std_logic;
        B   :   in  std_logic;
        Sum :   out std_logic;
        Cout:   out std_logic
    );
end FA;

architecture SFA of FA is

signal tmp:std_logic;

begin

    tmp     <= B xor sel;
    Sum     <= A xor tmp xor Cin;
    Cout    <= (A and tmp) or (A and Cin) or (tmp and Cin);

end SFA;
