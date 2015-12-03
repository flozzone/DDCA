onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memu_tb/clk
add wave -noupdate /memu_tb/s_op
add wave -noupdate /memu_tb/s_A
add wave -noupdate /memu_tb/s_W
add wave -noupdate /memu_tb/s_D
add wave -noupdate /memu_tb/s_M
add wave -noupdate /memu_tb/s_R
add wave -noupdate /memu_tb/s_XL
add wave -noupdate /memu_tb/s_XS
add wave -noupdate /memu_tb/CLK_PERIOD
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
WaveRestoreZoom {1991116 ps} {2013806 ps}
