----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2021 05:07:31 PM
-- Design Name: 
-- Module Name: bcd_counter - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.std_logic_arith.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY bcd_counter IS

    PORT (
        bcd_clk : IN STD_LOGIC; -- clk
        bcd_rst : IN STD_LOGIC; -- reset signal 
        bcd_ud : IN STD_LOGIC; -- up and down control signal 
        bcd_op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- output pattern 
        bcd_EO : OUT STD_LOGIC
    );
END bcd_counter;

ARCHITECTURE Behavioral OF bcd_counter IS
    SIGNAL bcd_tmp : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL bcd_ud_edge : STD_LOGIC;
    SIGNAL bcd_ud_buf : STD_LOGIC;
    -- signal rst_auto: std_logic; 
    -- signal bcd_gen_rst: std_logic; 

    -- signal up_auto_rst: std_logic; 
    -- signal dn_auto_rst: std_logic;
BEGIN

    -- rst_auto <= bcd_rst or bcd_gen_rst; 
    -- BCD_GEN: process (bcd_clk, rst_auto) 
    --          begin 
    --             if (rst_auto = '1')  then 
    --                 if (bcd_ud = '1') then 
    --                     bcd_tmp <= (others =>'0');
    --                 else 
    --                     bcd_tmp <= "1001";
    --                 end if;  
    --             elsif(rising_edge(bcd_clk)) then 
    --                    if (bcd_ud = '1') then 
    --                          bcd_tmp <= bcd_tmp + 1; -- we need to stop by 9 
    --                    else 
    --                         bcd_tmp <= bcd_tmp - 1;   -- we have to stop by 0
    --                    end if;      
    --             end if; 
    --          end process; 
    -- up_auto_rst <= bcd_tmp(3) and (not bcd_tmp(2))  and  (bcd_tmp(1)) and (not bcd_tmp(0));
    -- dn_auto_rst <= ( bcd_tmp(0) and bcd_tmp(1) and bcd_tmp(2) and bcd_tmp(3));
    -- bcd_gen_rst <=  (up_auto_rst and bcd_ud) or (dn_auto_rst and (not bcd_ud)) ; 

    -- bcd_op <= bcd_tmp;

    -- GEN_FLAG: process(bcd_clk, bcd_rst)
    --           begin 
    --             if (bcd_rst = '1') then 
    --                 bcd_EO <= '0';
    --             elsif (rising_edge(bcd_clk)) then 
    --                 bcd_EO <= (bcd_ud and (bcd_tmp(3) and (not bcd_tmp(2)) and (not bcd_tmp(1)) and bcd_tmp(0)))
    --                  or  ((not bcd_ud) and  ( (not bcd_tmp(0)) and (not bcd_tmp(1)) and (not bcd_tmp(2)) and (not bcd_tmp(3))));
    --             end if;
    --           end process; 

    BCD_GEN : PROCESS (bcd_clk, bcd_rst, bcd_ud_edge)
    BEGIN
        bcd_EO <= '0';
        IF (bcd_ud_edge = '1') THEN
            bcd_EO <= '0';
        ELSIF (bcd_rst = '1') THEN
            IF (bcd_ud = '1') THEN
                bcd_tmp <= (OTHERS => '0');
            ELSE
                bcd_tmp <= "1001";
            END IF;
        ELSIF (rising_edge(bcd_clk)) THEN
            IF (bcd_ud = '1') THEN
                IF (bcd_tmp = "1001") THEN
                    bcd_tmp <= "0000";
                    bcd_EO <= '1';
                ELSE
                    bcd_tmp <= bcd_tmp + 1;
                END IF;
            ELSE
                IF (bcd_tmp = "0000") THEN
                    bcd_tmp <= "1001";
                    bcd_EO <= '1';
                ELSE
                    bcd_tmp <= bcd_tmp - 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    BCD_UD_BUF_LOAD : PROCESS (bcd_ud_edge)
    BEGIN
    if (bcd_ud_edge = '1') then
        bcd_ud_buf <= bcd_ud;
    end if;
    END PROCESS;

    bcd_ud_edge <= bcd_ud XOR bcd_ud_buf;

    bcd_op <= bcd_tmp;
END Behavioral;