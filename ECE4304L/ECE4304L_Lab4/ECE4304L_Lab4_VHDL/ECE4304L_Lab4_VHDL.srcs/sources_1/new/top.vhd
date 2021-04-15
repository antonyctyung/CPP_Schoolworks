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
    top_c7s_rst_in : IN STD_LOGIC;
    top_bcd_rst_in : IN STD_LOGIC;
    top_ud : IN STD_LOGIC;
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

  COMPONENT bcd_counter
    PORT (
      bcd_clk : IN STD_LOGIC; -- clk
      bcd_rst : IN STD_LOGIC; -- reset signal 
      bcd_ud : IN STD_LOGIC; -- up and down control signal 
      bcd_op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- output pattern 
      bcd_EO : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT upcounter IS
    GENERIC (WIDTH : INTEGER := 23);
    PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      Q : OUT STD_LOGIC_VECTOR (WIDTH - 1 DOWNTO 0));
  END COMPONENT;

  constant top_CLKDIV : integer := 23;

  SIGNAL top_bcd_clk : STD_LOGIC;
  TYPE ARRAY_8_NIBBLE IS ARRAY (7 DOWNTO 0) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL top_x : ARRAY_8_NIBBLE;
  SIGNAL top_EO : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL top_Q : STD_LOGIC_VECTOR(top_CLKDIV-1 DOWNTO 0);
  SIGNAL top_c7s_rst : STD_LOGIC;
  SIGNAL top_bcd_rst : STD_LOGIC;

BEGIN

  top_c7s_rst <= (top_c7s_rst_in OR top_rst);
  top_bcd_rst <= (top_bcd_rst_in OR top_rst);
  top_EO(0) <= top_Q(top_CLKDIV-1);

  CLKDIV : upcounter
  GENERIC MAP(WIDTH => top_CLKDIV)
  PORT MAP(
    clk => top_clk,
    rst => top_rst,
    Q => top_Q
  );

  C7S : ctrl7seg
  GENERIC MAP(CLKDIV => 0)
  PORT MAP(
    c7s_clk => top_Q(14), -- 15 + 3 = 18, divided by 2^18
    c7s_rst => top_c7s_rst,
    c7s_x0 => top_x(0),
    c7s_x1 => top_x(1),
    c7s_x2 => top_x(2),
    c7s_x3 => top_x(3),
    c7s_x4 => top_x(4),
    c7s_x5 => top_x(5),
    c7s_x6 => top_x(6),
    c7s_x7 => top_x(7),
    c7s_en => (OTHERS => '1'),
    c7s_a_to_g => top_a_to_g,
    c7s_an => top_an,
    c7s_dp => top_dp
  );

  BCD_GEN: FOR i IN 0 TO 7 GENERATE
    BCD_UNIT : bcd_counter PORT MAP(
      bcd_clk => top_EO(i),
      bcd_rst => top_bcd_rst,
      bcd_ud => top_ud,
      bcd_op => top_x(i),
      bcd_EO => top_EO(i+1)
    );
  END GENERATE;
END Behavioral;