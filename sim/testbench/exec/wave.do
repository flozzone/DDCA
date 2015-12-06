onerror {resume}
quietly WaveActivateNextPane {} 0
add wave  /exec_tb/s_clk
add wave  /exec_tb/s_reset
add wave  /exec_tb/s_stall
add wave  /exec_tb/s_flush
add wave  /exec_tb/s_pc_in
add wave  /exec_tb/s_op
add wave  /exec_tb/r_pc_out
add wave  /exec_tb/r_rd
add wave  /exec_tb/r_rs
add wave  /exec_tb/r_rt
add wave  /exec_tb/r_aluresult
add wave  /exec_tb/r_wrdata
add wave  /exec_tb/r_zero
add wave  /exec_tb/r_neg
add wave  /exec_tb/r_new_pc
add wave  /exec_tb/s_memop_in
add wave  /exec_tb/r_memop_out
add wave  /exec_tb/s_jmpop_in
add wave  /exec_tb/r_jmpop_out
add wave  /exec_tb/s_wbop_in
add wave  /exec_tb/r_wbop_out
add wave  /exec_tb/s_forwardA
add wave  /exec_tb/s_forwardB
add wave  /exec_tb/s_cop0_rddata
add wave  /exec_tb/s_mem_aluresult
add wave  /exec_tb/s_wb_result
add wave  /exec_tb/r_exc_ovf
add wave  /exec_tb/a_pc_out
add wave  /exec_tb/a_rd
add wave  /exec_tb/a_rs
add wave  /exec_tb/a_rt
add wave  /exec_tb/a_aluresult
add wave  /exec_tb/a_wrdata
add wave  /exec_tb/a_zero
add wave  /exec_tb/a_neg
add wave  /exec_tb/a_new_pc
add wave  /exec_tb/a_memop_out
add wave  /exec_tb/a_jmpop_out
add wave  /exec_tb/a_wbop_out
add wave  /exec_tb/a_exc_ovf
add wave  /exec_tb/testfile
add wave  /exec_tb/CLK_PERIOD
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {2339 ps}
