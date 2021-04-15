library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.textio.all;
use IEEE.std_logic_textio.all;

entity top_tb_TEXTIO is
    GENERIC (
        top_tb_N_inp : INTEGER := 8;
        top_tb_CLKDIV : INTEGER := 0
    );
end top_tb_TEXTIO;

architecture Behavioral of top_tb_TEXTIO is

    component top is
        GENERIC (
            top_N_inp : INTEGER := top_tb_N_inp;
            top_CLKDIV : INTEGER := top_tb_CLKDIV);
          --top_N_inp is the bit width of the data being shifted
          --top_DIV is used for the clock divider when multiplexing 7sg displays
          PORT (
            clk : IN STD_LOGIC;
            rst : in STD_LOGIC;
            top_inp : IN STD_LOGIC_VECTOR(top_N_inp - 1 DOWNTO 0);
            top_shift_sel : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(top_N_inp)))) - 1 DOWNTO 0); --highest two bits are AU. lowest two bits toggle BCD->HEX
            top_LR_sel : IN STD_LOGIC;
            top_out_digit : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            top_7seg_en : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            top_barrel_out : OUT STD_LOGIC_VECTOR(top_N_inp - 1 DOWNTO 0)
          );
    end component;

    signal top_tb_clk : std_logic;
    signal top_tb_rst : std_logic;
    signal top_tb_inp :  STD_LOGIC_VECTOR(top_N_inp - 1 DOWNTO 0);
    signal top_tb_shift_sel : STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(top_N_inp)))) - 1 DOWNTO 0); --highest two bits are AU. lowest two bits toggle BCD->HEX
    signal top_tb_LR_sel : STD_LOGIC;
    signal top_tb_out_digit : STD_LOGIC_VECTOR(6 DOWNTO 0);
    signal top_tb_7seg_en : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal top_tb_barrel_out : STD_LOGIC_VECTOR(top_N_inp - 1 DOWNTO 0);

    constant clock_period:time:=10 ns;

    file file_vectors: text;
    file file_results: text;

begin

    TOP_GEN: top
    generic map(
        top_N_inp => top_tb_N_inp,
        top_CLKDIV => top_tb_CLKDIV
    )
    port map(
        clk             => top_tb_clk,
        rst             => top_tb_rst,
        top_inp         => top_tb_inp,
        top_shift_sel   => top_tb_shift_sel,
        top_LR_sel      => top_tb_LR_sel,
        top_out_digit   => top_tb_out_digit,
        top_7seg_en     => top_tb_7seg_en,
        top_barrel_out  => top_tb_barrel_out
    );

    CLK_GEN: process
    begin
        top_tb_clk <= '0';
        wait for clock_period;
        top_tb_clk <= '1';
        wait for clock_period;
    end process;

    -- INIT_RST: process
    -- begin
    --     top_tb_rst <= '1';
    --     top_tb_rst <= '0';
    --     wait;
    -- end process;

    TEXTIO_GEN: process
            variable v_ILINE: line;
            variable v_OLINE: line;
            
            variable v_inp :  STD_LOGIC_VECTOR(top_N_inp - 1 DOWNTO 0);
            variable v_shift_sel : STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(top_N_inp)))) - 1 DOWNTO 0); --highest two bits are AU. lowest two bits toggle BCD->HEX
            variable v_LR_sel : STD_LOGIC;
            variable v_space : character;
            begin
            wait for clock_period;
            file_open(file_vectors,"D:\Documents\workspace\CPP_Schoolworks\ECE4304L\ECE4304L_Lab6\ECE4304L_Lab6_VHDL\scripts\input.txt", read_mode);     
            file_open(file_results,"D:\Documents\workspace\CPP_Schoolworks\ECE4304L\ECE4304L_Lab6\ECE4304L_Lab6_VHDL\scripts\output.txt" , write_mode);
            while not endfile(file_vectors) loop 
                readline(file_vectors, v_ILINE); 
                read(v_ILINE, v_LR_sel);  
                read(v_ILINE, v_SPACE); 
                read(v_ILINE, v_shift_sel);  
                read(v_ILINE, v_SPACE); 
                read(v_ILINE, v_inp);
                
                
                top_tb_inp <= v_inp;
                top_tb_LR_sel <= v_LR_sel;
                top_tb_shift_sel <= v_shift_sel;
                
                for i in 0 to 7 loop
                
                    wait for clock_period; 
                
                    write(v_OLINE, v_LR_sel);  
                    write(v_OLINE, v_SPACE); 
                    write(v_OLINE, v_shift_sel);  
                    write(v_OLINE, v_SPACE); 
                    write(v_OLINE, v_inp);
                    write(v_OLINE, v_SPACE);
                    write(v_OLINE, top_out_digit);
                    write(v_OLINE, v_SPACE);
                    write(v_OLINE, top_7seg_en);
                    write(v_OLINE, v_SPACE);
                    write(v_OLINE, top_barrel_out);
    
                    writeline(file_results, v_OLINE);
                    
                end loop;

            end loop; 
            file_close(file_vectors); 
            file_close(file_results);     
            wait; 
            
            
            end process;

end Behavioral;
