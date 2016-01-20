## Generated SDC file "DDCA-mimi.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 15.0.0 Build 145 04/22/2015 SJ Web Edition"

## DATE    "Tue Jan 19 02:28:06 2016"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk_pin} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk_pin}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {pll|altpll_component|pll|clk[0]} -source [get_pins {pll|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 3 -divide_by 2 -master_clock {clk_pin} [get_pins {pll|altpll_component|pll|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {pll|altpll_component|pll|clk[0]}] -rise_to [get_clocks {pll|altpll_component|pll|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll|altpll_component|pll|clk[0]}] -fall_to [get_clocks {pll|altpll_component|pll|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll|altpll_component|pll|clk[0]}] -rise_to [get_clocks {pll|altpll_component|pll|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll|altpll_component|pll|clk[0]}] -fall_to [get_clocks {pll|altpll_component|pll|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {pll|altpll_component|pll|clk[0]}]  1.000 [get_ports {clk_pin}]
set_input_delay -add_delay  -clock [get_clocks {pll|altpll_component|pll|clk[0]}]  2.000 [get_ports {intr_pin[0]}]
set_input_delay -add_delay  -clock [get_clocks {pll|altpll_component|pll|clk[0]}]  2.000 [get_ports {intr_pin[1]}]
set_input_delay -add_delay  -clock [get_clocks {pll|altpll_component|pll|clk[0]}]  2.000 [get_ports {intr_pin[2]}]
set_input_delay -add_delay  -clock [get_clocks {pll|altpll_component|pll|clk[0]}]  0.020 [get_ports {reset_pin}]
set_input_delay -add_delay  -clock [get_clocks {pll|altpll_component|pll|clk[0]}]  2.000 [get_ports {rx}]


#**************************************************************
# Set Output Delay
#**************************************************************

#set_output_delay -add_delay  -clock [get_clocks {pll|altpll_component|pll|clk[0]}]  0.200 [get_ports {tx}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_keepers {core:core|serial_port_wrapper:uart|serial_port:sp|serial_port_transmitter:serial_port_transmitter_fsm|tx}] -to [get_keepers {tx}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

