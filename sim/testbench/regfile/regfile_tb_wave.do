onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /regfile_tb/clk
add wave -noupdate -label s_reset /regfile_tb/s_reset
add wave -noupdate -label s_stall /regfile_tb/s_stall
add wave -noupdate -label s_rdaddr1 /regfile_tb/s_rdaddr1
add wave -noupdate -label s_rdaddr2 /regfile_tb/s_rdaddr2
add wave -noupdate -label s_wraddr /regfile_tb/s_wraddr
add wave -noupdate -label s_wrdata /regfile_tb/s_wrdata
add wave -noupdate -label s_regwrite /regfile_tb/s_regwrite
add wave -noupdate -label r_rddata1 /regfile_tb/r_rddata1
add wave -noupdate -label r_rddata2 /regfile_tb/r_rddata2
add wave -noupdate -label a_rddata1 /regfile_tb/a_rddata1
add wave -noupdate -label a_rddata2 /regfile_tb/a_rddata2
add wave -noupdate -label testfile /regfile_tb/testfile
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0} {{Cursor 2} {53 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {3192 ps}
