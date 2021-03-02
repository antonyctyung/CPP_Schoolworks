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

entity top is
    Port (
        top_clk: in std_logic;
        top_x0: in std_logic_vector(3 downto 0);
        top_x1: in std_logic_vector(3 downto 0);
        top_a_to_g: out std_logic_vector(6 downto 0); -- MSB(abcdefg)LSB
        top_an: out std_logic_vector(7 downto 0);
        top_dp: out std_logic
    );
end top;

architecture Behavioral of top is

    component mux4bits2x1 is
        Port (
            x0  : in std_logic_vector(3 downto 0); 
            x1  : in std_logic_vector(3 downto 0); 
            sel : in std_logic;
            y   : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component BCDdec is
        Port ( B : in STD_LOGIC_VECTOR (3 downto 0);
               P : out STD_LOGIC_VECTOR (3 downto 0));
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

    signal top_sel: std_logic;
    signal top_y  : std_logic_vector(3 downto 0);
    signal top_bcd  : std_logic_vector(3 downto 0);
    signal top_Q: std_logic_vector(17 downto 0);

begin

    MUX: mux4bits2x1
    port map
    (
        x0 => top_x0,
        x1 => top_x1,
        sel => top_sel,
        y => top_y
    );

    BDEC: BCDdec
    port map
    (
        B => top_y,
        P => top_bcd
    );

    CNT: upcounter
    generic map (WIDTH=>18)
    port map
    (
        clk => top_clk, 
        rst => '0',
        Q   => top_Q
    );
    
    H7S: hex7seg
    port map
    (
        digit => top_bcd,
        a_to_g => top_a_to_g
    );

    top_dp <= '1'; -- disable decimal point
    top_sel <= top_Q(17);
    
    top_an(7 downto 5) <= (others => '1');
    top_an(3 downto 1) <= (others => '1');
    top_an(4) <= not(top_sel);
    top_an(0) <= top_sel;

end Behavioral;
