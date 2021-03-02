----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2021 04:27:29 PM
-- Design Name: 
-- Module Name: mux2x1 - Behavioral
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

-- IO Port Declaration
entity mux2x1 is
    Port ( 
        clk     :   in      std_logic;
        rst     :   in      std_logic;
        inp_0   :   in    std_logic;
        inp_1   :   in    std_logic;
        sel     :   in    std_logic;
        op      :   out   std_logic
    );
end mux2x1;



architecture NASA of mux2x1 is

-- define signal (wire in verilog)
signal  op_tmp   :   std_logic;

begin
    
    op_tmp <= (inp_0 and sel) or (inp_1 and (not sel));

    -- ASYNC RST
    -- GEN_FF: process(clk, rst)
    --     begin
    --         if (rst = '1') then
    --             op <= '0';
    --         elsif (rising_edge(clk)) then
    --             op <= op_tmp;
    --         end if;
    --     end process;

    -- SYNC RST
    GEN_FF: process(clk, rst)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    op <= '0';
                else
                    op <= op_tmp;
                end if;
            end if;
        end process;

end NASA;



