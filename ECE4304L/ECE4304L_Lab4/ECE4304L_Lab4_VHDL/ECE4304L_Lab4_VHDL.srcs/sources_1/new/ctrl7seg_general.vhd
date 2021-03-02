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

entity ctrl7seg_general is
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
        c7s_en      :   in  std_logic_vector(7 downto 0);   -- digit         (active high) enable
        c7s_dp_en   :   in  std_logic_vector(7 downto 0);   -- decimal point (active high) enable
        c7s_a_to_g  :   out std_logic_vector(6 downto 0);   -- MSB(abcdefg)LSB (active low), rotating output
        c7s_an      :   out std_logic_vector(7 downto 0);   -- digit         (active low)  enable, rotating output
        c7s_dp      :   out std_logic                       -- decimal point (active low) output
    );
end ctrl7seg_general;

architecture Behavioral of ctrl7seg_general is

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
        generic(WIDTH:integer:=18);
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
    signal c7s_Q: std_logic_vector(17 downto 0);
    signal c7s_nAN: std_logic_vector(7 downto 0);
    signal c7s_nDP: std_logic;

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

    MUXDP: muxNbits8x1
    generic map(N => 1)
    port map
    (
        x0 => c7s_dp_en(0),
        x1 => c7s_dp_en(1),
        x2 => c7s_dp_en(2),
        x3 => c7s_dp_en(3),
        x4 => c7s_dp_en(4),
        x5 => c7s_dp_en(5),
        x6 => c7s_dp_en(6),
        x7 => c7s_dp_en(7),
        sel => c7s_sel,
        y => c7s_nDP
    );

    CNT: upcounter
    generic map (WIDTH=>18)
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

    top_dp <= not(top_nDP);
    top_an <= not(top_nAN);
    top_sel <= top_Q(17 downto 15);

end Behavioral;
