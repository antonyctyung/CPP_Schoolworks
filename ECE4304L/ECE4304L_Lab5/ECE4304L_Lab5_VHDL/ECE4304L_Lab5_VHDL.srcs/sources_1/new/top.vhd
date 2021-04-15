----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2021 04:52:14 PM
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY top IS
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
END top;

ARCHITECTURE Behavioral OF top IS

  COMPONENT ctrl7seg IS
    GENERIC (CLKDIV : INTEGER := 0);
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

  COMPONENT bcdAU IS
    PORT (
      opcode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      out_1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      out_0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT BCDconv IS
    PORT (
      B : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      P : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
  END COMPONENT;

  COMPONENT NbitReg IS
    GENERIC (N : INTEGER := 8);
    PORT (
      D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
  END COMPONENT;

  CONSTANT top_CLKDIV : INTEGER := 15; -- 15 + 3 = 18, divided by 2^18

  SIGNAL top_A_Q : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL top_B_Q : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL top_A_BCD : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL top_B_BCD : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL top_A_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL top_B_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL top_C_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL top_C_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

  AU : bcdAU
  PORT MAP(
    opcode => top_opcode,
    A => top_A_Q,
    B => top_B_Q,
    out_1 => top_C_1,
    out_0 => top_C_0
  );

  BCA : BCDconv
  PORT MAP(
    B => top_A,
    P => top_A_BCD
  );

  BCB : BCDconv
  PORT MAP(
    B => top_B,
    P => top_B_BCD
  );

  NRA : NbitReg
  GENERIC MAP(N => 4)
  PORT MAP(
    D => top_A_BCD,
    Q => top_A_Q,
    clk => top_clk,
    rst => top_rst
  );

  NRB : NbitReg
  GENERIC MAP(N => 4)
  PORT MAP(
    D => top_B_BCD,
    Q => top_B_Q,
    clk => top_clk,
    rst => top_rst
  );

  MAB: for i in 0 to 3 generate
  top_A_out(i) <= (top_A(i) AND (NOT top_sel_A)) OR (top_A_BCD(i) AND top_sel_A);
  top_B_out(i) <= (top_B(i) AND (NOT top_sel_B)) OR (top_B_BCD(i) AND top_sel_B);
  end generate;

  C7S : ctrl7seg
  GENERIC MAP(CLKDIV => top_CLKDIV)
  PORT MAP(
    c7s_clk => top_clk,
    c7s_rst => top_rst,
    c7s_x0 => top_C_0,
    c7s_x1 => top_C_1,
    c7s_x2 => "0000",
    c7s_x3 => "0000",
    c7s_x4 => top_B_out,
    c7s_x5 => "0000",
    c7s_x6 => top_A_out,
    c7s_x7 => "0000",
    c7s_en => "01010011",
    c7s_a_to_g => top_a_to_g,
    c7s_an => top_an,
    c7s_dp => top_dp
  );

END Behavioral;