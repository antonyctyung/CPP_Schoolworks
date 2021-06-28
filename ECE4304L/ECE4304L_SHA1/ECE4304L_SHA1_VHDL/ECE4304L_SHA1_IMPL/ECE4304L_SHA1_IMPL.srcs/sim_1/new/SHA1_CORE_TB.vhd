LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SHA1_CORE_TB IS
    --  Port ( );
END SHA1_CORE_TB;

ARCHITECTURE Behavioral OF SHA1_CORE_TB IS

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

    SIGNAL tb_clk : STD_LOGIC;
    SIGNAL tb_rst : STD_LOGIC;
    SIGNAL tb_valid_in : STD_LOGIC;
    SIGNAL tb_last : STD_LOGIC;
    SIGNAL tb_valid_out : STD_LOGIC;
    SIGNAL tb_ready_in : STD_LOGIC;
    SIGNAL tb_byte : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL tb_hash : STD_LOGIC_VECTOR(159 DOWNTO 0);
    CONSTANT clock_period : TIME := 10 ns;

BEGIN

    UUT : SHA1_CORE
    PORT MAP(
        clk => tb_clk,
        rst_in => tb_rst,
        byte => tb_byte,
        valid_in => tb_valid_in,
        last => tb_last,
        hash => tb_hash,
        valid_out => tb_valid_out,
        ready_in => tb_ready_in
    );

    CLK_GEN : PROCESS
    BEGIN
        tb_clk <= '0';
        WAIT FOR 0.5 * clock_period;
        tb_clk <= '1';
        WAIT FOR 0.5 * clock_period;
    END PROCESS;

    INIT_RST : PROCESS
    BEGIN
        tb_rst <= '1';
        WAIT FOR clock_period;
        tb_rst <= '0';
        WAIT;
    END PROCESS;

    MAIN : PROCESS
    BEGIN
        tb_valid_in <= '0';
        tb_last <= '0';
        tb_byte <= "00000000";
        WAIT FOR 20*clock_period;
        tb_valid_in <= '1';
        tb_byte <= "01100001";
        WAIT FOR clock_period;
        tb_valid_in <= '0';
        WAIT FOR 30*clock_period;
        tb_valid_in <= '1';
        tb_byte <= "01100010";
        WAIT FOR clock_period;
        tb_valid_in <= '0';
        WAIT FOR 40*clock_period;
        tb_valid_in <= '1';
        tb_byte <= "01100011";
        WAIT FOR clock_period;
        tb_valid_in <= '0';
        WAIT FOR 50*clock_period;
        tb_valid_in <= '1';
        tb_last <= '1';
        WAIT FOR clock_period;
        tb_valid_in <= '0';
        WAIT;
    END PROCESS;

END Behavioral;