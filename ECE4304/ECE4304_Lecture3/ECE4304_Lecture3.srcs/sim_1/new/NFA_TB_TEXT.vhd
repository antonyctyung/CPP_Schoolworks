----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/03/2021 04:51:59 PM
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
use STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NFA_TB_TEXTIO is
    generic(WIDTH_TB:integer:=8);
--  Port ( );
end NFA_TB_TEXTIO;

architecture TESTING of NFA_TB_TEXTIO is

component NFA is
    
    generic (WIDTH:integer:=256);
    Port ( 
        NFA_Cin    :   in  std_logic;
        NFA_PORT_A      :   in  std_logic_vector(WIDTH-1 downto 0);
        NFA_PORT_B      :   in  std_logic_vector(WIDTH-1 downto 0);
        NFA_PORT_Sum    :   out std_logic_vector(WIDTH-1 downto 0);
        NFA_PORT_COUT   :   in  std_logic
    );

end component;

signal  NFA_Cin_TB          :   std_logic;
signal  NFA_PORT_A_TB       :   std_logic_vector(WIDTH_TB-1 downto 0);
signal  NFA_PORT_B_TB       :   std_logic_vector(WIDTH_TB-1 downto 0);
signal  NFA_PORT_Sum_TB     :   std_logic_vector(WIDTH_TB-1 downto 0);
signal  NFA_PORT_COUT_TB    :   std_logic;

constant clock_period: time := 10 ns;

file file_vectors: text;
file file_results: text;

begin

    NFA_GEN:    NFA
        generic map (WIDTH => WIDTH_TB)
        port map (
            NFA_Cin          =>  NFA_Cin_TB,
            NFA_PORT_A       =>  NFA_PORT_A_TB,
            NFA_PORT_B       =>  NFA_PORT_B_TB,
            NFA_PORT_Sum     =>  NFA_PORT_Sum_TB,
            NFA_PORT_Cout    =>  NFA_PORT_COUT_TB        
        );

    TEXTIO_GEN: process    
        variable v_ILINE: line;
        variable v_OLINE: line;
        variable v_PORTA: std_logic_vector(WIDTH_TB downto 0);
        variable v_PORTB: std_logic_vector(WIDTH_TB downto 0);
        variable v_space: character;
    begin
        file_open(file_vectors, "D:\Documents\workspace\CPP_Schoolworks\ECE4304\ECE4304_Lecture3\ECE4304_Lecture3.srcs\sim_1\new\input.txt" , read_mode);
        file_open(file_results, "D:\Documents\workspace\CPP_Schoolworks\ECE4304\ECE4304_Lecture3\ECE4304_Lecture3.srcs\sim_1\new\output.txt" , write_mode);
        while not endfile(file_vectors) loop
            readline(file_vectors, v_ILINE);
            hread(v_ILINE,v_PORTA);
            read(v_ILINE, v_SPACE);
            hread(v_ILINE, v_PORTB);
            NFA_PORT_A_TB <= v_PORTA;
            NFA_PORT_B_TB <= v_PORTB;
            wait for 4*clock_period;
            hwrite(v_OLINE, NFA_PORT_SUM_TB);
            writeline(file_results, v_OLINE);
        end loop;
        file_close(file_vectors);
        file_close(file_results);
    end process;

    -- TSB_CS1: process
    -- begin
    --     NFA_CIN_TB <= '0';
    --     NFA_PORT_A_TB <= (others=>'0');
    --     NFA_PORT_B_TB <= (others=>'0');
    --     wait for clock_period;
    --     NFA_PORT_A_TB <= x"55";
    --     NFA_PORT_B_TB <= x"67";
    --     wait for clock_period;
    --     NFA_PORT_A_TB <= x"FF";
    --     NFA_PORT_B_TB <= x"FF";
    --     wait for clock_period;
    --     NFA_PORT_A_TB <= x"00";
    --     NFA_PORT_B_TB <= x"00";
    --     wait for 10*clock_period;
    --     NFA_PORT_A_TB <= x"01";
    --     NFA_PORT_B_TB <= x"10";
    --     wait;
    -- end process;
        

end TESTING;
