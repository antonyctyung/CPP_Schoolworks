-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Wed Mar 10 22:48:33 2021
-- Host        : DESKTOP-6CH2PUK running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               D:/Documents/workspace/CPP_Schoolworks/ECE4304/ECE4304_Midterm1/ECE4304_Midterm1_VHDL/ECE4304_Midterm1_VHDL.sim/sim_1/synth/func/xsim/ECE4304_Midterm1_5_tb_func_synth.vhd
-- Design      : ECE4304_Midterm1_5
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity NFA is
  port (
    P_OBUF : out STD_LOGIC_VECTOR ( 0 to 0 );
    Y_IBUF : in STD_LOGIC_VECTOR ( 1 downto 0 );
    X_IBUF : in STD_LOGIC_VECTOR ( 1 downto 0 )
  );
end NFA;

architecture STRUCTURE of NFA is
begin
S: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7888"
    )
        port map (
      I0 => Y_IBUF(0),
      I1 => X_IBUF(1),
      I2 => X_IBUF(0),
      I3 => Y_IBUF(1),
      O => P_OBUF(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity \NFA__parameterized1\ is
  port (
    P_OBUF : out STD_LOGIC_VECTOR ( 3 downto 0 );
    X_IBUF : in STD_LOGIC_VECTOR ( 2 downto 0 );
    Y_IBUF : in STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of \NFA__parameterized1\ : entity is "NFA";
end \NFA__parameterized1\;

architecture STRUCTURE of \NFA__parameterized1\ is
begin
C_5: unisim.vcomponents.LUT6
    generic map(
      INIT => X"E800880000000000"
    )
        port map (
      I0 => X_IBUF(1),
      I1 => Y_IBUF(1),
      I2 => X_IBUF(0),
      I3 => Y_IBUF(2),
      I4 => Y_IBUF(0),
      I5 => X_IBUF(2),
      O => P_OBUF(3)
    );
\P_OBUF[2]_inst_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"535F6CA0ACA06CA0"
    )
        port map (
      I0 => X_IBUF(2),
      I1 => X_IBUF(1),
      I2 => Y_IBUF(0),
      I3 => Y_IBUF(1),
      I4 => X_IBUF(0),
      I5 => Y_IBUF(2),
      O => P_OBUF(0)
    );
\P_OBUF[3]_inst_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5B6C0CCC77008000"
    )
        port map (
      I0 => X_IBUF(0),
      I1 => Y_IBUF(1),
      I2 => Y_IBUF(0),
      I3 => X_IBUF(1),
      I4 => Y_IBUF(2),
      I5 => X_IBUF(2),
      O => P_OBUF(1)
    );
\P_OBUF[4]_inst_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"937FC00088000000"
    )
        port map (
      I0 => X_IBUF(0),
      I1 => Y_IBUF(1),
      I2 => Y_IBUF(0),
      I3 => X_IBUF(1),
      I4 => Y_IBUF(2),
      I5 => X_IBUF(2),
      O => P_OBUF(2)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity ECE4304_Midterm1_5 is
  port (
    X : in STD_LOGIC_VECTOR ( 2 downto 0 );
    Y : in STD_LOGIC_VECTOR ( 2 downto 0 );
    P : out STD_LOGIC_VECTOR ( 5 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of ECE4304_Midterm1_5 : entity is true;
  attribute N : integer;
  attribute N of ECE4304_Midterm1_5 : entity is 3;
end ECE4304_Midterm1_5;

architecture STRUCTURE of ECE4304_Midterm1_5 is
  signal P_OBUF : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal X_IBUF : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal Y_IBUF : STD_LOGIC_VECTOR ( 2 downto 0 );
begin
\NFA_GEN[1].NFAUnit\: entity work.NFA
     port map (
      P_OBUF(0) => P_OBUF(1),
      X_IBUF(1 downto 0) => X_IBUF(1 downto 0),
      Y_IBUF(1 downto 0) => Y_IBUF(1 downto 0)
    );
\NFA_GEN[2].NFAUnit\: entity work.\NFA__parameterized1\
     port map (
      P_OBUF(3 downto 0) => P_OBUF(5 downto 2),
      X_IBUF(2 downto 0) => X_IBUF(2 downto 0),
      Y_IBUF(2 downto 0) => Y_IBUF(2 downto 0)
    );
\P_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => P_OBUF(0),
      O => P(0)
    );
\P_OBUF[0]_inst_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => Y_IBUF(0),
      I1 => X_IBUF(0),
      O => P_OBUF(0)
    );
\P_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => P_OBUF(1),
      O => P(1)
    );
\P_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => P_OBUF(2),
      O => P(2)
    );
\P_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => P_OBUF(3),
      O => P(3)
    );
\P_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => P_OBUF(4),
      O => P(4)
    );
\P_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => P_OBUF(5),
      O => P(5)
    );
\X_IBUF[0]_inst\: unisim.vcomponents.IBUF
     port map (
      I => X(0),
      O => X_IBUF(0)
    );
\X_IBUF[1]_inst\: unisim.vcomponents.IBUF
     port map (
      I => X(1),
      O => X_IBUF(1)
    );
\X_IBUF[2]_inst\: unisim.vcomponents.IBUF
     port map (
      I => X(2),
      O => X_IBUF(2)
    );
\Y_IBUF[0]_inst\: unisim.vcomponents.IBUF
     port map (
      I => Y(0),
      O => Y_IBUF(0)
    );
\Y_IBUF[1]_inst\: unisim.vcomponents.IBUF
     port map (
      I => Y(1),
      O => Y_IBUF(1)
    );
\Y_IBUF[2]_inst\: unisim.vcomponents.IBUF
     port map (
      I => Y(2),
      O => Y_IBUF(2)
    );
end STRUCTURE;
