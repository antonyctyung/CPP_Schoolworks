----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 10:21:08 PM
-- Design Name: 
-- Module Name: barrel - Behavioral
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
use ieee.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity barrel is
    generic(N:integer:=4); -- n is the size of the barrel shifter output
    Port (
            barrel_in : in std_logic_vector(N-1 downto 0);
            barrel_sel: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
            barrel_out: out std_logic_vector(N-1 downto 0);
            LR_sel    : in std_logic
         );
         
end barrel;


architecture Structural of barrel is

    --Signals for generating Muxes in for generate loop
    constant num_inter:integer:=N*(integer(ceil(log2(real(N))))+1); --total number of wires needed for an n-bit barrel shifter
    signal interlayer: std_logic_vector(num_inter-1 downto 0);
    -----
    
    ----------Signals for toggling between ROR and ROL
    signal LR_out: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
    signal bsel_int: integer;
    ---------
    
    component mux2x1 is
        Port (
                mux_A  : in std_logic;
                mux_B  : in std_logic;
                mux_sel: in std_logic;
                mux_op : out std_logic
             );
    end component;

   
    begin
        bsel_int <= to_integer(unsigned(barrel_sel));
             
        -------------
        --Assignments for the for generate loops
        interlayer(N-1 downto 0) <= barrel_in;
        
        barrel_out <= interlayer(num_inter-1 downto num_inter-N);
        -----------------
             
             --Generate ROR 
             LEVELS_L: for i in  0 to integer(ceil(log2(real(N))))-1   generate
                    WIDTH_L: for j in 0 to N-1 generate
                        MUXGEN_L: mux2x1
                            port map(
                                        mux_A => interlayer(N*i + j),
                                        mux_B => interlayer(((2**i + j + N*i) mod N) + N*(i)),
                                        mux_sel => LR_out(i),
                                        mux_op => interlayer(N*i + N + j) 
                                    ); 
                    
                    end generate WIDTH_L;
                end generate LEVELS_L;
            
            
            --From ROR, either remain in ROR or perform ROL based on select
            process(LR_sel, barrel_sel, bsel_int)
            begin
                case LR_sel is
                    when '0' => LR_out <= barrel_sel;     --shift right
                    when '1' =>                           --shift left
                        LR_out <= std_logic_vector(to_unsigned( ( ( (N*bsel_int) - bsel_int) mod N), LR_out'length));
                    when others => LR_out <= (others => 'Z');
                end case;
            end process;


end Structural;





-- architecture Behavioral of barrel is

-- signal tmp_out: std_logic_vector(N-1 downto 0);

-- begin

-- process(barrel_sel,barrel_in, LR_sel)  
-- begin
--     for f in 0 to N-1  loop
--         case LR_sel is
--             when '0' =>
--                 tmp_out(f) <= barrel_in((f + to_integer(unsigned(barrel_sel))) mod N);              
--             when '1' =>
--                 tmp_out(f) <= barrel_in((N + f - to_integer(unsigned(barrel_sel))) mod N);
--             when others =>
--                 tmp_out    <= (others => 'Z');
--         end case;
--     end loop;
-- end process;

-- barrel_out <= tmp_out;

-- end Behavioral;
