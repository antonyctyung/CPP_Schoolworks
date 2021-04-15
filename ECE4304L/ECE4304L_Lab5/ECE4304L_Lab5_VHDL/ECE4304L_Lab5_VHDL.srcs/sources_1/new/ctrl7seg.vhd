----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2021 06:21:11 PM
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ctrl7seg is
    generic(CLKDIV:integer:=0); -- number of FF for clock dividing
    Port (
        c7s_clk     :   in  std_logic;
        c7s_rst     :   in  std_logic;
        c7s_x0      :   in  std_logic_vector(3 downto 0);
        c7s_x1      :   in  std_logic_vector(3 downto 0);
        c7s_x2      :   in  std_logic_vector(3 downto 0);
        c7s_x3      :   in  std_logic_vector(3 downto 0);
        c7s_x4      :   in  std_logic_vector(3 downto 0);
        c7s_x5      :   in  std_logic_vector(3 downto 0);
        c7s_x6      :   in  std_logic_vector(3 downto 0);
        c7s_x7      :   in  std_logic_vector(3 downto 0);
        c7s_en      :   in  std_logic_vector(7 downto 0);   -- digit            (active high)   enable
        c7s_a_to_g  :   out std_logic_vector(6 downto 0);   -- MSB(abcdefg)LSB
        c7s_an      :   out std_logic_vector(7 downto 0);   -- digit            (active low)    enable
        c7s_dp      :   out std_logic
    );
end ctrl7seg;

architecture Behavioral of ctrl7seg is

    component muxNbits8x1 is
        generic(N:integer:=4);
        Port (
            x0  :   in  std_logic_vector(N-1 downto 0); 
            x1  :   in  std_logic_vector(N-1 downto 0); 
            x2  :   in  std_logic_vector(N-1 downto 0); 
            x3  :   in  std_logic_vector(N-1 downto 0); 
            x4  :   in  std_logic_vector(N-1 downto 0); 
            x5  :   in  std_logic_vector(N-1 downto 0); 
            x6  :   in  std_logic_vector(N-1 downto 0); 
            x7  :   in  std_logic_vector(N-1 downto 0); 
            sel :   in  std_logic_vector(2 downto 0);
            y   :   out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    component upcounter is
        generic(WIDTH:integer:=CLKDIV+3); -- at least 3-bit for rotating 8 input
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (WIDTH-1 downto 0));
    end component;

    component hex7seg is
        Port ( digit : in STD_LOGIC_VECTOR (3 downto 0);
               a_to_g : out STD_LOGIC_VECTOR (6 downto 0)); -- (CA downto CG)
    end component;

    component decoder8bit is
        Port ( 
            x: in  std_logic_vector(2 downto 0);        
            y: out std_logic_vector(7 downto 0)        
        );
    end component;

    signal c7s_sel: std_logic_vector(2 downto 0);
    signal c7s_y  : std_logic_vector(3 downto 0);
    signal c7s_Q: std_logic_vector(CLKDIV+2 downto 0);
    signal c7s_nAN: std_logic_vector(7 downto 0);

begin

    MUX: muxNbits8x1
    generic map(N => 4)
    port map
    (
        x0 => c7s_x0,
        x1 => c7s_x1,
        x2 => c7s_x2,
        x3 => c7s_x3,
        x4 => c7s_x4,
        x5 => c7s_x5,
        x6 => c7s_x6,
        x7 => c7s_x7,
        sel => c7s_sel,
        y => c7s_y
    );

    DEC: decoder8bit
    port map
    (
        x => c7s_sel,
        y => c7s_nAN
    );

    CNT: upcounter
    generic map (WIDTH=>CLKDIV+3)
    port map
    (
        clk => c7s_clk, 
        rst => c7s_rst,
        Q   => c7s_Q
    );
    
    H7S: hex7seg
    port map
    (
        digit => c7s_y,
        a_to_g => c7s_a_to_g
    );

    c7s_dp <= '1';  -- disable decimal point
    c7s_an <= not(c7s_nAN and c7s_en);
    c7s_sel <= c7s_Q(CLKDIV+2 downto CLKDIV);

end Behavioral;
