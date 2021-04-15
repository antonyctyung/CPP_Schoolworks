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
        PORT (
            top_clk : IN STD_LOGIC;
            top_rst : IN STD_LOGIC;
            top_sel_A : IN STD_LOGIC;
            top_sel_B : IN STD_LOGIC;
            top_opcode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            top_A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            top_B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            top_a_to_g : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            top_an : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            top_dp : OUT STD_LOGIC
          );
    end component;

    signal top_tb_clk :  STD_LOGIC;
    signal top_tb_rst :  STD_LOGIC;
    signal top_tb_sel_A :  STD_LOGIC;
    signal top_tb_sel_B :  STD_LOGIC;
    signal top_tb_opcode :  STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal top_tb_A :  STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal top_tb_B :  STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal top_tb_a_to_g :  STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal top_tb_an :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal top_tb_dp :  STD_LOGIC;

    constant clock_period:time:=10 ns;

    file file_vectors: text;
    file file_results: text;

begin

    TOP_GEN: top
    port map(
        top_clk    => top_tb_clk, 
        top_rst    => top_tb_rst,
        top_sel_A  => top_tb_sel_A,
        top_sel_B  => top_tb_sel_B,
        top_opcode => top_tb_opcode,
        top_A      => top_tb_A,
        top_B      => top_tb_B,
        top_a_to_g => top_tb_a_to_g,
        top_an     => top_tb_an,
        top_dp     => top_tb_dp
    );

    CLK_GEN: process
    begin
        top_tb_clk <= '0';
        wait for clock_period;
        top_tb_clk <= '1';
        wait for clock_period;
    end process;

    INIT_RST: process
    begin
        top_tb_rst <= '1';
        top_tb_rst <= '0';
        wait;
    end process;

    TEXTIO_GEN: process
            variable v_ILINE: line;
            variable v_OLINE: line;
            
            variable v_sel_A :  STD_LOGIC;
            variable v_sel_B :  STD_LOGIC;
            variable v_opcode :  STD_LOGIC_VECTOR(1 DOWNTO 0);
            variable v_A :  STD_LOGIC_VECTOR(3 DOWNTO 0);
            variable v_B :  STD_LOGIC_VECTOR(3 DOWNTO 0);
            variable v_space : character;
            begin
            wait for clock_period;
            file_open(file_vectors,"D:\Documents\workspace\CPP_Schoolworks\ECE4304L\ECE4304L_Lab5\ECE4304L_Lab5_VHDL\scripts\input.txt", read_mode);     
            file_open(file_results,"D:\Documents\workspace\CPP_Schoolworks\ECE4304L\ECE4304L_Lab5\ECE4304L_Lab5_VHDL\scripts\output.txt" , write_mode);
            while not endfile(file_vectors) loop 
                readline(file_vectors, v_ILINE); 
                read(v_ILINE, v_opcode);  
                read(v_ILINE, v_SPACE); 
                read(v_ILINE, v_sel_A);  
                read(v_ILINE, v_SPACE); 
                read(v_ILINE, v_sel_B);  
                read(v_ILINE, v_SPACE); 
                read(v_ILINE, v_A);  
                read(v_ILINE, v_SPACE); 
                read(v_ILINE, v_B);
                
                
                top_tb_opcode <= v_opcode;
                top_tb_sel_A <= v_sel_A;
                top_tb_A <= v_A;
                top_tb_sel_B <= v_sel_B;
                top_tb_B <= v_B;
                
                for i in 0 to 7 loop
                
                    wait for (2**16)*clock_period; 
                
                    write(v_OLINE, v_opcode);  
                    write(v_OLINE, v_SPACE); 
                    write(v_OLINE, v_sel_A);  
                    write(v_OLINE, v_SPACE); 
                    write(v_OLINE, v_sel_B);  
                    write(v_OLINE, v_SPACE); 
                    write(v_OLINE, v_A);  
                    write(v_OLINE, v_SPACE); 
                    write(v_OLINE, v_B);
                    write(v_OLINE, v_SPACE);
                    write(v_OLINE, top_tb_a_to_g);
                    write(v_OLINE, v_SPACE);
                    write(v_OLINE, top_tb_an);
                    write(v_OLINE, v_SPACE);
                    write(v_OLINE, top_tb_dp);
    
                    writeline(file_results, v_OLINE);
                    
                end loop;

            end loop; 
            file_close(file_vectors); 
            file_close(file_results);     
            wait; 
            
            
            end process;

end Behavioral;
