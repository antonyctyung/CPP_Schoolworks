library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity uart_rx_cir is
    Port ( RxD_in     : in  STD_LOGIC;
           clk        : in  STD_LOGIC;
		   RAZ        : in  STD_LOGIC;
		   rst_dsp    : in  std_logic; 
		  ReadEn      : in  std_logic;
		  dig_c       : out std_logic_vector(6 downto 0); 
		  an          : out std_logic_vector(7 downto 0);
		  dp          : out std_logic; 
		  DATAOUT_FIFO_x: out std_logic_vector(7 downto 0); 
          Empty       : out std_logic; 
          Full        : out std_logic;
          data_valid_uart: out std_logic
                );
end uart_rx_cir;

architecture Behavioral of uart_rx_cir is

	type state_type is (idle, start, demiStart, b0, b1, b2, b3, b4, b5, b6, b7);	     -- States of the FSM 
	signal state :state_type := idle;													 -- Default state
	
	signal RST_UART_counter : STD_LOGIC;										         -- Reset of the counter
	signal UART_counter_internal : integer range 0 to 5210;					             -- Number of clk rising edges to increment counter
	signal UART_counter : integer range 0 to 19;                                         -- Counter value
	
	signal RxD_temp : STD_LOGIC;                                                         -- Temporary RxD between the two FF
	signal RxD_sync : STD_LOGIC;                                                         -- RxD properly synchronized with 100 MHz clk



component top_display
    generic (count_size_top:integer:= 20; AN_SIZE:integer:=8); 
    Port ( clk   : in STD_LOGIC;
           rst   : in STD_LOGIC;
           dig_c : out STD_LOGIC_VECTOR (6 downto 0);
           an    : out STD_LOGIC_VECTOR (AN_SIZE-1 downto 0);
           dp    : out STD_LOGIC; 
           dig_SW: in  std_logic_vector(7 downto 0)
           );
end component;

signal DATAOUT_FIFO: std_logic_vector(7 downto 0); 

 component STD_FIFO 
	Generic (
		constant DATA_WIDTH : positive :=   8;
		constant FIFO_DEPTH	: positive := 256
	);
	Port ( 
		CLK		: in  STD_LOGIC;
		RST		: in  STD_LOGIC;
		WriteEn	: in  STD_LOGIC;
		DataIn	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		ReadEn	: in  STD_LOGIC;
		DataOut	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		Empty	: out STD_LOGIC;
		Full	: out STD_LOGIC
	);
end component;


component module_fifo_regs_no_flags 
  generic (
    g_WIDTH : natural := 8;
    g_DEPTH : integer := 32
    );
  port (
    i_rst_sync : in std_logic;
    i_clk      : in std_logic;
 
    -- FIFO Write Interface
    i_wr_en   : in  std_logic;
    i_wr_data : in  std_logic_vector(g_WIDTH-1 downto 0);
    o_full    : out std_logic;
 
    -- FIFO Read Interface
    i_rd_en   : in  std_logic;
    o_rd_data : out std_logic_vector(g_WIDTH-1 downto 0);
    o_empty   : out std_logic
    );
end component;


signal     data_out   : STD_LOGIC_VECTOR (7 downto 0);
signal     data_valid : STD_LOGIC;

signal op1, op2, op3: std_logic; 

signal op_button:std_logic; 

signal clk_bounce:std_logic; 
signal count_time:std_logic_vector(31 downto 0); 
begin

DATAOUT_FIFO_x <= data_out;
data_valid_uart <= data_valid;


GEN: process(clk, RAZ)
     begin 
        if (RAZ = '1') then 
            count_time <= (others =>'0');
            clk_bounce <= '0';
        elsif(rising_edge(clk)) then 
            if (count_time = 5000) then 
                clk_bounce <= not clk_bounce;
                count_time <= (others =>'0');
            else 
                count_time <= count_time + 1;
            end if; 
        end if; 
     end process; 

D1: process(clk_bounce,RAZ)
    begin 
    if (RAZ = '1') then 
    
        op1 <= '0';
        op2 <= '0';
        op3 <= '0';
    elsif(rising_edge(clk_bounce)) then
        op1 <= ReadEn;
        op2 <= op1;
        op3 <= op2;
    end if; 
    
    end process D1;

op_button <= op1 and op2 and op3; 

DISP: top_display generic map (count_size_top => 20, AN_SIZE =>8)
                  port    map (
                                clk     => clk,
                                rst     => rst_dsp,
                                dig_c   => dig_c,
                                an      => an,
                                dp      => dp,
                                dig_SW  => data_out
                              );
FIFO_NEW: module_fifo_regs_no_flags 
  generic map (
    g_WIDTH => 8,
    g_DEPTH => 32
    )
  port map (
    i_rst_sync => RAZ,
    i_clk      => clk,
 
    -- FIFO Write Interface
    i_wr_en   => data_valid,
    i_wr_data => data_out,
    o_full    => Full,
 
    -- FIFO Read Interface
    i_rd_en    => op_button,
    o_rd_data  => DATAOUT_FIFO,
    o_empty    => Empty
    );



--FIFO: STD_FIFO  generic map ( DATA_WIDTH => 8, FIFO_DEPTH => 4)
--                port map
--                        (
--                         CLK     => clk,
--                         RST     => RAZ, 
--                         WriteEn => (data_valid), 
--                         DataIn  => data_out,
--                         ReadEn  => ReadEn,
--                         DataOut => DATAOUT_FIFO,
--                         Empty   => Empty, 
--                         Full    => Full
--                        );

D_flip_flop_1:process(clk)  -- Clock crossing, first flip flop 
begin
    if clk = '1' and clk'event then
        RxD_temp <= RxD_in;
    end if;
end process;

D_flip_flop_2:process(clk)  -- Clock crossing, second flip flop
begin
    if clk = '1' and clk'event then
        RxD_sync <= RxD_temp;
    end if;
end process;

doubleTickUART:process(clk) -- Counter
begin
	if clk = '1' and clk'event then
	   if ((RAZ='1') or (RST_UART_counter = '1')) then
            UART_counter <= 0;
            UART_counter_internal <= 0;
	   elsif (UART_counter_internal >= 5208) then 
			UART_counter <= (UART_counter + 1);
			UART_counter_internal <= 0;
	   else
			UART_counter_internal <= UART_counter_internal + 1;
	   end if;
	end if;
end process;

fsm:process(clk, RAZ)	-- Finite state machine
begin
    if clk = '1' and clk'event then
        if (RAZ = '1') then
            state <= idle;
            data_out <= "00000000";
            RST_UART_counter <= '1';
            data_valid <= '0';
        else
		  case state is
			when idle => if RxD_sync = '0' then	     -- If in idle and low level detected on RxD_sync
							state <= start;
						 end if;
						 data_valid <= '0';

						 RST_UART_counter <= '1';    -- Prevent from counting while in idle
			when start =>if (UART_counter = 1) then  -- If RxD_sync is low and half a period elapsed
							state <= demiStart;
						end if;
						RST_UART_counter <= '0'; -- Begin counting
						data_out <= "00000000";         -- Reset former output data      
					--	data_valid <= '0';              -- Data is not valid 
			when demiStart => if (UART_counter = 3) then
								state <= b0;
								data_out(0) <= RxD_sync;	-- Acquisition bit 1 of 8
							  end if;
			when b0 =>	if (UART_counter = 5) then
							state <= b1;
							data_out(1) <= RxD_sync;	-- Acquisition bit 2 of 8
						end if;
			when b1 =>	if (UART_counter = 7) then
							state <= b2;
							data_out(2) <= RxD_sync;	-- Acquisition bit 3 of 8
						end if;
			when b2 =>	if (UART_counter = 9) then
							state <= b3;
							data_out(3) <= RxD_sync;	-- Acquisition bit 4 of 8
						end if;
			when b3 =>	if (UART_counter = 11) then
							state <= b4;
							data_out(4) <= RxD_sync;	-- Acquisition bit 5 of 8
						end if;
			when b4 =>	if (UART_counter = 13) then
							state <= b5;
							data_out(5) <= RxD_sync;	-- Acquisition bit 6 of 8
						end if;
			when b5 =>	if (UART_counter = 15) then
							state <= b6;
							data_out(6) <= RxD_sync;	-- Acquisition bit 7 of 8
						end if;
			when b6 =>	if (UART_counter = 17) then
							state <= b7;	
							data_out(7) <= RxD_sync;	-- Acquisition bit 8 of 8
						end if;
			when b7 =>	if (UART_counter = 19) then
							state <= idle;              -- state <= idle
				    --     if (UART_counter_internal = 0) then 
							data_valid <= '1';          -- Data becomes valid
					 --    else 
					--        data_valid <= '0';
					--     end if; 
						end if;
			when others =>
			 state <= idle;
		end case;
	   end if;
	end if;
end process;
end Behavioral;