----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2021 04:57:05 PM
-- Design Name: 
-- Module Name: clockdiv_tb - Behavioral
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

entity top_tb_TEXTIO is
--  Port ( );
end top_tb_TEXTIO;

architecture Behavioral of top_tb_TEXTIO is

    component top is
        Port (
            top_clk: in std_logic;
            top_x0: in std_logic_vector(3 downto 0);
            top_x1: in std_logic_vector(3 downto 0);
            top_a_to_g: out std_logic_vector(6 downto 0); -- MSB(abcdefg)LSB
            top_an: out std_logic_vector(7 downto 0);
            top_dp: out std_logic
        );
    end component;

    signal top_tb_clk:      std_logic;
    signal top_tb_x0:       std_logic_vector(3 downto 0);
    signal top_tb_x1:       std_logic_vector(3 downto 0);
    signal top_tb_a_to_g:   std_logic_vector(6 downto 0); -- MSB(abcdefg)LSB
    signal top_tb_an:       std_logic_vector(7 downto 0);
    signal top_tb_dp:       std_logic;

    constant clock_period:time:=10 ps;

    file file_vectors: text;
    file file_results: text;

begin

    TOP_GEN: top
    port map(
        top_clk => top_tb_clk,
        top_x0 => top_tb_x0,
        top_x1 => top_tb_x1,
        top_a_to_g => top_tb_a_to_g,
        top_an => top_tb_an,
        top_dp => top_tb_dp
    );

    CLK_GEN: process
    begin
        top_tb_clk <= '0';
        wait for clock_period;
        top_tb_clk <= '1';
        wait for clock_period;
    end process;

    TEXTIO_GEN: process
            variable v_ILINE: line;
            variable v_OLINE: line;
            
            variable v_INP0   : std_logic_vector(3 downto 0);
            variable v_INP1   : std_logic_vector(3 downto 0);
            variable v_space : character;
            begin
            
            file_open(file_vectors,"D:\Documents\workspace\CPP_Schoolworks\ECE4304L\ECE4304L_Lab3\ECE4304L_Lab3_VHDL\scripts\input.txt", read_mode);     
            file_open(file_results,"D:\Documents\workspace\CPP_Schoolworks\ECE4304L\ECE4304L_Lab3\ECE4304L_Lab3_VHDL\scripts\output.txt" , write_mode);
            while not endfile(file_vectors) loop 
                readline(file_vectors, v_ILINE); 
                read(v_ILINE, v_INP0);  
                read(v_ILINE, v_SPACE); 
                read(v_ILINE, v_INP1);
                
                top_tb_x0 <= v_INP0;
                top_tb_x1 <= v_INP1;
                
                wait for (2**18)*clock_period; 
                
                write(v_OLINE, v_INP0);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, v_INP1);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, top_tb_a_to_g);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, top_tb_an);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, top_tb_dp);

                writeline(file_results, v_OLINE);

                wait for (2**18)*clock_period; 
                
                write(v_OLINE, v_INP0);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, v_INP1);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, top_tb_a_to_g);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, top_tb_an);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, top_tb_dp);

                writeline(file_results, v_OLINE);

                wait for (2**18)*clock_period; 
                
                write(v_OLINE, v_INP0);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, v_INP1);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, top_tb_a_to_g);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, top_tb_an);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, top_tb_dp);

                writeline(file_results, v_OLINE);
            
            end loop; 
            file_close(file_vectors); 
            file_close(file_results);     
            
            wait;
            end process;

end Behavioral;
