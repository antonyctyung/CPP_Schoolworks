----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2021 01:26:21 PM
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



entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is

    component top is
        Port (
                top_clk : IN STD_LOGIC;
                top_rst : IN STD_LOGIC;
                top_c7s_rst_in : IN STD_LOGIC;
                top_bcd_rst_in : IN STD_LOGIC;
                top_ud : IN STD_LOGIC;
                top_a_to_g : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
                top_an : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                top_dp : OUT std_logic 
             );
    end component;
    
    signal  top_clk_tb:               std_logic;
    signal  top_rst_tb :              std_logic;
    signal  top_c7s_rst_in_tb:        std_logic;
    signal  top_bcd_rst_in_tb:        std_logic;
    signal  top_ud_tb:                std_logic;
    signal  top_a_to_g_tb:            std_logic_vector(6 downto 0);
    signal  top_an_tb:                std_logic_vector(7 downto 0);
    signal  top_dp_tb:                std_logic;
    


    constant clock_period:time:=10 ps;

file file_vectors: text;
file file_results: text;

begin

    TOP_GEN: top
    port map(
                top_clk         => top_clk_tb,
                top_rst         =>top_rst_tb,
                top_c7s_rst_in  => top_c7s_rst_in_tb ,
                top_bcd_rst_in  =>  top_bcd_rst_in_tb,
                top_ud          => top_ud_tb,
                top_a_to_g      =>  top_a_to_g_tb,
                top_an          =>   top_an_tb,
                top_dp          =>  top_dp_tb   
    );

    CLK_GEN: process
    begin
        top_clk_tb <= '0';
        wait for clock_period;
        top_clk_tb <= '1';
        wait for clock_period;
    end process;
    
  

  TEXTIO_GEN: process
           variable v_ILINE: line;
           variable v_OLINE: line;
            
            variable v_INP0   : std_logic_vector(3 downto 0);
            variable v_INP1   : std_logic_vector(3 downto 0);
            variable v_space : character;
            begin
            
            file_open(file_vectors,"", read_mode);     
            file_open(file_results,"" , write_mode);
            while not endfile(file_vectors) loop  
                        write(v_OLINE, top_a_to_g_tb);
                        write(v_OLINE, v_SPACE);
                        write(v_OLINE, top_an_tb);
                        write(v_OLINE, v_SPACE);
                        write(v_OLINE, top_dp_tb);
        
                        writeline(file_results, v_OLINE);

                wait for (2**18)*clock_period; 
                        write(v_OLINE, top_a_to_g_tb);
                        write(v_OLINE, v_SPACE);
                        write(v_OLINE, top_an_tb);
                        write(v_OLINE, v_SPACE);
                        write(v_OLINE, top_dp_tb);
                        
                        writeline(file_results, v_OLINE);
    
                wait for (2**18)*clock_period; 
                          
                        write(v_OLINE, top_a_to_g_tb);
                        write(v_OLINE, v_SPACE);
                        write(v_OLINE, top_an_tb);
                        write(v_OLINE, v_SPACE);
                        write(v_OLINE, top_dp_tb);
        
                writeline(file_results, v_OLINE);
            
            end loop; 
            file_close(file_vectors); 
            file_close(file_results);     
            
            wait;
            end process;

end Behavioral;
