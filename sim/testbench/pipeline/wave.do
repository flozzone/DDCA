onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pipeline_tb/testfile
add wave -noupdate /pipeline_tb/clk
add wave -noupdate /pipeline_tb/int_clk_cnt
add wave -noupdate /pipeline_tb/reset
add wave -noupdate -expand -group pipeline /pipeline_tb/s_mem_in
add wave -noupdate -expand -group pipeline /pipeline_tb/s_intr
add wave -noupdate -expand -group pipeline /pipeline_tb/r_mem_out
add wave -noupdate -expand -group pipeline /pipeline_tb/a_mem_out
add wave -noupdate -expand -group fetch /pipeline_tb/pipeline_inst/fetch_inst/pcsrc
add wave -noupdate -expand -group fetch /pipeline_tb/pipeline_inst/fetch_inst/pc_in
add wave -noupdate -expand -group fetch /pipeline_tb/pipeline_inst/fetch_inst/pc_out
add wave -noupdate -expand -group fetch /pipeline_tb/pipeline_inst/fetch_inst/instr
add wave -noupdate -expand -group fetch /pipeline_tb/pipeline_inst/fetch_inst/current_pc
add wave -noupdate -expand -group fetch /pipeline_tb/pipeline_inst/fetch_inst/imem_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0} {{Cursor 2} {6000 fs} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {0 fs} {16 ps}
