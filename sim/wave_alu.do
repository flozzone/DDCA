onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alu_tb/clk
add wave -noupdate /alu_tb/i_op
add wave -noupdate /alu_tb/i_A
add wave -noupdate /alu_tb/i_B
add wave -noupdate /alu_tb/o_R
add wave -noupdate /alu_tb/o_Z
add wave -noupdate /alu_tb/o_V
add wave -noupdate /alu_tb/alu_inst/op
add wave -noupdate /alu_tb/alu_inst/A
add wave -noupdate /alu_tb/alu_inst/B
add wave -noupdate /alu_tb/alu_inst/R
add wave -noupdate /alu_tb/alu_inst/Z
add wave -noupdate /alu_tb/alu_inst/V
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
