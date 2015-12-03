onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memu_tb/clk
add wave -noupdate -expand -group Stimuli /memu_tb/s_op
add wave -noupdate -expand -group Stimuli /memu_tb/s_A
add wave -noupdate -expand -group Stimuli /memu_tb/s_W
add wave -noupdate -expand -group Stimuli /memu_tb/s_D
add wave -noupdate /memu_tb/CLK_PERIOD
add wave -noupdate -expand -group Result -expand /memu_tb/r_M
add wave -noupdate -expand -group Result /memu_tb/r_R
add wave -noupdate -expand -group Result /memu_tb/r_XL
add wave -noupdate -expand -group Result /memu_tb/r_XS
add wave -noupdate -expand -group Assertions -expand /memu_tb/a_M
add wave -noupdate -expand -group Assertions /memu_tb/a_R
add wave -noupdate -expand -group Assertions /memu_tb/a_XL
add wave -noupdate -expand -group Assertions /memu_tb/a_XS
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {64 ps}
