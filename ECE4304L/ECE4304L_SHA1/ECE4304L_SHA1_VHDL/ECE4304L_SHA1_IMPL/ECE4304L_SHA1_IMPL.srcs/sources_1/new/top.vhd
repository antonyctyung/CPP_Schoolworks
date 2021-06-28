----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2021 03:36:58 PM
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY top IS
    PORT (
        top_clk : IN STD_LOGIC;
        top_rst : IN STD_LOGIC;
        top_rx : IN STD_LOGIC;
        top_last : IN STD_LOGIC;
        top_a_to_g : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        top_an : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- digit            (active low)    enable
        top_dp : OUT STD_LOGIC;
        top_lasted : OUT STD_LOGIC;
        top_hsync : OUT STD_LOGIC;
        top_vsync : OUT STD_LOGIC;
        top_rgb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
END top;

ARCHITECTURE Behavioral OF top IS

    COMPONENT SHA1_CORE IS
        PORT (
            clk : IN STD_LOGIC;
            rst_in : IN STD_LOGIC;
            byte : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            valid_in : IN STD_LOGIC;
            last : IN STD_LOGIC;
            hash : OUT STD_LOGIC_VECTOR(159 DOWNTO 0);
            valid_out : OUT STD_LOGIC;
            ready_in : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT upcounter IS
        GENERIC (WIDTH : INTEGER := 1);
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR (WIDTH - 1 DOWNTO 0));
    END COMPONENT;

    COMPONENT UART_RX IS
        GENERIC (
            g_CLKS_PER_BIT : INTEGER := 435
        );
        PORT (
            i_Clk : IN STD_LOGIC;
            i_RX_Serial : IN STD_LOGIC;
            o_RX_DV : OUT STD_LOGIC;
            o_RX_Byte : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT ctrl7seg IS
        GENERIC (CLKDIV : INTEGER := 13); -- number of FF for clock dividing
        PORT (
            c7s_clk : IN STD_LOGIC;
            c7s_rst : IN STD_LOGIC;
            c7s_x0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            c7s_x1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            c7s_x2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            c7s_x3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            c7s_x4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            c7s_x5 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            c7s_x6 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            c7s_x7 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            c7s_en : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- digit            (active high)   enable
            c7s_a_to_g : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- MSB(abcdefg)LSB
            c7s_an : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- digit            (active low)    enable
            c7s_dp : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT pong_top IS
        GENERIC (top_length : INTEGER := 160);
        PORT (
            clk, reset : IN STD_LOGIC;
            sha_digest : IN STD_LOGIC_VECTOR(top_length - 1 DOWNTO 0);
            hsync, vsync : OUT STD_LOGIC;
            rgb : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL hash_reg : STD_LOGIC_VECTOR(159 DOWNTO 0);
    SIGNAL slow_clk : STD_LOGIC;
    SIGNAL rx_dv : STD_LOGIC;
    SIGNAL rx_byte : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL sha_byte : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL sha_ena : STD_LOGIC;
    SIGNAL sha_last : STD_LOGIC;
    SIGNAL sha_valid_in : STD_LOGIC;
    SIGNAL sha_ready : STD_LOGIC;
    SIGNAL sha_hash : STD_LOGIC_VECTOR(159 DOWNTO 0);
    SIGNAL sha_valid_out : STD_LOGIC;
    SIGNAL lasted : STD_LOGIC := '0';
    SIGNAL hashed : STD_LOGIC := '0';
    SIGNAL top_Q : STD_LOGIC_VECTOR(0 DOWNTO 0);

BEGIN

    CLKDIV : upcounter
    GENERIC MAP(WIDTH => 1)
    PORT MAP
    (
        clk => top_clk,
        rst => top_rst,
        Q => top_Q
    );

    slow_clk <= top_Q(0);

    RX : UART_RX
    GENERIC MAP(g_CLKS_PER_BIT => 435)
    PORT MAP(
        i_Clk => slow_clk,
        i_RX_Serial => top_rx,
        o_RX_DV => rx_dv,
        o_RX_Byte => rx_byte
    );

    SHA1 : SHA1_CORE
    PORT MAP(
        clk => slow_clk,
        rst_in => top_rst,
        byte => sha_byte,
        valid_in => sha_valid_in,
        last => sha_last,
        hash => sha_hash,
        valid_out => sha_valid_out,
        ready_in => sha_ready
    );

    C7S : ctrl7seg
    GENERIC MAP(CLKDIV => 13) -- number of FF for clock dividing
    PORT MAP(
        c7s_clk => top_clk,
        c7s_rst => top_rst,
        c7s_x0 => hash_reg(131 DOWNTO 128),
        c7s_x1 => hash_reg(135 DOWNTO 132),
        c7s_x2 => hash_reg(139 DOWNTO 136),
        c7s_x3 => hash_reg(143 DOWNTO 140),
        c7s_x4 => hash_reg(147 DOWNTO 144),
        c7s_x5 => hash_reg(151 DOWNTO 148),
        c7s_x6 => hash_reg(155 DOWNTO 152),
        c7s_x7 => hash_reg(159 DOWNTO 156),
        c7s_en => "11111111",
        c7s_a_to_g => top_a_to_g,
        c7s_an => top_an,
        c7s_dp => top_dp
    );

    VGA : pong_top
    GENERIC MAP(top_length => 160)
    PORT MAP(
        clk => top_clk,
        reset => top_rst,
        sha_digest => hash_reg,
        hsync => top_hsync,
        vsync => top_vsync,
        rgb => top_rgb
    );

    CTRL : PROCESS (slow_clk)
    BEGIN
        IF (falling_edge(slow_clk)) THEN
            IF (top_rst = '1') THEN
                sha_byte <= (OTHERS => '0');
                sha_ena <= '0';
                sha_last <= '0';
                sha_valid_in <= '0';
                hash_reg <= (OTHERS => '0');
                lasted <= '0';
                hashed <= '0';
                ELSE
                -- hash to reg from core
                IF (sha_valid_out = '1' AND hashed = '0') THEN
                    hash_reg <= sha_hash;
                    hashed <= '1';
                END IF;
                -- uart in & last sig
                IF (rx_dv = '1') THEN
                    sha_byte <= rx_byte;
                    sha_ena <= '1';
                    sha_last <= '0';
                    sha_valid_in <= '1';
                    ELSIF (top_last = '1' AND lasted = '0') THEN
                    sha_byte <= (OTHERS => '0');
                    sha_ena <= '0';
                    sha_last <= '1';
                    sha_valid_in <= '1';
                    lasted <= '1';
                    ELSE
                    sha_byte <= (OTHERS => '0');
                    sha_ena <= '0';
                    sha_last <= '0';
                    sha_valid_in <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;

    top_lasted <= lasted;
END Behavioral;