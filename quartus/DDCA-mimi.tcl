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
# Generated on: Tue Dec  8 19:19:51 2015

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
	set_global_assignment -name TOP_LEVEL_ENTITY pipeline
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 15.0.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "06:34:50  DEZEMBER 02, 2015"
	set_global_assignment -name LAST_QUARTUS_VERSION 15.0.0
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE 1.2V
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (VHDL)"
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name VHDL_FILE ../src/testbench_util/src/testbench_util_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/testbenches/regfile_tb.vhd
	set_global_assignment -name VHDL_FILE ../src/testbenches/pipeline_tb.vhd
	set_global_assignment -name VHDL_FILE ../src/testbenches/memu_tb.vhd
	set_global_assignment -name VHDL_FILE ../src/testbenches/fetch_tb.vhd
	set_global_assignment -name VHDL_FILE ../src/testbenches/exec_tb.vhd
	set_global_assignment -name VHDL_FILE ../src/testbenches/alu_tb.vhd
	set_global_assignment -name VHDL_FILE ../src/synchronizer/src/sync_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/synchronizer/src/sync_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/synchronizer/src/sync.vhd
	set_global_assignment -name VHDL_FILE ../src/serial_port/src/serial_port_transmitter_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/serial_port/src/serial_port_transmitter_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/serial_port/src/serial_port_transmitter.vhd
	set_global_assignment -name VHDL_FILE ../src/serial_port/src/serial_port_testbench.vhd
	set_global_assignment -name VHDL_FILE ../src/serial_port/src/serial_port_receiver_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/serial_port/src/serial_port_receiver_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/serial_port/src/serial_port_receiver.vhd
	set_global_assignment -name VHDL_FILE ../src/serial_port/src/serial_port_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/serial_port/src/serial_port_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/serial_port/src/serial_port.vhd
	set_global_assignment -name VHDL_FILE ../src/ram/src/ram_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/ram/src/fifo_1c1r1w_mixed.vhd
	set_global_assignment -name VHDL_FILE ../src/ram/src/fifo_1c1r1w.vhd
	set_global_assignment -name VHDL_FILE ../src/ram/src/dp_ram_1c1r1w_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/ram/src/dp_ram_1c1r1w.vhd
	set_global_assignment -name VHDL_FILE ../src/math/src/math_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/wb.vhd
	set_global_assignment -name VHDL_FILE ../src/serial_port_wrapper.vhd
	set_global_assignment -name VHDL_FILE ../src/regfile.vhd
	set_global_assignment -name VHDL_FILE ../src/pll_altera.vhd
	set_global_assignment -name VHDL_FILE ../src/pipeline.vhd
	set_global_assignment -name VHDL_FILE ../src/op_pack.vhd
	set_global_assignment -name VHDL_FILE ../src/ocram_altera.vhd
	set_global_assignment -name VHDL_FILE ../src/mimi.vhd
	set_global_assignment -name VHDL_FILE ../src/memu.vhd
	set_global_assignment -name VHDL_FILE ../src/mem.vhd
	set_global_assignment -name VHDL_FILE ../src/jmpu.vhd
	set_global_assignment -name VHDL_FILE ../src/imem_altera.vhd
	set_global_assignment -name VHDL_FILE ../src/fwd.vhd
	set_global_assignment -name VHDL_FILE ../src/fetch.vhd
	set_global_assignment -name VHDL_FILE ../src/exec.vhd
	set_global_assignment -name VHDL_FILE ../src/decode.vhd
	set_global_assignment -name VHDL_FILE ../src/ctrl.vhd
	set_global_assignment -name VHDL_FILE ../src/core_pack.vhd
	set_global_assignment -name VHDL_FILE ../src/core.vhd
	set_global_assignment -name VHDL_FILE ../src/alu.vhd
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
