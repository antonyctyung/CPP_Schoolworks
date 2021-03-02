----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2021 01:29:38 PM
-- Design Name: 
-- Module Name: muxNx1 - Behavioral
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

entity muxNx1 is

    generic (LAYER:integer:=4); -- 2^layer = N e.g. 6 layer = 2^6 = 64 x 1 mux
    Port (
        clk :   in  std_logic;
        rst :   in  std_logic; 
        sel :   in  std_logic_vector(LAYER-1 downto 0);
        inp :   in  std_logic_vector((2 ** LAYER)-1 downto 0);
        op  :   out std_logic
    );

end muxNx1;

architecture Recursive of muxNx1 is

    component mux2x1 is
        Port ( 
            clk     :   in  std_logic;
            rst     :   in  std_logic;
            inp_0   :   in  std_logic;
            inp_1   :   in  std_logic;
            sel     :   in  std_logic;
            op      :   out std_logic
        );
    end component;

    component muxNx1 is
        generic (LAYER:integer:=LAYER-1);
        Port (
            clk :   in  std_logic;
            rst :   in  std_logic; 
            sel :   in  std_logic_vector(LAYER-2 downto 0);
            inp :   in  std_logic_vector((2 ** (LAYER-1))-1 downto 0);
            op  :   out std_logic
        );
    
    end component;

    signal interlayer: std_logic_vector((2 ** (LAYER-1))-1 downto 0);

begin

    GEN_THIS_LAYER: for i in 0 to (2 ** (LAYER-1))-1 generate
    M2x1: mux2x1 port map(
        clk     => clk,
        rst     => rst,
        inp_0   => inp(2*i),
        inp_1   => inp((2*i)+1),
        sel     => sel(0),
        op      => interlayer(i)
    );
    end generate;

    BASE: if LAYER = 2 generate

        M2x1: mux2x1 port map(
            clk     => clk,
            rst     => rst,
            inp_0   => inp(0),
            inp_1   => inp(1),
            sel     => sel(0),
            op      => op
        );

    end generate BASE;

    RECR: if LAYER > 2 generate
    
        NEXT_LAYER: muxNx1 
        generic map (LAYER => LAYER-1)
        port map (
            clk => clk,
            rst => rst,
            inp => interlayer,
            sel => sel(LAYER-1 downto 1),
            op  => op
        );

    end generate RECR;

end Recursive;

architecture Procedural of muxNx1 is

    component mux2x1 is
        Port ( 
            clk     :   in  std_logic;
            rst     :   in  std_logic;
            inp_0   :   in  std_logic;
            inp_1   :   in  std_logic;
            sel     :   in  std_logic;
            op      :   out std_logic
        );
    end component;

    signal interlayer: std_logic_vector((2 ** (LAYER+1))-1 downto 1);

begin

    op <= interlayer(1);

    interlayer((2 ** (LAYER+1))-1 downto (2 ** LAYER)) <= inp;

    GEN_LAYERS: for i in 1 to LAYER generate
        GEN_MUXES: for j in 0 to (2 ** (i-1))-1 generate
            M2x1: mux2x1 port map(
                clk     => clk,
                rst     => rst,
                inp_0   => interlayer((2**i)+(2*j)),
                inp_1   => interlayer((2**i)+((2*j)+1)),
                sel     => sel(LAYER-i),
                op      => interlayer((2**(i-1))+j)
            );        
        end generate;
    end generate;

end Procedural;