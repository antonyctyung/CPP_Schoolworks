
c
Command: %s
53*	vivadotcl22
write_bitstream -force top.bit2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7a100t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7a100t2default:defaultZ17-349h px� 
x
,Running DRC as a precondition to command %s
1349*	planAhead2#
write_bitstream2default:defaultZ12-1349h px� 
>
IP Catalog is up to date.1232*coregenZ19-1839h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
�
�Missing CFGBVS and CONFIG_VOLTAGE Design Properties: Neither the CFGBVS nor CONFIG_VOLTAGE voltage property is set in the current_design.  Configuration bank voltage select (CFGBVS) must be set to VCCO or GND, and CONFIG_VOLTAGE must be set to the correct configuration voltage, in order to determine the I/O voltage support for the pins in bank 0.  It is suggested to specify these either using the 'Edit Device Properties' function in the GUI or directly in the XDC file using the following syntax:

 set_property CFGBVS value1 [current_design]
 #where value1 is either VCCO or GND

 set_property CONFIG_VOLTAGE value2 [current_design]
 #where value2 is the voltage provided to configuration bank 0

Refer to the device configuration user guide for more information.%s*DRC2(
 DRC|Pin Planning2default:default8ZCFGBVS-1h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "t
.BCD_GEN[0].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1_n_0.BCD_GEN[0].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1_n_02default:default2default:default2�
 "p
,BCD_GEN[0].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1/O,BCD_GEN[0].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1/O2default:default2default:default2�
 "l
*BCD_GEN[0].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1	*BCD_GEN[0].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2l
 "V
BCD_GEN[0].BCD_UNIT/bcd_ud_edgeBCD_GEN[0].BCD_UNIT/bcd_ud_edge2default:default2default:default2~
 "h
(BCD_GEN[0].BCD_UNIT/bcd_ud_buf_reg_i_1/O(BCD_GEN[0].BCD_UNIT/bcd_ud_buf_reg_i_1/O2default:default2default:default2z
 "d
&BCD_GEN[0].BCD_UNIT/bcd_ud_buf_reg_i_1	&BCD_GEN[0].BCD_UNIT/bcd_ud_buf_reg_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "z
1BCD_GEN[1].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__0_n_01BCD_GEN[1].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__0_n_02default:default2default:default2�
 "v
/BCD_GEN[1].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__0/O/BCD_GEN[1].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__0/O2default:default2default:default2�
 "r
-BCD_GEN[1].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__0	-BCD_GEN[1].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__02default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2l
 "V
BCD_GEN[1].BCD_UNIT/bcd_ud_edgeBCD_GEN[1].BCD_UNIT/bcd_ud_edge2default:default2default:default2�
 "n
+BCD_GEN[1].BCD_UNIT/bcd_ud_buf_reg_i_1__0/O+BCD_GEN[1].BCD_UNIT/bcd_ud_buf_reg_i_1__0/O2default:default2default:default2�
 "j
)BCD_GEN[1].BCD_UNIT/bcd_ud_buf_reg_i_1__0	)BCD_GEN[1].BCD_UNIT/bcd_ud_buf_reg_i_1__02default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "z
1BCD_GEN[2].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__1_n_01BCD_GEN[2].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__1_n_02default:default2default:default2�
 "v
/BCD_GEN[2].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__1/O/BCD_GEN[2].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__1/O2default:default2default:default2�
 "r
-BCD_GEN[2].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__1	-BCD_GEN[2].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2l
 "V
BCD_GEN[2].BCD_UNIT/bcd_ud_edgeBCD_GEN[2].BCD_UNIT/bcd_ud_edge2default:default2default:default2�
 "n
+BCD_GEN[2].BCD_UNIT/bcd_ud_buf_reg_i_1__1/O+BCD_GEN[2].BCD_UNIT/bcd_ud_buf_reg_i_1__1/O2default:default2default:default2�
 "j
)BCD_GEN[2].BCD_UNIT/bcd_ud_buf_reg_i_1__1	)BCD_GEN[2].BCD_UNIT/bcd_ud_buf_reg_i_1__12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "z
1BCD_GEN[3].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__2_n_01BCD_GEN[3].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__2_n_02default:default2default:default2�
 "v
/BCD_GEN[3].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__2/O/BCD_GEN[3].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__2/O2default:default2default:default2�
 "r
-BCD_GEN[3].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__2	-BCD_GEN[3].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__22default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2l
 "V
BCD_GEN[3].BCD_UNIT/bcd_ud_edgeBCD_GEN[3].BCD_UNIT/bcd_ud_edge2default:default2default:default2�
 "n
+BCD_GEN[3].BCD_UNIT/bcd_ud_buf_reg_i_1__2/O+BCD_GEN[3].BCD_UNIT/bcd_ud_buf_reg_i_1__2/O2default:default2default:default2�
 "j
)BCD_GEN[3].BCD_UNIT/bcd_ud_buf_reg_i_1__2	)BCD_GEN[3].BCD_UNIT/bcd_ud_buf_reg_i_1__22default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "z
1BCD_GEN[4].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__3_n_01BCD_GEN[4].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__3_n_02default:default2default:default2�
 "v
/BCD_GEN[4].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__3/O/BCD_GEN[4].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__3/O2default:default2default:default2�
 "r
-BCD_GEN[4].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__3	-BCD_GEN[4].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2l
 "V
BCD_GEN[4].BCD_UNIT/bcd_ud_edgeBCD_GEN[4].BCD_UNIT/bcd_ud_edge2default:default2default:default2�
 "n
+BCD_GEN[4].BCD_UNIT/bcd_ud_buf_reg_i_1__3/O+BCD_GEN[4].BCD_UNIT/bcd_ud_buf_reg_i_1__3/O2default:default2default:default2�
 "j
)BCD_GEN[4].BCD_UNIT/bcd_ud_buf_reg_i_1__3	)BCD_GEN[4].BCD_UNIT/bcd_ud_buf_reg_i_1__32default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "z
1BCD_GEN[5].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__4_n_01BCD_GEN[5].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__4_n_02default:default2default:default2�
 "v
/BCD_GEN[5].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__4/O/BCD_GEN[5].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__4/O2default:default2default:default2�
 "r
-BCD_GEN[5].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__4	-BCD_GEN[5].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__42default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2l
 "V
BCD_GEN[5].BCD_UNIT/bcd_ud_edgeBCD_GEN[5].BCD_UNIT/bcd_ud_edge2default:default2default:default2�
 "n
+BCD_GEN[5].BCD_UNIT/bcd_ud_buf_reg_i_1__4/O+BCD_GEN[5].BCD_UNIT/bcd_ud_buf_reg_i_1__4/O2default:default2default:default2�
 "j
)BCD_GEN[5].BCD_UNIT/bcd_ud_buf_reg_i_1__4	)BCD_GEN[5].BCD_UNIT/bcd_ud_buf_reg_i_1__42default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "z
1BCD_GEN[6].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__5_n_01BCD_GEN[6].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__5_n_02default:default2default:default2�
 "v
/BCD_GEN[6].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__5/O/BCD_GEN[6].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__5/O2default:default2default:default2�
 "r
-BCD_GEN[6].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__5	-BCD_GEN[6].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__52default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2l
 "V
BCD_GEN[6].BCD_UNIT/bcd_ud_edgeBCD_GEN[6].BCD_UNIT/bcd_ud_edge2default:default2default:default2�
 "n
+BCD_GEN[6].BCD_UNIT/bcd_ud_buf_reg_i_1__5/O+BCD_GEN[6].BCD_UNIT/bcd_ud_buf_reg_i_1__5/O2default:default2default:default2�
 "j
)BCD_GEN[6].BCD_UNIT/bcd_ud_buf_reg_i_1__5	)BCD_GEN[6].BCD_UNIT/bcd_ud_buf_reg_i_1__52default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2�
 "z
1BCD_GEN[7].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__6_n_01BCD_GEN[7].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__6_n_02default:default2default:default2�
 "v
/BCD_GEN[7].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__6/O/BCD_GEN[7].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__6/O2default:default2default:default2�
 "r
-BCD_GEN[7].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__6	-BCD_GEN[7].BCD_UNIT/bcd_tmp_reg[3]_LDC_i_1__62default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
�
�Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2l
 "V
BCD_GEN[7].BCD_UNIT/bcd_ud_edgeBCD_GEN[7].BCD_UNIT/bcd_ud_edge2default:default2default:default2�
 "n
+BCD_GEN[7].BCD_UNIT/bcd_ud_buf_reg_i_1__6/O+BCD_GEN[7].BCD_UNIT/bcd_ud_buf_reg_i_1__6/O2default:default2default:default2�
 "j
)BCD_GEN[7].BCD_UNIT/bcd_ud_buf_reg_i_1__6	)BCD_GEN[7].BCD_UNIT/bcd_ud_buf_reg_i_1__62default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px� 
g
DRC finished with %s
1905*	planAhead2)
0 Errors, 17 Warnings2default:defaultZ12-3199h px� 
i
BPlease refer to the DRC report (report_drc) for more information.
1906*	planAheadZ12-3200h px� 
i
)Running write_bitstream with %s threads.
1750*designutils2
22default:defaultZ20-2272h px� 
?
Loading data files...
1271*designutilsZ12-1165h px� 
>
Loading site data...
1273*designutilsZ12-1167h px� 
?
Loading route data...
1272*designutilsZ12-1166h px� 
?
Processing options...
1362*designutilsZ12-1514h px� 
<
Creating bitmap...
1249*designutilsZ12-1141h px� 
7
Creating bitstream...
7*	bitstreamZ40-7h px� 
Z
Writing bitstream %s...
11*	bitstream2
	./top.bit2default:defaultZ40-11h px� 
F
Bitgen Completed Successfully.
1606*	planAheadZ12-1842h px� 
�
�WebTalk data collection is mandatory when using a WebPACK part without a full Vivado license. To see the specific WebTalk data collected for your design, open the usage_statistics_webtalk.html or usage_statistics_webtalk.xml file in the implementation directory.
120*projectZ1-120h px� 
�
�'%s' has been successfully sent to Xilinx on %s. For additional details about this file, please refer to the Webtalk help file at %s.
186*common2�
�D:/Documents/workspace/CPP_Schoolworks/ECE4304L/ECE4304L_Lab4/ECE4304L_Lab4_VHDL/ECE4304L_Lab4_VHDL.runs/impl_1/usage_statistics_webtalk.xml2default:default2,
Wed Mar  3 11:25:16 20212default:default2I
5C:/Xilinx/Vivado/2019.1/doc/webtalk_introduction.html2default:defaultZ17-186h px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
962default:default2
182default:default2
02default:default2
02default:defaultZ4-41h px� 
a
%s completed successfully
29*	vivadotcl2#
write_bitstream2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2%
write_bitstream: 2default:default2
00:00:132default:default2
00:00:142default:default2
2050.2072default:default2
438.2852default:defaultZ17-268h px� 


End Record