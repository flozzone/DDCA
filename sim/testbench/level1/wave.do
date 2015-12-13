onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Aquamarine /level1_tb/has_data
add wave -noupdate /level1_tb/clk
add wave -noupdate /level1_tb/clk_cnt
add wave -noupdate /level1_tb/s_reset
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -expand -group pipeline -childformat {{/level1_tb/s_mem_in.rddata -radix hexadecimal}} -expand -subitemconfig {/level1_tb/s_mem_in.rddata {-height 17 -radix hexadecimal}} /level1_tb/s_mem_in
add wave -noupdate -expand -group pipeline /level1_tb/s_intr
add wave -noupdate -expand -group pipeline -childformat {{/level1_tb/r_mem_out.address -radix binary} {/level1_tb/r_mem_out.wrdata -radix hexadecimal}} -expand -subitemconfig {/level1_tb/r_mem_out.address {-height 17 -radix binary} /level1_tb/r_mem_out.wrdata {-height 17 -radix hexadecimal}} /level1_tb/r_mem_out
add wave -noupdate -expand -group pipeline -childformat {{/level1_tb/a_mem_out.wrdata -radix hexadecimal}} -expand -subitemconfig {/level1_tb/a_mem_out.wrdata {-height 17 -radix hexadecimal}} /level1_tb/a_mem_out
add wave -noupdate -group fetch /level1_tb/pipeline_inst/fetch_inst/pcsrc
add wave -noupdate -group fetch /level1_tb/pipeline_inst/fetch_inst/pc_in
add wave -noupdate -group fetch /level1_tb/pipeline_inst/fetch_inst/pc_out
add wave -noupdate -group fetch /level1_tb/pipeline_inst/fetch_inst/instr
add wave -noupdate -group fetch /level1_tb/pipeline_inst/fetch_inst/imem_addr
add wave -noupdate -group fetch /level1_tb/pipeline_inst/fetch_inst/int_pc
add wave -noupdate -group fetch /level1_tb/pipeline_inst/fetch_inst/int_pc_next
add wave -noupdate -group decode -radix decimal /level1_tb/pipeline_inst/decode_inst/pc_in
add wave -noupdate -group decode -radix hexadecimal /level1_tb/pipeline_inst/decode_inst/instr
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/dbg_instr
add wave -noupdate -group decode -radix decimal /level1_tb/pipeline_inst/decode_inst/wraddr
add wave -noupdate -group decode -radix hexadecimal /level1_tb/pipeline_inst/decode_inst/wrdata
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/regwrite
add wave -noupdate -group decode -radix decimal /level1_tb/pipeline_inst/decode_inst/pc_out
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
add wave -noupdate -group decode /level1_tb/pipeline_inst/decode_inst/Ird
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
add wave -noupdate -group exec -radix decimal /level1_tb/pipeline_inst/exec_inst/pc_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/op
add wave -noupdate -group exec -radix decimal /level1_tb/pipeline_inst/exec_inst/pc_out
add wave -noupdate -group exec -radix decimal /level1_tb/pipeline_inst/exec_inst/rd
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/rs
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/rt
add wave -noupdate -group exec -radix hexadecimal /level1_tb/pipeline_inst/exec_inst/aluresult
add wave -noupdate -group exec -radix hexadecimal -childformat {{/level1_tb/pipeline_inst/exec_inst/wrdata(31) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(30) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(29) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(28) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(27) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(26) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(25) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(24) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(23) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(22) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(21) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(20) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(19) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(18) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(17) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(16) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(15) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(14) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(13) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(12) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(11) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(10) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(9) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(8) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(7) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(6) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(5) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(4) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(3) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(2) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(1) -radix hexadecimal} {/level1_tb/pipeline_inst/exec_inst/wrdata(0) -radix hexadecimal}} -subitemconfig {/level1_tb/pipeline_inst/exec_inst/wrdata(31) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(30) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(29) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(28) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(27) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(26) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(25) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(24) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(23) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(22) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(21) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(20) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(19) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(18) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(17) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(16) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(15) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(14) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(13) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(12) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(11) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(10) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(9) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(8) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(7) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(6) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(5) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(4) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(3) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(2) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(1) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/exec_inst/wrdata(0) {-height 17 -radix hexadecimal}} /level1_tb/pipeline_inst/exec_inst/wrdata
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/zero
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/neg
add wave -noupdate -group exec -radix decimal /level1_tb/pipeline_inst/exec_inst/new_pc
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/memop_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/memop_out
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/jmpop_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/jmpop_out
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/wbop_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/wbop_out
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/forwardA
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/forwardB
add wave -noupdate -group exec -radix hexadecimal /level1_tb/pipeline_inst/exec_inst/cop0_rddata
add wave -noupdate -group exec -radix hexadecimal /level1_tb/pipeline_inst/exec_inst/mem_aluresult
add wave -noupdate -group exec -radix hexadecimal /level1_tb/pipeline_inst/exec_inst/wb_result
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/exc_ovf
add wave -noupdate -group exec -radix hexadecimal /level1_tb/pipeline_inst/exec_inst/int_alu_A
add wave -noupdate -group exec -radix hexadecimal /level1_tb/pipeline_inst/exec_inst/int_alu_B
add wave -noupdate -group exec -radix hexadecimal /level1_tb/pipeline_inst/exec_inst/int_alu_R
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_alu_Z
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_alu_V
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_pc_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_op
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_memop_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_jmpop_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_wbop_in
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_wbop_out
add wave -noupdate -group exec /level1_tb/pipeline_inst/exec_inst/int_exc_ovf
add wave -noupdate -group memory /level1_tb/pipeline_inst/mem_inst/mem_op
add wave -noupdate -group memory /level1_tb/pipeline_inst/mem_inst/jmp_op
add wave -noupdate -group memory -radix decimal /level1_tb/pipeline_inst/mem_inst/pc_in
add wave -noupdate -group memory -radix decimal /level1_tb/pipeline_inst/mem_inst/rd_in
add wave -noupdate -group memory -radix hexadecimal /level1_tb/pipeline_inst/mem_inst/aluresult_in
add wave -noupdate -group memory -radix hexadecimal -childformat {{/level1_tb/pipeline_inst/mem_inst/wrdata(31) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(30) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(29) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(28) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(27) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(26) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(25) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(24) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(23) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(22) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(21) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(20) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(19) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(18) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(17) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(16) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(15) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(14) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(13) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(12) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(11) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(10) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(9) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(8) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(7) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(6) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(5) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(4) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(3) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(2) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(1) -radix hexadecimal} {/level1_tb/pipeline_inst/mem_inst/wrdata(0) -radix hexadecimal}} -subitemconfig {/level1_tb/pipeline_inst/mem_inst/wrdata(31) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(30) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(29) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(28) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(27) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(26) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(25) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(24) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(23) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(22) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(21) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(20) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(19) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(18) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(17) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(16) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(15) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(14) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(13) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(12) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(11) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(10) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(9) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(8) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(7) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(6) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(5) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(4) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(3) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(2) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(1) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/mem_inst/wrdata(0) {-height 17 -radix hexadecimal}} /level1_tb/pipeline_inst/mem_inst/wrdata
add wave -noupdate -group memory /level1_tb/pipeline_inst/mem_inst/zero
add wave -noupdate -group memory /level1_tb/pipeline_inst/mem_inst/neg
add wave -noupdate -group memory -radix decimal /level1_tb/pipeline_inst/mem_inst/new_pc_in
add wave -noupdate -group memory -radix decimal /level1_tb/pipeline_inst/mem_inst/pc_out
add wave -noupdate -group memory /level1_tb/pipeline_inst/mem_inst/pcsrc
add wave -noupdate -group memory -radix decimal /level1_tb/pipeline_inst/mem_inst/rd_out
add wave -noupdate -group memory -radix hexadecimal /level1_tb/pipeline_inst/mem_inst/aluresult_out
add wave -noupdate -group memory -radix hexadecimal /level1_tb/pipeline_inst/mem_inst/memresult
add wave -noupdate -group memory -radix decimal /level1_tb/pipeline_inst/mem_inst/new_pc_out
add wave -noupdate -group memory /level1_tb/pipeline_inst/mem_inst/wbop_in
add wave -noupdate -group memory /level1_tb/pipeline_inst/mem_inst/wbop_out
add wave -noupdate -group memory /level1_tb/pipeline_inst/mem_inst/mem_out
add wave -noupdate -group memory -radix hexadecimal /level1_tb/pipeline_inst/mem_inst/mem_data
add wave -noupdate -group memory /level1_tb/pipeline_inst/mem_inst/exc_load
add wave -noupdate -group memory /level1_tb/pipeline_inst/mem_inst/exc_store
add wave -noupdate -group {write back} /level1_tb/pipeline_inst/wb_inst/op
add wave -noupdate -group {write back} -radix decimal /level1_tb/pipeline_inst/wb_inst/rd_in
add wave -noupdate -group {write back} -radix hexadecimal /level1_tb/pipeline_inst/wb_inst/aluresult
add wave -noupdate -group {write back} -radix hexadecimal /level1_tb/pipeline_inst/wb_inst/memresult
add wave -noupdate -group {write back} -radix decimal -childformat {{/level1_tb/pipeline_inst/wb_inst/rd_out(4) -radix decimal} {/level1_tb/pipeline_inst/wb_inst/rd_out(3) -radix decimal} {/level1_tb/pipeline_inst/wb_inst/rd_out(2) -radix decimal} {/level1_tb/pipeline_inst/wb_inst/rd_out(1) -radix decimal} {/level1_tb/pipeline_inst/wb_inst/rd_out(0) -radix decimal}} -subitemconfig {/level1_tb/pipeline_inst/wb_inst/rd_out(4) {-height 17 -radix decimal} /level1_tb/pipeline_inst/wb_inst/rd_out(3) {-height 17 -radix decimal} /level1_tb/pipeline_inst/wb_inst/rd_out(2) {-height 17 -radix decimal} /level1_tb/pipeline_inst/wb_inst/rd_out(1) {-height 17 -radix decimal} /level1_tb/pipeline_inst/wb_inst/rd_out(0) {-height 17 -radix decimal}} /level1_tb/pipeline_inst/wb_inst/rd_out
add wave -noupdate -group {write back} -radix hexadecimal -childformat {{/level1_tb/pipeline_inst/wb_inst/result(31) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(30) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(29) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(28) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(27) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(26) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(25) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(24) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(23) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(22) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(21) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(20) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(19) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(18) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(17) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(16) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(15) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(14) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(13) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(12) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(11) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(10) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(9) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(8) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(7) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(6) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(5) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(4) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(3) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(2) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(1) -radix hexadecimal} {/level1_tb/pipeline_inst/wb_inst/result(0) -radix hexadecimal}} -subitemconfig {/level1_tb/pipeline_inst/wb_inst/result(31) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(30) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(29) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(28) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(27) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(26) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(25) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(24) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(23) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(22) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(21) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(20) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(19) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(18) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(17) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(16) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(15) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(14) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(13) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(12) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(11) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(10) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(9) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(8) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(7) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(6) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(5) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(4) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(3) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(2) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(1) {-height 17 -radix hexadecimal} /level1_tb/pipeline_inst/wb_inst/result(0) {-height 17 -radix hexadecimal}} /level1_tb/pipeline_inst/wb_inst/result
add wave -noupdate -group {write back} /level1_tb/pipeline_inst/wb_inst/regwrite
add wave -noupdate -group {write back} /level1_tb/pipeline_inst/mem_inst/memu_inst/op
add wave -noupdate -group {write back} /level1_tb/pipeline_inst/mem_inst/memu_inst/A
add wave -noupdate -group {write back} /level1_tb/pipeline_inst/mem_inst/memu_inst/W
add wave -noupdate -group {write back} /level1_tb/pipeline_inst/mem_inst/memu_inst/D
add wave -noupdate -group {write back} /level1_tb/pipeline_inst/mem_inst/memu_inst/M
add wave -noupdate -group {write back} /level1_tb/pipeline_inst/mem_inst/memu_inst/R
add wave -noupdate -group {write back} /level1_tb/pipeline_inst/mem_inst/memu_inst/XL
add wave -noupdate -group {write back} /level1_tb/pipeline_inst/mem_inst/memu_inst/XS
add wave -noupdate -group {external memory} /level1_tb/memory_inst/address
add wave -noupdate -group {external memory} /level1_tb/memory_inst/byteena
add wave -noupdate -group {external memory} /level1_tb/memory_inst/data
add wave -noupdate -group {external memory} /level1_tb/memory_inst/wren
add wave -noupdate -group {external memory} /level1_tb/memory_inst/q
add wave -noupdate -group {external memory} /level1_tb/memory_inst/sub_wire0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {227900 fs} 0} {{Cursor 2} {33982800 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
configure wave -valuecolwidth 187
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
WaveRestoreZoom {608600 fs} {653300 fs}
