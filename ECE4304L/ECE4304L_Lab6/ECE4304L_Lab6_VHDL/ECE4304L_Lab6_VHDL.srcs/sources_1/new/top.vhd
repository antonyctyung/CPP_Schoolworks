----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2021 11:07:05 PM
-- Design Name: 
-- Module Name: top - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;
USE ieee.math_real.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY top IS
  GENERIC (
    top_N_inp : INTEGER := 8;
    top_CLKDIV : INTEGER := 13);
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
END top;

ARCHITECTURE Behavioral OF top IS

  SIGNAL top_barrel_op : STD_LOGIC_VECTOR(top_N_inp - 1 DOWNTO 0);
  SIGNAL barrel_sel_4bit : STD_LOGIC_VECTOR(3 DOWNTO 0);

  COMPONENT barrel IS
    GENERIC (N : INTEGER := 4); -- n is the size of the barrel shifter output
    PORT (
      barrel_in : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      barrel_sel : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(N)))) - 1 DOWNTO 0);
      barrel_out : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      LR_sel : IN STD_LOGIC
    );
  END COMPONENT;

  COMPONENT ctrl7seg IS
    GENERIC (CLKDIV : INTEGER := 15);
    PORT (
      c7s_clk : IN STD_LOGIC;
      c7s_rst : IN STD_LOGIC;
      c7s_x0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      c7s_x1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      c7s_x2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      c7s_x3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      c7s_x4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      c7s_x5 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      c7s_x6 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      c7s_x7 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      c7s_en : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- digit            (active high)   enable
      c7s_a_to_g : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- MSB(abcdefg)LSB
      c7s_an : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- digit            (active low)    enable
      c7s_dp : OUT STD_LOGIC
    );
  END COMPONENT;
BEGIN

  top_barrel_out <= top_barrel_op; -- assign actual barrel output to intermediate barrel output signal
  barrel_sel_4bit <= '0' & top_shift_sel; -- make the select line 4 bits so it plays nicely with the 7seg control component
  BARRELGEN : barrel
  GENERIC MAP(N => top_N_inp)
  PORT MAP(
    barrel_in => top_inp,
    barrel_sel => top_shift_sel,
    barrel_out => top_barrel_op,
    LR_sel => top_LR_sel
  );

  C7S : ctrl7seg
  GENERIC MAP(CLKDIV => top_CLKDIV)
  PORT MAP(
    c7s_clk => clk,
    c7s_rst => rst,
    c7s_x0 => top_barrel_op(top_N_inp - 5 DOWNTO 0),
    c7s_x1 => top_barrel_op(top_N_inp - 1 DOWNTO top_N_inp - 4),
    c7s_x2 => "0000",
    c7s_x3 => barrel_sel_4bit,
    c7s_x4 => "0000",
    c7s_x5 => top_inp(top_N_inp - 5 DOWNTO 0),
    c7s_x6 => top_inp(top_N_inp - 1 DOWNTO top_N_inp - 4),
    c7s_x7 => "0000",
    c7s_en => "01101011",
    c7s_a_to_g => top_out_digit,
    c7s_an => top_7seg_en,
    c7s_dp => open
  );


END Behavioral;