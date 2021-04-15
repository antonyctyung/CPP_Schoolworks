----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2019 06:09:05 PM
-- Design Name: 
-- Module Name: top_display - Behavioral
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

entity top_display is
    generic (count_size_top:integer:= 20; AN_SIZE:integer:=8); 
    Port ( clk   : in STD_LOGIC;
           rst   : in STD_LOGIC;
    --       BU_SW : in std_logic; 
           dig_c : out STD_LOGIC_VECTOR (6 downto 0);
           an    : out STD_LOGIC_VECTOR (AN_SIZE-1 downto 0);
           dp    : out STD_LOGIC; 
           dig_SW: in  std_logic_vector(7 downto 0)
           );
end top_display;

architecture Behavioral of top_display is
component seg_encoder 
    Port ( s : in STD_LOGIC_VECTOR (3 downto 0);
           dig : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component counter_generic 
    generic (count_size:integer:= 32); 
    Port ( clk   : in STD_LOGIC;
           rst   : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (count_size-1 downto 0));
end component;

signal count_out:std_logic_vector(count_size_top-1 downto 0); 
signal tmp: std_logic_vector(6 downto 0);
signal SW_tmp:std_logic_vector(3 downto 0);

-- Extended version of IO SW

--signal reg_LSB: std_logic_vector(15 downto 0);
--signal reg_MSB: std_logic_vector(15 downto 0);

signal reg_display: std_logic_vector(31 downto 0); 



begin

--DEMUX_REG_CONTROL: process(clk,rst)
--                   begin 
--                    if rst = '1' then 
--                        reg_display <= (others =>'0'); 
--                    elsif (rising_edge(clk))then 
--                        DEM_CONT:case BU_SW is 
--                            when '0' => reg_display(15 downto 0) <= dig_SW; 
--                            when '1' => reg_display(31 downto 16) <= dig_SW; 
--                            when others => 
                        
--                        end case DEM_CONT; 
                    
--                    end if; 
--                   end process DEMUX_REG_CONTROL; 

dp <= '1';



COUNT: counter_generic generic map (count_size => count_size_top)
                       port map    (
                                      clk => clk,
                                      rst => rst,
                                      count =>  count_out 
                                    );

SEG_7_ENC: seg_encoder port map (
                                    s   => SW_tmp,
                                    dig => tmp 
                                 );
                                 
 dig_c<= not tmp;                                 


DECODING_SEG: process(count_out(count_size_top-1 downto count_size_top-3))
              begin 
                  case count_out(count_size_top-1) is 
                      when '0' => an <= "11111110";
                      when '1' => an <= "11111101";
--                      when "010" => an <= "11111011";
--                      when "011" => an <= "11110111";
--                      when "100" => an <= "11101111";
--                      when "101" => an <= "11011111";
--                      when "110" => an <= "10111111";
--                      when "111" => an <= "01111111";
                      
                      when others => an <= (others =>'Z'); 
                  end case; 
              end process DECODING_SEG; 

FEEDING_DIG: process(count_out(count_size_top-1 downto count_size_top-3))
              begin 
                  case count_out(count_size_top-1) is 
                      when '0' => SW_tmp <= dig_SW(3  downto  0);
                      when '1' => SW_tmp <= dig_SW(7  downto  4);
               --       when "010" => SW_tmp <= reg_display(11 downto  8);
               --       when "011" => SW_tmp <= reg_display(15 downto 12);
               --      when "100" => SW_tmp <= reg_display(19 downto 16);
              --        when "101" => SW_tmp <= reg_display(23 downto 20);
              --        when "110" => SW_tmp <= reg_display(27 downto 24);
              --        when "111" => SW_tmp <= reg_display(31 downto 28);

                      when others => SW_tmp <= (others =>'Z'); 
                  end case; 
              end process FEEDING_DIG; 


end Behavioral;
