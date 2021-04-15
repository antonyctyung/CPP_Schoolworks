LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

ENTITY top_tb_TEXTIO IS
    GENERIC (
        top_tb_N_inp : INTEGER := 8;
        top_tb_CLKDIV : INTEGER := 0
    );
END top_tb_TEXTIO;

ARCHITECTURE Behavioral OF top_tb_TEXTIO IS

    COMPONENT top IS
        GENERIC (
            top_N_inp : INTEGER := top_tb_N_inp;
            top_CLKDIV : INTEGER := top_tb_CLKDIV);
        --top_N_inp is the bit width of the data being shifted
        --top_DIV is used for the clock divider when multiplexing 7sg displays
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            top_inp : IN STD_LOGIC_VECTOR(top_N_inp - 1 DOWNTO 0);
            top_shift_sel : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(top_N_inp)))) - 1 DOWNTO 0); --highest two bits are AU. lowest two bits toggle BCD->HEX
            top_LR_sel : IN STD_LOGIC;
            top_out_digit : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            top_7seg_en : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            top_barrel_out : OUT STD_LOGIC_VECTOR(top_N_inp - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL top_tb_clk : STD_LOGIC;
    SIGNAL top_tb_rst : STD_LOGIC;
    SIGNAL top_tb_inp : STD_LOGIC_VECTOR(top_tb_N_inp - 1 DOWNTO 0);
    SIGNAL top_tb_shift_sel : STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(top_tb_N_inp)))) - 1 DOWNTO 0); --highest two bits are AU. lowest two bits toggle BCD->HEX
    SIGNAL top_tb_LR_sel : STD_LOGIC;
    SIGNAL top_tb_out_digit : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL top_tb_7seg_en : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL top_tb_barrel_out : STD_LOGIC_VECTOR(top_tb_N_inp - 1 DOWNTO 0);

    CONSTANT clock_period : TIME := 10 ns;

    FILE file_vectors : text;
    FILE file_results : text;

BEGIN

    TOP_GEN : top
    GENERIC MAP(
        top_N_inp => top_tb_N_inp,
        top_CLKDIV => top_tb_CLKDIV
    )
    PORT MAP(
        clk => top_tb_clk,
        rst => top_tb_rst,
        top_inp => top_tb_inp,
        top_shift_sel => top_tb_shift_sel,
        top_LR_sel => top_tb_LR_sel,
        top_out_digit => top_tb_out_digit,
        top_7seg_en => top_tb_7seg_en,
        top_barrel_out => top_tb_barrel_out
    );

    CLK_GEN : PROCESS
    BEGIN
        top_tb_clk <= '1';
        WAIT FOR 0.5 * clock_period;
        top_tb_clk <= '0';
        WAIT FOR 0.5 * clock_period;
    END PROCESS;

    INIT_RST : PROCESS
    BEGIN
        top_tb_rst <= '1';
        top_tb_rst <= '0';
        WAIT;
    END PROCESS;

    TEXTIO_GEN : PROCESS
        VARIABLE v_ILINE : line;
        VARIABLE v_OLINE : line;

        VARIABLE v_inp : STD_LOGIC_VECTOR(top_tb_N_inp - 1 DOWNTO 0);
        VARIABLE v_shift_sel : STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(top_tb_N_inp)))) - 1 DOWNTO 0); --highest two bits are AU. lowest two bits toggle BCD->HEX
        VARIABLE v_LR_sel : STD_LOGIC;
        VARIABLE v_space : CHARACTER;
    BEGIN
        WAIT FOR clock_period;
        file_open(file_vectors, "D:\Documents\workspace\CPP_Schoolworks\ECE4304L\ECE4304L_Lab6\ECE4304L_Lab6_VHDL\scripts\input.txt", read_mode);
        file_open(file_results, "D:\Documents\workspace\CPP_Schoolworks\ECE4304L\ECE4304L_Lab6\ECE4304L_Lab6_VHDL\scripts\output.txt", write_mode);
        WHILE NOT endfile(file_vectors) LOOP
            readline(file_vectors, v_ILINE);
            read(v_ILINE, v_LR_sel);
            read(v_ILINE, v_SPACE);
            read(v_ILINE, v_shift_sel);
            read(v_ILINE, v_SPACE);
            read(v_ILINE, v_inp);
            top_tb_inp <= v_inp;
            top_tb_LR_sel <= v_LR_sel;
            top_tb_shift_sel <= v_shift_sel;

            FOR i IN 0 TO 7 LOOP

                WAIT FOR clock_period;

                write(v_OLINE, v_LR_sel);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, v_shift_sel);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, v_inp);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, top_tb_out_digit);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, top_tb_7seg_en);
                write(v_OLINE, v_SPACE);
                write(v_OLINE, top_tb_barrel_out);

                writeline(file_results, v_OLINE);

            END LOOP;

        END LOOP;
        file_close(file_vectors);
        file_close(file_results);
        WAIT;
    END PROCESS;

END Behavioral;