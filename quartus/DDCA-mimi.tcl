# Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, the Altera Quartus II License Agreement,
# the Altera MegaCore Function License Agreement, or other 
# applicable license agreement, including, without limitation, 
# that your use is for the sole purpose of programming logic 
# devices manufactured by Altera and sold by Altera or its 
# authorized distributors.  Please refer to the applicable 
# agreement for further details.

# Quartus II: Generate Tcl File for Project
# File: DDCA-mimi.tcl
# Generated on: Wed Dec  2 06:35:52 2015

# Load Quartus II Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "DDCA-mimi"]} {
		puts "Project DDCA-mimi is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists DDCA-mimi]} {
		project_open -revision DDCA-mimi DDCA-mimi
	} else {
		project_new -revision DDCA-mimi DDCA-mimi
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone IV E"
	set_global_assignment -name DEVICE EP4CE115F29C7
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 15.0.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "06:34:50  DEZEMBER 02, 2015"
	set_global_assignment -name LAST_QUARTUS_VERSION 15.0.0
	set_global_assignment -name VHDL_FILE wb.vhd
	set_global_assignment -name VHDL_FILE serial_port_wrapper.vhd
	set_global_assignment -name VHDL_FILE regfile.vhd
	set_global_assignment -name VHDL_FILE pll_altera.vhd
	set_global_assignment -name VHDL_FILE pipeline.vhd
	set_global_assignment -name VHDL_FILE op_pack.vhd
	set_global_assignment -name VHDL_FILE ocram_altera.vhd
	set_global_assignment -name VHDL_FILE mimi.vhd
	set_global_assignment -name VHDL_FILE memu.vhd
	set_global_assignment -name VHDL_FILE mem.vhd
	set_global_assignment -name VHDL_FILE jmpu.vhd
	set_global_assignment -name VHDL_FILE imem_altera.vhd
	set_global_assignment -name VHDL_FILE fwd.vhd
	set_global_assignment -name VHDL_FILE fetch.vhd
	set_global_assignment -name VHDL_FILE exec.vhd
	set_global_assignment -name VHDL_FILE decode.vhd
	set_global_assignment -name VHDL_FILE ctrl.vhd
	set_global_assignment -name VHDL_FILE core_pack.vhd
	set_global_assignment -name VHDL_FILE core.vhd
	set_global_assignment -name VHDL_FILE alu.vhd
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE 1.2V
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (VHDL)"
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
