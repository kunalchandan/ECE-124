# Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, the Altera Quartus Prime License Agreement,
# the Altera MegaCore Function License Agreement, or other 
# applicable license agreement, including, without limitation, 
# that your use is for the sole purpose of programming logic 
# devices manufactured by Altera and sold by Altera or its 
# authorized distributors.  Please refer to the applicable 
# agreement for further details.

# Quartus Prime: Generate Tcl File for Project
# File: LogicalStep.tcl
# Generated on: Tue May 10 12:20:43 2016

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "LogicalStep_Lab2"]} {
		puts "Project LogicalStep_Lab2 is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists LogicalStep_Lab2]} {
		project_open -revision LogicalStep_Lab2_top LogicalStep_Lab2
	} else {
		project_new -revision LogicalStep_Lab2_top LogicalStep_Lab2
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "MAX 10"
	set_global_assignment -name DEVICE 10M08SAE144C8G
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 15.1.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "11:20:37  MARCH 14, 2016"
	set_global_assignment -name LAST_QUARTUS_VERSION 15.1.0
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name SOURCE_FILE LogicalStep_Lab2_top.vhd
	set_global_assignment -name SOURCE_FILE segment7_mux.vhd
	set_global_assignment -name SOURCE_FILE SevenSegment.vhd
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 1A
	set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 1B
	set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 2
	set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 3
	set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 4
	set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 5
	set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 6
	set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 7
	set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 8
	set_global_assignment -name ENABLE_OCT_DONE OFF
	set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF
	set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF
	set_global_assignment -name USE_CONFIGURATION_DEVICE OFF
	set_global_assignment -name CRC_ERROR_OPEN_DRAIN OFF
	set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
	set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
	set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
	set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name FLOW_ENABLE_POWER_ANALYZER ON
	set_global_assignment -name POWER_DEFAULT_INPUT_IO_TOGGLE_RATE "12.5 %"
	set_global_assignment -name TCL_SCRIPT_FILE LogicalStep_Lab2.tcl
	set_global_assignment -name CDF_FILE output_files/Chain1.cdf
	set_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS OFF
	set_global_assignment -name CDF_FILE output_files/Chain2.cdf
	set_global_assignment -name EXTERNAL_FLASH_FALLBACK_ADDRESS 00000000
	set_global_assignment -name INTERNAL_FLASH_UPDATE_MODE "SINGLE COMP IMAGE"
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to aud_adc_dat
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to aud_adc_lrck
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to aud_bclk
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to aud_dac_dat
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to aud_dac_lrck
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to aud_scl
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to aud_sda
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to clkin_50
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to lcd_d[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to lcd_d[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to lcd_d[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to lcd_d[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to lcd_d[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to lcd_d[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to lcd_d[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to lcd_d[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to lcd_en
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to lcd_rs
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to lcd_rw
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to leds[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to rst_n
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sd_clk
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sd_cmd
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sd_dat0
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sd_dat3
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[12]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[11]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[10]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[9]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[8]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_a[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_ba[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_ba[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_cas_n
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_cke
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_clk
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_cs_n
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[15]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[14]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[13]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[12]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[11]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[10]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[9]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[8]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dq[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dqm[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_dqm[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_ras_n
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sdram_we_n
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to seg7_char1
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to seg7_char2
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to seg7_data[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to seg7_data[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to seg7_data[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to seg7_data[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to seg7_data[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to seg7_data[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to seg7_data[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to seg7_data[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sw[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sw[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sw[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sw[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sw[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sw[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sw[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to sw[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_rx
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to uart_tx
	set_location_assignment PIN_26 -to aud_bclk
	set_location_assignment PIN_27 -to leds[0]
	set_location_assignment PIN_28 -to leds[1]
	set_location_assignment PIN_33 -to aud_mclk
	set_location_assignment PIN_29 -to clkin_50
	set_location_assignment PIN_32 -to rst_n
	set_location_assignment PIN_30 -to sw[0]
	set_location_assignment PIN_122 -to seg7_char1
	set_location_assignment PIN_120 -to seg7_char2
	set_location_assignment PIN_126 -to seg7_data[7]
	set_location_assignment PIN_136 -to seg7_data[6]
	set_location_assignment PIN_134 -to seg7_data[5]
	set_location_assignment PIN_121 -to seg7_data[4]
	set_location_assignment PIN_105 -to seg7_data[3]
	set_location_assignment PIN_140 -to seg7_data[2]
	set_location_assignment PIN_138 -to seg7_data[1]
	set_location_assignment PIN_123 -to seg7_data[0]
	set_location_assignment PIN_131 -to sd_clk
	set_location_assignment PIN_132 -to sd_cmd
	set_location_assignment PIN_130 -to sd_dat0
	set_location_assignment PIN_135 -to sd_dat3
	set_location_assignment PIN_7 -to leds[5]
	set_location_assignment PIN_10 -to leds[4]
	set_location_assignment PIN_12 -to leds[3]
	set_location_assignment PIN_41 -to leds[7]
	set_location_assignment PIN_38 -to leds[6]
	set_location_assignment PIN_54 -to lcd_d[7]
	set_location_assignment PIN_55 -to lcd_d[6]
	set_location_assignment PIN_56 -to lcd_d[5]
	set_location_assignment PIN_57 -to lcd_d[4]
	set_location_assignment PIN_58 -to lcd_d[3]
	set_location_assignment PIN_59 -to lcd_d[2]
	set_location_assignment PIN_60 -to lcd_d[1]
	set_location_assignment PIN_47 -to lcd_d[0]
	set_location_assignment PIN_50 -to lcd_en
	set_location_assignment PIN_48 -to lcd_rs
	set_location_assignment PIN_52 -to lcd_rw
	set_location_assignment PIN_43 -to pb[3]
	set_location_assignment PIN_44 -to pb[2]
	set_location_assignment PIN_45 -to pb[1]
	set_location_assignment PIN_46 -to pb[0]
	set_location_assignment PIN_22 -to aud_adc_dat
	set_location_assignment PIN_21 -to aud_adc_lrck
	set_location_assignment PIN_25 -to aud_dac_dat
	set_location_assignment PIN_24 -to aud_dac_lrck
	set_location_assignment PIN_39 -to sw[6]
	set_location_assignment PIN_6 -to sw[5]
	set_location_assignment PIN_8 -to sw[4]
	set_location_assignment PIN_11 -to sw[3]
	set_location_assignment PIN_14 -to sw[2]
	set_location_assignment PIN_13 -to sw[1]
	set_location_assignment PIN_84 -to sdram_a[12]
	set_location_assignment PIN_80 -to sdram_a[11]
	set_location_assignment PIN_75 -to sdram_a[10]
	set_location_assignment PIN_78 -to sdram_a[9]
	set_location_assignment PIN_76 -to sdram_a[8]
	set_location_assignment PIN_70 -to sdram_a[7]
	set_location_assignment PIN_69 -to sdram_a[6]
	set_location_assignment PIN_66 -to sdram_a[5]
	set_location_assignment PIN_65 -to sdram_a[4]
	set_location_assignment PIN_64 -to sdram_a[3]
	set_location_assignment PIN_62 -to sdram_a[2]
	set_location_assignment PIN_61 -to sdram_a[1]
	set_location_assignment PIN_74 -to sdram_a[0]
	set_location_assignment PIN_77 -to sdram_ba[1]
	set_location_assignment PIN_79 -to sdram_ba[0]
	set_location_assignment PIN_86 -to sdram_cas_n
	set_location_assignment PIN_87 -to sdram_cke
	set_location_assignment PIN_89 -to sdram_clk
	set_location_assignment PIN_81 -to sdram_cs_n
	set_location_assignment PIN_119 -to sdram_dq[15]
	set_location_assignment PIN_118 -to sdram_dq[14]
	set_location_assignment PIN_114 -to sdram_dq[13]
	set_location_assignment PIN_113 -to sdram_dq[12]
	set_location_assignment PIN_112 -to sdram_dq[11]
	set_location_assignment PIN_100 -to sdram_dq[10]
	set_location_assignment PIN_99 -to sdram_dq[9]
	set_location_assignment PIN_97 -to sdram_dq[8]
	set_location_assignment PIN_92 -to sdram_dq[7]
	set_location_assignment PIN_96 -to sdram_dq[6]
	set_location_assignment PIN_98 -to sdram_dq[5]
	set_location_assignment PIN_101 -to sdram_dq[4]
	set_location_assignment PIN_102 -to sdram_dq[3]
	set_location_assignment PIN_106 -to sdram_dq[2]
	set_location_assignment PIN_111 -to sdram_dq[1]
	set_location_assignment PIN_110 -to sdram_dq[0]
	set_location_assignment PIN_90 -to sdram_dqm[0]
	set_location_assignment PIN_91 -to sdram_dqm[1]
	set_location_assignment PIN_85 -to sdram_ras_n
	set_location_assignment PIN_88 -to sdram_we_n
	set_location_assignment PIN_17 -to leds[2]
	set_location_assignment PIN_141 -to sw[7]
	set_location_assignment PIN_127 -to uart_rx
	set_location_assignment PIN_124 -to uart_tx
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to pb[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to pb[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to pb[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to pb[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to aud_mclk
	set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to seg7_data[7]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to seg7_data[4]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to seg7_data[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to seg7_data[2]
	set_location_assignment PIN_93 -to aud_sda
	set_location_assignment PIN_15 -to aud_scl
	set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to seg7_data[1]
	set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to seg7_data[5]
	set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to seg7_data[6]
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
