----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2021 06:12:51 PM
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



-- Instruction on how to control the simple custom ALU unit (TOP) 

-- top_inst(4) --- representing load for port A up-down counter 
-- top_inst(3) --- represrenting ud control signal for port A up-down counter 
-- top_inst(2) --- representing load for port B up-down counter
-- top_inst(1) --- represrenting ud control signal for port B up-down counter 
-- top_inst(0) --- represrenting add and subtract signal for controlling the ADD/SUB unit  


entity top is
    generic (top_WIDTH:integer:= 4);
    Port ( 
            top_clk      : in std_logic; 
            top_rst      : in std_logic; 
            top_inst     : in std_logic_vector(4 downto 0); 
            top_port_A   : in std_logic_vector(top_WIDTH-1 downto 0); 
            top_port_B   : in std_logic_vector(top_WIDTH-1 downto 0); 
            top_port_out : out std_logic_vector(top_width-1 downto 0);
            top_port_cout: out std_logic
         );
end top;

architecture Behavioral of top is

component generic_counter
    generic(C_WIDTH:integer:=4); 
    Port   (clk   : in  STD_LOGIC;
            rst   : in  STD_LOGIC;
            load  : in STD_LOGIC; 
            ud    : in  STD_LOGIC;
            i_cont: in  STD_LOGIC_VECTOR(C_WIDTH-1 downto 0); 
            count : out STD_LOGIC_VECTOR (C_WIDTH-1 downto 0)
           );
end component;

component NFA 
       generic (WIDTH:integer:= 4); 
       Port (
              NFA_CIN      : in  std_logic; 
              NFA_PORT_A   : in  std_logic_vector(WIDTH-1 downto 0); 
              NFA_PORT_B   : in  std_logic_vector(WIDTH-1 downto 0); 
              NFA_PORT_Sum : out std_logic_vector(WIDTH-1 downto 0); 
              NFA_PORT_COUT: out std_logic     
            );
end component;

signal generic_counter_PORT_A: std_logic_vector(top_WIDTH-1 downto 0); 
signal generic_counter_PORT_B: std_logic_vector(top_WIDTH-1 downto 0); 


begin


GCOUNT_A: generic_counter generic map (C_WIDTH => top_WIDTH)
                          port    map (
                                       clk     => top_clk, 
                                       rst     => top_rst, 
                                       load    => top_inst(4),
                                       ud      => top_inst(3),
                                       i_cont => top_port_A,
                                       count   => generic_counter_PORT_A
                                      ); 
                                      

GCOUNT_B: generic_counter generic map (C_WIDTH => top_WIDTH)
                          port    map (
                                       clk     => top_clk, 
                                       rst     => top_rst, 
                                       load    => top_inst(2),
                                       ud      => top_inst(1),
                                       i_cont => top_port_B,
                                       count   => generic_counter_PORT_B
                                      ); 
                                      

NFA_COMP: NFA  generic map (WIDTH =>   top_WIDTH)
               port    map (
                                NFA_CIN       => top_inst(0),
                                NFA_PORT_A    => generic_counter_PORT_A, 
                                NFA_PORT_B    => generic_counter_PORT_B, 
                                NFA_PORT_Sum  => top_port_out,
                                NFA_PORT_COUT => top_port_cout
                           );                                   


end Behavioral;
