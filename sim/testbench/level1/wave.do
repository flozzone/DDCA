onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /level1_tb/clk
add wave -noupdate /level1_tb/int_clk_cnt
add wave -noupdate /level1_tb/s_reset
add wave -noupdate -expand -group pipeline -expand /level1_tb/s_mem_in
add wave -noupdate -expand -group pipeline /level1_tb/s_intr
add wave -noupdate -expand -group pipeline /level1_tb/r_mem_out
add wave -noupdate -expand -group pipeline /level1_tb/a_mem_out
add wave -noupdate -expand -group fetch -group imem /level1_tb/pipeline_inst/fetch_inst/imem/address
add wave -noupdate -expand -group fetch -group imem /level1_tb/pipeline_inst/fetch_inst/imem/clock
add wave -noupdate -expand -group fetch -group imem /level1_tb/pipeline_inst/fetch_inst/imem/q
add wave -noupdate -expand -group fetch -group imem /level1_tb/pipeline_inst/fetch_inst/imem/sub_wire0
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/stall
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/pcsrc
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/pc_in
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/pc_out
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/instr
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/int_pc
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/int_pc_next
add wave -noupdate -expand -group fetch /level1_tb/pipeline_inst/fetch_inst/imem_addr
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/pc_in
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/instr
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/dbg_instr
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/wraddr
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/wrdata
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/regwrite
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/pc_out
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/exec_op
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/cop0_op
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/jmp_op
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/mem_op
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/wb_op
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/exc_dec
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/taradr
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/adrim
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/func
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/shamt
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/rd
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/rt
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/rs
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/opcode
add wave -noupdate -group exec -group alu /level1_tb/pipeline_inst/exec_inst/alu_inst/op
add wave -noupdate -group exec -group alu /level1_tb/pipeline_inst/exec_inst/alu_inst/A
add wave -noupdate -group exec -group alu /level1_tb/pipeline_inst/exec_inst/alu_inst/B
add wave -noupdate -group exec -group alu /level1_tb/pipeline_inst/exec_inst/alu_inst/R
add wave -noupdate -group exec -group alu /level1_tb/pipeline_inst/exec_inst/alu_inst/Z
add wave -noupdate -group exec -group alu /level1_tb/pipeline_inst/exec_inst/alu_inst/V
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/clk
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/reset
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/stall
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/flush
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/pc_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/op
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/pc_out
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/rd
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/rs
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/rt
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/aluresult
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/wrdata
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/zero
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/neg
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/new_pc
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/memop_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/memop_out
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/jmpop_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/jmpop_out
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/wbop_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/wbop_out
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/forwardA
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/forwardB
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/cop0_rddata
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/mem_aluresult
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/wb_result
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/exc_ovf
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_alu_op
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_alu_A
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_alu_B
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_alu_R
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_alu_Z
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_alu_V
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_pc_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_op
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_memop_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_jmpop_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_jmpop_out
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_wbop_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_wbop_out
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_forwardA
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_forwardB
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_cop0_rddata
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_mem_aluresult
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_wb_result
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_exc_ovf
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11500 fs} 0} {{Cursor 2} {33982800 fs} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 fs} {21 ps}
