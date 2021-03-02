----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2021 01:10:53 PM
-- Design Name: 
-- Module Name: Nbitdec - Behavioral
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

entity Nbitdec is
    generic(N:integer:=5);
    Port ( 
        clk: in std_logic;
        rst: in std_logic;
        s: in std_logic_vector(N-1 downto 0);
        p: out std_logic_vector((2 ** N)-1 downto 0)
    );
end Nbitdec;

architecture Behavioral of Nbitdec is
    constant LAYER:integer := (N+1)/2;  -- equivalent to dividing 2 and round up
    constant Nup:integer := LAYER*2; -- N but rounded up to the next even integer
--    constant Nodd:integer := Nup - N; -- is N odd? 1 if yes; 0 if no
--    constant Neven:integer := 1-Nodd; -- is N even? 1 if yes; 0 if no

    component dec2x4 is
        Port (
            clk: in std_logic;
            rst: in std_logic;
            s: in std_logic_vector(1 downto 0);
            p: out std_logic_vector (3 downto 0)
        );
    end component;

    signal interlayer: std_logic_vector((2 ** (Nup+1))-1 downto 1);
    signal s_tmp: std_logic_vector(Nup downto 0);
--    signal s_first: std_logic_vector(2 downto 0);
--    signal p_first: std_logic_vector(4 downto 0);
begin
    
--    INDEC: dec2x4 port map(
--        clk => clk,
--        rst => rst,
--        s => s_first(1 downto 0),
--        p => p_first(3 downto 0)
--    );
--
--    -- to dynamically adjust for I/O of the first stage decoder
--    s(Neven downto 0) <= s_first(Neven downto 0);
--    s_first(2 downto Neven+1) <= (others => '0');
--    p_first((2 ** (Neven+1))-1 downto 0) <= interlayer((2 ** (Neven+1))-1 downto 0);
--    s_first(4 downto (2 ** (Neven+1))) <= (others => '0');
--
--    WIRE_FIRST_LAYER: for h in 0 to Neven generate
--        GEN_LAYERS: for i in 1 to LAYER generate
--            GEN_MUXES: for j in 0 to (2 ** (i-1))-1 generate
--                M2x1: mux2x1 port map(
--                    clk     => clk,
--                    rst     => rst,
--                    inp_0   => interlayer((2**i)+(2*j)),
--                    inp_1   => interlayer((2**i)+((2*j)+1)),
--                    sel     => sel(LAYER-i),
--                    op      => interlayer((2**(i-1))+j)
--                );        
--            end generate;
--        end generate;
--    end generate;
--    p <= interlayer(((2 ** N)+(2 ** Nup)-1) downto (2 ** Nup));

    GEN_LAYERS: for i in 0 to LAYER-1 generate
        GEN_DECS: for j in 0 to (2 ** (i*2))-1 generate
            D2x4: dec2x4 port map(
                clk => clk,
                rst => not(interlayer((2**(i*2))+j)),
                s   => s_tmp((2*(LAYER-i))-1 downto (2*(LAYER-i))-2),
                p   => interlayer((((2**(i*2))+j)*4)+3 downto ((2**(i*2))+j)*4)
            );

        end generate;
    end generate;

    interlayer(1) <= not(rst);
    s_tmp(N-1 downto 0) <= s;
    s_tmp(Nup downto N) <= (others => '0');
    p <= interlayer(((2 ** Nup)+(2 ** N)-1) downto (2 ** Nup));

end Behavioral;
