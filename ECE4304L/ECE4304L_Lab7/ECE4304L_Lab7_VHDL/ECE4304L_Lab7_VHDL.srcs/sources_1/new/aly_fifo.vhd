----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2019 05:44:48 PM
-- Design Name: 
-- Module Name: aly_fifo - Behavioral
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

entity aly_fifo is
    generic(g_DEPTH:positive:=32; g_WIDTH:positive:= 8); 
    Port ( clk        : in  STD_LOGIC;
           i_rst_sync : in  STD_LOGIC;
           i_wr_en    : in  STD_LOGIC;
           i_wr_data  : in  STD_LOGIC_VECTOR (g_WIDTH-1 downto 0);
           o_full     : out STD_LOGIC;
           i_rd_en    : in  STD_LOGIC;
           o_rd_data  : out STD_LOGIC_VECTOR (g_WIDTH-1 downto 0);
           o_empty    : out STD_LOGIC
         );
end aly_fifo;

architecture Behavioral of aly_fifo is

type t_FIFO_DATA is array (0 to g_DEPTH-1) of std_logic_vector(g_WIDTH-1 downto 0); 

signal r_FIFO_DATA: t_FIFO_DATA:= (others => (others =>'0')); 

signal r_WR_INDEX: integer range 0 to g_DEPTH-1 := 0; 
signal r_RD_INDEX: integer range 0 to g_DEPTH-1 := 0; 


--- a words in FIFO has extra range to allow assert conditions 
signal r_FIFO_COUNT: integer range -1 to g_DEPTH+1 := 0; 


signal w_FULL : std_logic; 
signal w_EMPTY: std_logic; 

begin

P_control_FIFO: process(clk) 
                begin 
                    if (rising_edge(clk)) then 
                        if i_rst_sync = '1' then 
                            r_FIFO_COUNT <= 0; 
                            r_WR_INDEX   <= 0; 
                            r_RD_INDEX   <= 0; 
                        
                        else 
                            -- tracking number of location got occupied on my FIFO memory 
                            
                            if (i_wr_en = '1' and i_rd_en = '0') then 
                                r_FIFO_COUNT <= r_FIFO_COUNT + 1; 
                           elsif (i_wr_en = '0' and i_rd_en = '1') then  
                                r_FIFO_COUNT <= r_FIFO_COUNT -1 ; 
                          end if; 
                        -- keep track of the write index (roll-over controcl procedure) 
                        
                        if (i_wr_en = '1' and w_FULL = '0') then 
                            if r_WR_INDEX = g_DEPTH-1 then 
                                r_WR_INDEX <= 0;
                            else 
                                r_WR_INDEX <= r_WR_INDEX + 1; 
                            end if;           
                        end if; 

                        -- keep track of the read index (roll-over control procedure for reading out of the memory banks)   
                        if (i_rd_en = '1' and w_EMPTY = '0') then 
                            if r_RD_INDEX = g_DEPTH-1 then 
                                r_RD_INDEX <= 0;
                            else 
                                r_RD_INDEX <= r_RD_INDEX + 1; 
                            end if;           
                        end if; 
                        
                        -- Regsiters the input data when there is write signal happening 
                        
                        if i_wr_en = '1' then 
                            r_FIFO_DATA(r_WR_INDEX) <= i_wr_data; 
                        end if; 
                        
                        end if; 
                    end if; 
                end process; 
o_rd_data <= r_FIFO_DATA(r_RD_INDEX); 


w_FULL  <= '1' when  r_FIFO_COUNT = g_DEPTH   else '0' ; 

w_EMPTY <= '1' when  r_FIFO_COUNT = 0         else '0' ;

o_full  <= w_FULL; 
o_empty <= w_EMPTY; 

-- sytnehsis translate_off 
-- This blah blah will not be attacked by the compiler have fun here 
BLAH_PROCESS: process(clk)
              begin 
              if(rising_edge(clk)) then 
               if i_wr_en ='1' and w_FULL = '1' then 
                report "ASSERT FAILURE - MODULE_REG_FIFO: FIFO IS FULL AND BEING WRITTEN" severity failure ; 
               end if; 
              
                  if (i_rd_en = '1' and w_EMPTY ='1' ) then 
                    report("ASSERT FAILURE - module_register_fifo_blah: fifo is empty and being read") severity failure; 
                  end if; 
              end if; 
              
              end process; 

-- synthesis translate_on 



end Behavioral;
