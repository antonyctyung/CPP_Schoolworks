library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity top is
    Port ( 
        top_clk: in std_logic;
        top_rst: in std_logic;
        top_rx: in std_logic;
        top_pull_A: in std_logic;
        top_pull_B: in std_logic;
        top_opcode: in std_logic_vector(1 downto 0);
        top_barrel_sel: in std_logic_vector(2 downto 0);
        top_empty_A: out std_logic;
        top_empty_B: out std_logic;
        top_full_A: out std_logic;
        top_full_B: out std_logic;
        top_a_to_g: out std_logic_vector(6 downto 0);
        top_an: out std_logic_vector(7 downto 0);
        top_dp: out std_logic
    );
end top;

architecture Behavioral of top is

    constant baud : integer := 115200;
    constant top_g_clks_per_bit : integer := 100000000/baud;

    component hexAU IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        C : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
    END component;

    component UART_RX is
    generic (
        g_CLKS_PER_BIT : integer := top_g_clks_per_bit  -- Needs to be set correctly
        );
    port (
        i_Clk       : in  std_logic;
        i_reset     : in  std_logic; 
        i_RX_Serial : in  std_logic;
        ReadEn      : in  std_logic;
        DATAOUT_FIFO: out std_logic_vector(7 downto 0);
        Empty       : out std_logic; 
        Full        : out std_logic 
        );
    end component;

    component barrel is
        generic(N:integer:=8); -- n is the size of the barrel shifter output
        Port (
                barrel_in : in std_logic_vector(N-1 downto 0);
                barrel_sel: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
                barrel_out: out std_logic_vector(N-1 downto 0)
             );
             
    end component;

    component aly_fifo is
        generic(g_DEPTH:positive:=4; g_WIDTH:positive:= 8); 
        Port ( clk        : in  STD_LOGIC;
               i_rst_sync : in  STD_LOGIC;
               i_wr_en    : in  STD_LOGIC;
               i_wr_data  : in  STD_LOGIC_VECTOR (g_WIDTH-1 downto 0);
               o_full     : out STD_LOGIC;
               i_rd_en    : in  STD_LOGIC;
               o_rd_data  : out STD_LOGIC_VECTOR (g_WIDTH-1 downto 0);
               o_empty    : out STD_LOGIC
             );
    end component;

    component STD_FIFO is
        Generic (
            constant DATA_WIDTH : positive :=   8;
            constant FIFO_DEPTH	: positive := 256
        );
        Port ( 
            CLK     : in  STD_LOGIC;
            RST     : in  STD_LOGIC;
            WriteEn : in  STD_LOGIC;
            DataIn  : in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            ReadEn  : in  STD_LOGIC;
            DataOut : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            Empty   : out STD_LOGIC;
            Full    : out STD_LOGIC
        );
    end component;

    component ctrl7seg is
        generic(CLKDIV:integer:=13); -- number of FF for clock dividing
        Port (
            c7s_clk     :   in  std_logic;
            c7s_rst     :   in  std_logic;
            c7s_x0      :   in  std_logic_vector(3 downto 0);
            c7s_x1      :   in  std_logic_vector(3 downto 0);
            c7s_x2      :   in  std_logic_vector(3 downto 0);
            c7s_x3      :   in  std_logic_vector(3 downto 0);
            c7s_x4      :   in  std_logic_vector(3 downto 0);
            c7s_x5      :   in  std_logic_vector(3 downto 0);
            c7s_x6      :   in  std_logic_vector(3 downto 0);
            c7s_x7      :   in  std_logic_vector(3 downto 0);
            c7s_en      :   in  std_logic_vector(7 downto 0);   -- digit            (active high)   enable
            c7s_a_to_g  :   out std_logic_vector(6 downto 0);   -- MSB(abcdefg)LSB
            c7s_an      :   out std_logic_vector(7 downto 0);   -- digit            (active low)    enable
            c7s_dp      :   out std_logic
        );
    end component;

    signal rx_pull: std_logic;
    signal rx_empty: std_logic;
    signal rx_full: std_logic;
    signal rx_data: std_logic_vector(7 downto 0);

    signal A_fifo_push: std_logic;
    signal A_fifo_pull: std_logic;
    signal A_fifo_full: std_logic;
    signal A_fifo_empty: std_logic;
    signal A_fifo_data: std_logic_vector(7 downto 0);

    signal B_fifo_push: std_logic;
    signal B_fifo_pull: std_logic;
    signal B_fifo_full: std_logic;
    signal B_fifo_empty: std_logic;
    signal B_fifo_data: std_logic_vector(7 downto 0);

    signal top_A: std_logic_vector(7 downto 0);
    signal top_B: std_logic_vector(7 downto 0);
    signal top_C: std_logic_vector(15 downto 0);

    signal top_pull_A_last: std_logic;
    signal top_pull_B_last: std_logic;

begin

    UART: UART_RX
    generic map(g_CLKS_PER_BIT => top_g_clks_per_bit)
    port map(
        i_Clk           => top_clk,
        i_reset         => top_rst, 
        i_RX_Serial     => top_rx,
        ReadEn          => rx_pull,
        DATAOUT_FIFO    => rx_data,
        Empty           => rx_empty, 
        Full            => rx_full
        );

    -- FIFO_A: aly_fifo
    -- generic map(g_DEPTH => 4, g_WIDTH => 8)
    -- port map(
    --     clk        => top_clk,
    --     i_rst_sync => top_rst,
    --     i_wr_en    => A_fifo_push,
    --     i_wr_data  => rx_data,
    --     o_full     => A_fifo_full,
    --     i_rd_en    => A_fifo_pull,
    --     o_rd_data  => A_fifo_data,
    --     o_empty    => A_fifo_empty
    -- );

    -- FIFO_B: aly_fifo
    -- generic map(g_DEPTH => 4, g_WIDTH => 8)
    -- port map(
    --     clk        => top_clk,
    --     i_rst_sync => top_rst,
    --     i_wr_en    => B_fifo_push,
    --     i_wr_data  => rx_data,
    --     o_full     => B_fifo_full,
    --     i_rd_en    => B_fifo_pull,
    --     o_rd_data  => B_fifo_data,
    --     o_empty    => B_fifo_empty
    -- );

    FIFO_A: STD_FIFO
    generic map(FIFO_DEPTH => 4, DATA_WIDTH => 8)
    port map(
            CLK     => top_clk,
            RST     => top_rst,
            WriteEn => A_fifo_push,
            DataIn  => rx_data,
            ReadEn  => A_fifo_pull,
            DataOut => A_fifo_data,
            Empty   => A_fifo_empty,
            Full    => A_fifo_full
    );

    FIFO_B: STD_FIFO
    generic map(FIFO_DEPTH => 4, DATA_WIDTH => 8)
    port map(
            CLK     => top_clk,
            RST     => top_rst,
            WriteEn => B_fifo_push,
            DataIn  => rx_data,
            ReadEn  => B_fifo_pull,
            DataOut => B_fifo_data,
            Empty   => B_fifo_empty,
            Full    => B_fifo_full
    );

    barrel_A: barrel
        generic map(N=>8)
        Port map(
            barrel_in  => A_fifo_data,
            barrel_sel => top_barrel_sel,
            barrel_out => top_A
        );

    barrel_B: barrel
        generic map(N=>8)
        Port map(
            barrel_in  => B_fifo_data,
            barrel_sel => top_barrel_sel,
            barrel_out => top_B
        );

    AU: hexAU
        port map(
            opcode => top_opcode,
            A => top_A,
            B => top_B,
            C => top_C
        );
    
    C7S : ctrl7seg
        GENERIC MAP(CLKDIV => 13)
        PORT MAP(
          c7s_clk => top_clk,
          c7s_rst => top_rst,
          c7s_x0 => top_C(3 downto 0),
          c7s_x1 => top_C(7 downto 4), 
          c7s_x2 => top_C(11 downto 8),
          c7s_x3 => top_C(15 downto 12),
          c7s_x4 => top_B(3 downto 0),
          c7s_x5 => top_B(7 downto 4),
          c7s_x6 => rx_data(3 downto 0),
          c7s_x7 => rx_data(7 downto 4),
          --c7s_x6 => top_A(3 downto 0),
          --c7s_x7 => top_A(7 downto 4),
          c7s_en => "11111111",
          c7s_a_to_g => top_a_to_g,
          c7s_an => top_an,
          c7s_dp => top_dp
        );
      
    top_empty_A <= A_fifo_empty;
    top_empty_B <= B_fifo_empty;    
    top_full_A <= A_fifo_full;
    top_full_B <= B_fifo_full;

    FILL_CTRL: process(top_clk)
    begin
        if (rising_edge(top_clk)) then
            if (rx_empty = '0') then
                if (A_fifo_full = '0') then
                    rx_pull <= '1';
                    A_fifo_push <= '1';
                    B_fifo_push <= '0';
                else
                    A_fifo_push <= '0';
                    if (B_fifo_full = '0') then
                        rx_pull <= '1';
                        B_fifo_push <= '1';
                    else 
                        rx_pull <= '0';
                        B_fifo_push <= '0';
                    end if;
                end if; 
            end if;
        end if;
    end process;

    PULL_CTRL_A: process(top_clk)
    begin
        if (rising_edge(top_clk)) then
            if ((top_pull_A = '1') and (top_pull_A_last = '0')) then -- top_pull_A rising
                A_fifo_pull <= '1';
                top_pull_A_last <= '1';
            else
                A_fifo_pull <= '0';
                if (top_pull_A = '0') then
                    top_pull_A_last <= '0';
                end if;
            end if;
        end if;
    end process;

    PULL_CTRL_B: process(top_clk)
    begin
        if (rising_edge(top_clk)) then
            if ((top_pull_B = '1') and (top_pull_B_last = '0')) then
                B_fifo_pull <= '1';
                top_pull_B_last <= '1';
            else
                B_fifo_pull <= '0';
                if (top_pull_B = '0') then
                    top_pull_B_last <= '0';
                end if;
            end if;
        end if;
    end process;

end Behavioral;