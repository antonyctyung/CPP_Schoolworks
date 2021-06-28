-- Listing 13.6
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity text_gen is
   generic(length:integer:= 160);
   port(
      clk, reset: in std_logic;
      pixel_x, pixel_y: in std_logic_vector(9 downto 0);
      sha_digest : in std_logic_vector(length-1 downto 0);
     -- dig0, dig1: in std_logic_vector(3 downto 0);
      ball: in std_logic_vector(1 downto 0);
      text_on: out std_logic_vector(3 downto 0);
      text_rgb: out std_logic_vector(11 downto 0)
   );
end text_gen;

architecture arch of text_gen is
    signal dig0, dig1: std_logic_vector(3 downto 0);

   signal pix_x, pix_y: unsigned(9 downto 0);
   signal rom_addr: std_logic_vector(10 downto 0);
   signal char_addr, char_addr_s, char_addr_l, char_addr_r,
          char_addr_o: std_logic_vector(6 downto 0);
   signal row_addr, row_addr_s, row_addr_l,row_addr_r,
          row_addr_o: std_logic_vector(3 downto 0);
   signal bit_addr, bit_addr_s, bit_addr_l,bit_addr_r,
          bit_addr_o: std_logic_vector(2 downto 0);
   signal font_word: std_logic_vector(7 downto 0);
   signal font_bit: std_logic;
   signal score_on, logo_on, rule_on, over_on: std_logic;
   signal rule_rom_addr: unsigned(5 downto 0);
   type rule_rom_type is array (0 to 63) of
       std_logic_vector (6 downto 0);
       
   --type sha is array (0 to 3) of std_logic_vector((length/4)-1 downto 0);
   type sha is array (0 to (length/4)-1) of std_logic_vector(3 downto 0);
   signal digest_bit: sha;
   -- rull text ROM definition
   constant RULE_ROM: rule_rom_type :=
   (
      -- row 1
      "0000000", --
      "0000000", --
      "1010011", -- S x53
      "1001000", -- H x48
      "1000001", -- A x41
      "0101101", -- - x2d
      "0110001", -- 1 x31
      "0000000", -- 
      "1000010", -- B x42
      "1011001", -- Y x59
      "1100001", -- : x3a
      "0000000", --
      "0000000", --
      "0000000", --
      "0000000", --
      "0000000", --
      -- row 2
      "1000001", -- A
      "1001110", -- N
      "1010100", -- T
      "1001111", -- O
      "1001110", -- N
      "1011001", -- Y
      "0000000", -- 
      "0000000", -- 
      "1011001", -- Y
      "1010101", -- U
      "1001110", -- N
      "1000111", -- G
      "0000000", -- 
      "0000000", -- 
      "0000000", -- 
      "0000000", --
      -- row 3
      "1001100", -- L
      "1000001", -- A
      "1010101", -- U
      "1010010", -- R
      "1001001", -- I
      "1000011", -- C
      "1000101", -- E
      "0000000", --
      "1010011", -- S
      "1000001", -- A
      "1010100", -- T
      "1010100", -- T
      "1001111", -- O
      "1010101", -- U
      "1000110", -- F
      "0000000", --
      -- row 4
      "1000100", -- D
      "1001001", -- I
      "1001101", -- M
      "1001001", -- I
      "1010100", -- T
      "1010010", -- R
      "1001001", -- I
      "0000000", --  
      "1000111", -- G
      "1000001", -- A
      "1010010", -- R
      "1000011", -- C
      "1001001", -- I
      "1000001", -- A
      "0000000", --
      "0000000"  --
   );
begin

    process(clk)
    begin
        for i in 0 to (length/4)-1 loop
            digest_bit(i) <= sha_digest(4*(i)+3 downto 4*i);
        end loop;
    end process;


   dig1 <= sha_digest(7 downto 4);
   dig0 <= sha_digest(3 downto 0);
   
   pix_x <= unsigned(pixel_x);
   pix_y <= unsigned(pixel_y);
   -- instantiate font rom
   font_unit: entity work.font_gen
      port map(clk=>clk, addr=>rom_addr, data=>font_word);

   ---------------------------------------------
   -- Digest region
   --  - display Digest in hex
   --  - scale to 16-by-32 font
   ---------------------------------------------
   score_on <=
--      '1' when pix_y(9 downto 5)=1 and
--               pix_x(9 downto 4)<40 else
--      '0';
--   row_addr_s <= std_logic_vector(pix_y(4 downto 1));
--   bit_addr_s <= std_logic_vector(pix_x(3 downto 1));

      '1' when pix_y(9 downto 4)=1 and
               pix_x(9 downto 4)<50 else
      '0';
   row_addr_s <= std_logic_vector(pix_y(3 downto 0));
   bit_addr_s <= std_logic_vector(pix_x(2 downto 0));
   
   with pix_x(9 downto 3) select
     char_addr_s <=
        "1000100" when "000000", -- D x44
        "1001001" when "000001", -- I x49
        "1000111" when "000010", -- G x47
        "1000101" when "000011", -- E x45
        "1010011" when "000100", -- S x53
        "1010100" when "000101", -- T x54
        "1100001" when "000110", -- : x61   --Changed ASCII to work with hex
        "0110000" when "000111", -- 0 x30
        "1111000" when "001000", -- x x78
        "011" & digest_bit(39) when "001001", -- digit 29
        "011" & digest_bit(38) when "001010", -- digit 28
        "011" & digest_bit(37) when "001011", -- digit 27
        "011" & digest_bit(36) when "001100", -- digit 26
        "011" & digest_bit(35) when "001101", -- 
        "011" & digest_bit(34) when "001110", -- 
        "011" & digest_bit(33) when "001111", --
        "011" & digest_bit(32) when "010000", --
        "011" & digest_bit(31) when "010001", -- 
        "011" & digest_bit(30) when "010010", -- 
        "011" & digest_bit(29) when "010011", --
        "011" & digest_bit(28) when "010100", -- 
        "011" & digest_bit(27) when "010101", -- 
        "011" & digest_bit(26) when "010110", -- 
        "011" & digest_bit(25) when "010111", -- 
        "011" & digest_bit(24) when "011000", -- 
        "011" & digest_bit(23) when "011001", -- 
        "011" & digest_bit(22) when "011010", -- 
        "011" & digest_bit(21) when "011011", -- 
        "011" & digest_bit(20) when "011100", -- 
        "011" & digest_bit(19)  when "011101", -- 
        "011" & digest_bit(18)  when "011110", -- 
        "011" & digest_bit(17)  when "011111", -- 
        "011" & digest_bit(16)  when "100000", -- 
        "011" & digest_bit(15)  when "100001", -- 
        "011" & digest_bit(14)  when "100010", -- 
        "011" & digest_bit(13)  when "100011", -- 
        "011" & digest_bit(12)  when "100100", -- 
        "011" & digest_bit(11)  when "100101", -- 
        "011" & digest_bit(10)  when "100110", -- digit 0
        "011" & digest_bit(9) when "100111",
        "011" & digest_bit(8) when "101000",
        "011" & digest_bit(7) when "101001",
        "011" & digest_bit(6) when "101010",
        "011" & digest_bit(5) when "101011",
        "011" & digest_bit(4) when "101100",
        "011" & digest_bit(3) when "101101",
        "011" & digest_bit(2) when "101110",
        "011" & digest_bit(1) when "101111",
        "011" & digest_bit(0) when "110000",
        "0000000" when others;
   ---------------------------------------------
   -- logo region:
   --   - display logo "PONG" on top center
   --   - used as background
   --   - scale to 64-by-128 font
   ---------------------------------------------
   logo_on <=
      '0' when pix_y(9 downto 7)=2 and
         (3<= pix_x(9 downto 6) and pix_x(9 downto 6)<=7) else
      '0';
   row_addr_l <= std_logic_vector(pix_y(6 downto 3));
   bit_addr_l <= std_logic_vector(pix_x(5 downto 3));
   with pix_x(8 downto 6) select
     char_addr_l <=
        "1010011" when "011", -- S x53
        "1001000" when "100", -- H x48
        "1000001" when "101", -- A x41
        "0101101" when "110", -- - x2d
        "0110001" when others; -- 1 x31
   ---------------------------------------------
   -- Watermark region
   --   - display rule (4-by-16 tiles)on center
   --   - Watermark text:
   --        SHA-1 By:
   --        our names
   ---------------------------------------------
   rule_on <= 
                '1' when pix_x(9 downto 7) = "000" and
                       pix_y(9 downto 6)=  "0010"  else
                '0';
   row_addr_r <= std_logic_vector(pix_y(3 downto 0));
   bit_addr_r <= std_logic_vector(pix_x(2 downto 0));
   rule_rom_addr <= pix_y(5 downto 4) & pix_x(6 downto 3);
   char_addr_r <= RULE_ROM(to_integer(rule_rom_addr));
   ---------------------------------------------
   -- game over region
   --  - display }Game Over" on center
   --  - scale to 32-by-64 fonts
   ---------------------------------------------
   over_on <=
      '0' when pix_y(9 downto 6)=3 and
         5<= pix_x(9 downto 5) and pix_x(9 downto 5)<=13 else
      '0';
--   row_addr_o <= std_logic_vector(pix_y(5 downto 2));
--   bit_addr_o <= std_logic_vector(pix_x(4 downto 2));
   with pix_x(8 downto 5) select
     char_addr_o <=
        "1000111" when "0101", -- G x47
        "1100001" when "0110", -- a x61
        "1101101" when "0111", -- m x6d
        "1100101" when "1000", -- e x65
        "0000000" when "1001", --
        "1001111" when "1010", -- O x4f
        "1110110" when "1011", -- v x76
        "1100101" when "1100", -- e x65
        "1110010" when others; -- r x72
   ---------------------------------------------
   -- mux for font ROM addresses and rgb
   ---------------------------------------------
   process(score_on,logo_on,rule_on,pix_x,pix_y,font_bit,
           char_addr_s,char_addr_l,char_addr_r,char_addr_o,
           row_addr_s,row_addr_l,row_addr_r,row_addr_o,
           bit_addr_s,bit_addr_l,bit_addr_r,bit_addr_o)
   begin
--      text_rgb <= "110";  -- background, yellow
        text_rgb <= "000000000000";
      if score_on='1' then
         char_addr <= char_addr_s;
         row_addr <= row_addr_s;
         bit_addr <= bit_addr_s;
         if font_bit='1' then
--            text_rgb <= "001";
              text_rgb <= "111111111111";
         end if;
      elsif rule_on='1' then
         char_addr <= char_addr_r;
         row_addr <= row_addr_r;
         bit_addr <= bit_addr_r;
         if font_bit='1' then
--            text_rgb <= "001";
              text_rgb <= "111111111111";
         end if;
      elsif logo_on='1' then
         char_addr <= char_addr_l;
         row_addr <= row_addr_l;
         bit_addr <= bit_addr_l;
         if font_bit='1' then
--            text_rgb <= "011";
              text_rgb <= "111111111111";
         end if;
      else -- game over
         char_addr <= char_addr_o;
         row_addr <= row_addr_o;
         bit_addr <= bit_addr_o;
         if font_bit='1' then
--            text_rgb <= "001";
              text_rgb <= "111111111111";
         end if;
      end if;
   end process;
   text_on <= score_on & logo_on & rule_on & over_on;
   ---------------------------------------------
   -- font rom interface
   ---------------------------------------------
   rom_addr <= char_addr & row_addr;
   font_bit <= font_word(to_integer(unsigned(not bit_addr)));
end arch;