onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /level1_tb/clk
add wave -noupdate /level1_tb/int_clk_cnt
add wave -noupdate /level1_tb/s_reset
add wave -noupdate -expand -group pipeline -expand /level1_tb/s_mem_in
add wave -noupdate -expand -group pipeline /level1_tb/s_intr
add wave -noupdate -expand -group pipeline -expand /level1_tb/r_mem_out
add wave -noupdate -expand -group pipeline -expand /level1_tb/a_mem_out
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/stall
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/pcsrc
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/pc_in
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/pc_out
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/instr
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/current_pc
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/imem_addr
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/pc_in
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/instr
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/wraddr
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/wrdata
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/regwrite
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/pc_out
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/exec_op
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/cop0_op
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/jmp_op
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/mem_op
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/wb_op
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/exc_dec
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/taradr
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/adrim
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/func
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/shamt
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/rd
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/rt
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/rs
add wave -noupdate -expand -group decode /level1_tb/pipeline_inst/decode_inst/opcode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27000 fs} 0} {{Cursor 2} {3500 fs} 0}
quietly wave cursor active 2
configure wave -namecolwidth 206
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
WaveRestoreZoom {0 fs} {15400 fs}
