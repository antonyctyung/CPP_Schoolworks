-- Listing 13.10
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pong_top is
   generic(top_length:integer:=160);
   port(
      clk, reset: in std_logic;
      sha_digest : in std_logic_vector(top_length-1 downto 0);
      hsync, vsync: out std_logic;
      rgb: out   std_logic_vector (11 downto 0)
   );
end pong_top;

architecture arch of pong_top is
   type state_type is (newgame, play, newball, over);
   signal video_on, pixel_tick: std_logic;
   signal pixel_x, pixel_y: std_logic_vector (9 downto 0);
   signal text_on: std_logic_vector(3 downto 0);
   signal  text_rgb: std_logic_vector(11 downto 0);
   signal rgb_reg, rgb_next: std_logic_vector(11 downto 0);
   signal state_reg, state_next: state_type;
   signal dig0, dig1: std_logic_vector(3 downto 0);
   signal d_inc, d_clr: std_logic;
   signal timer_tick, timer_start, timer_up: std_logic;
   signal ball_reg, ball_next: unsigned(1 downto 0);
   signal ball: std_logic_vector(1 downto 0);
   
   component clk_wiz_0 
     port (
           clk_out1  : out std_logic; 
           reset  : in  std_logic; 
           locked : out std_logic;
           clk_in1: in  std_logic
          );
end component;

signal locked_pll: std_logic;
signal clk_out_ns: std_logic;
signal clk_out: std_logic;

signal sha_const: std_logic_vector(top_length-1 downto 0);
   
begin

sha_const <= "1110001011100010001111000111100011100010011100001110000000001110001000101100011100001110111000101010101100011100010001111100001101111011100001001010010100011101";

CLK_GEN_PLL: clk_wiz_0 port map ( 
                                   clk_out1   => clk_out_ns, 
                                   reset   => reset,
                                   locked  => locked_pll,
                                   clk_in1 => clk
                                );
clk_out <= locked_pll and clk_out_ns;

   -- instantiate video synchonization unit
   vga_sync_unit: entity work.vga_driver
      port map(clk=>clk_out, reset=>reset,
               hsync=>hsync, vsync=>vsync,
               pixel_x=>pixel_x, pixel_y=>pixel_y,
               video_on=>video_on, p_tick=>pixel_tick);
   -- instantiate text module
   ball <= std_logic_vector(ball_reg);  --type conversion
   text_unit: entity work.text_gen
      generic map(length => top_length)
      port map(clk=>clk_out, reset=>reset,
               pixel_x=>pixel_x, pixel_y=>pixel_y,
               sha_digest => sha_digest,
               --sha_digest => sha_const,
               --dig0=>dig0, dig1=>dig1,
               ball=>ball,
               text_on=>text_on, text_rgb=>text_rgb);

--   -- registers
   process (clk_out,reset)
   begin
      if reset='1' then
         state_reg <= newgame;
         ball_reg <= (others=>'0');
         rgb_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         ball_reg <= ball_next;
         if (pixel_tick='1') then
           rgb_reg <= rgb_next;
         end if;
      end if;
   end process;

--   -- rgb multiplexing circuit
   process(state_reg,video_on,text_on,text_rgb)
   begin
      if video_on='0' then
         rgb_next <= "000000000000"; -- blank the edge/retrace
      else
         -- display score, rule or game over
         if (text_on(3)='1') or
            (state_reg=newgame and text_on(1)='1') or -- rule
            (state_reg=over and text_on(0)='1') then
            rgb_next <= text_rgb;
         elsif text_on(2)='1'  then -- display logo
           rgb_next <= text_rgb;
         else
           ---rgb_next <= "110"; -- yellow background
           rgb_next <= "000000000000";
         end if;
      end if;
   end process;
   rgb <= rgb_reg;
   
end arch;