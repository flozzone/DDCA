onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memu_tb/clk
add wave -noupdate -expand -group Stimuli -expand /memu_tb/s_op
add wave -noupdate -expand -group Stimuli /memu_tb/s_A
add wave -noupdate -expand -group Stimuli /memu_tb/s_W
add wave -noupdate -expand -group Stimuli -radix hexadecimal -childformat {{/memu_tb/s_D(31) -radix hexadecimal} {/memu_tb/s_D(30) -radix hexadecimal} {/memu_tb/s_D(29) -radix hexadecimal} {/memu_tb/s_D(28) -radix hexadecimal} {/memu_tb/s_D(27) -radix hexadecimal} {/memu_tb/s_D(26) -radix hexadecimal} {/memu_tb/s_D(25) -radix hexadecimal} {/memu_tb/s_D(24) -radix hexadecimal} {/memu_tb/s_D(23) -radix hexadecimal} {/memu_tb/s_D(22) -radix hexadecimal} {/memu_tb/s_D(21) -radix hexadecimal} {/memu_tb/s_D(20) -radix hexadecimal} {/memu_tb/s_D(19) -radix hexadecimal} {/memu_tb/s_D(18) -radix hexadecimal} {/memu_tb/s_D(17) -radix hexadecimal} {/memu_tb/s_D(16) -radix hexadecimal} {/memu_tb/s_D(15) -radix hexadecimal} {/memu_tb/s_D(14) -radix hexadecimal} {/memu_tb/s_D(13) -radix hexadecimal} {/memu_tb/s_D(12) -radix hexadecimal} {/memu_tb/s_D(11) -radix hexadecimal} {/memu_tb/s_D(10) -radix hexadecimal} {/memu_tb/s_D(9) -radix hexadecimal} {/memu_tb/s_D(8) -radix hexadecimal} {/memu_tb/s_D(7) -radix hexadecimal} {/memu_tb/s_D(6) -radix hexadecimal} {/memu_tb/s_D(5) -radix hexadecimal} {/memu_tb/s_D(4) -radix hexadecimal} {/memu_tb/s_D(3) -radix hexadecimal} {/memu_tb/s_D(2) -radix hexadecimal} {/memu_tb/s_D(1) -radix hexadecimal} {/memu_tb/s_D(0) -radix hexadecimal}} -subitemconfig {/memu_tb/s_D(31) {-height 17 -radix hexadecimal} /memu_tb/s_D(30) {-height 17 -radix hexadecimal} /memu_tb/s_D(29) {-height 17 -radix hexadecimal} /memu_tb/s_D(28) {-height 17 -radix hexadecimal} /memu_tb/s_D(27) {-height 17 -radix hexadecimal} /memu_tb/s_D(26) {-height 17 -radix hexadecimal} /memu_tb/s_D(25) {-height 17 -radix hexadecimal} /memu_tb/s_D(24) {-height 17 -radix hexadecimal} /memu_tb/s_D(23) {-height 17 -radix hexadecimal} /memu_tb/s_D(22) {-height 17 -radix hexadecimal} /memu_tb/s_D(21) {-height 17 -radix hexadecimal} /memu_tb/s_D(20) {-height 17 -radix hexadecimal} /memu_tb/s_D(19) {-height 17 -radix hexadecimal} /memu_tb/s_D(18) {-height 17 -radix hexadecimal} /memu_tb/s_D(17) {-height 17 -radix hexadecimal} /memu_tb/s_D(16) {-height 17 -radix hexadecimal} /memu_tb/s_D(15) {-height 17 -radix hexadecimal} /memu_tb/s_D(14) {-height 17 -radix hexadecimal} /memu_tb/s_D(13) {-height 17 -radix hexadecimal} /memu_tb/s_D(12) {-height 17 -radix hexadecimal} /memu_tb/s_D(11) {-height 17 -radix hexadecimal} /memu_tb/s_D(10) {-height 17 -radix hexadecimal} /memu_tb/s_D(9) {-height 17 -radix hexadecimal} /memu_tb/s_D(8) {-height 17 -radix hexadecimal} /memu_tb/s_D(7) {-height 17 -radix hexadecimal} /memu_tb/s_D(6) {-height 17 -radix hexadecimal} /memu_tb/s_D(5) {-height 17 -radix hexadecimal} /memu_tb/s_D(4) {-height 17 -radix hexadecimal} /memu_tb/s_D(3) {-height 17 -radix hexadecimal} /memu_tb/s_D(2) {-height 17 -radix hexadecimal} /memu_tb/s_D(1) {-height 17 -radix hexadecimal} /memu_tb/s_D(0) {-height 17 -radix hexadecimal}} /memu_tb/s_D
add wave -noupdate /memu_tb/CLK_PERIOD
add wave -noupdate -expand -group Result -childformat {{/memu_tb/r_M.wrdata -radix hexadecimal}} -expand -subitemconfig {/memu_tb/r_M.wrdata {-height 17 -radix hexadecimal}} /memu_tb/r_M
add wave -noupdate -expand -group Result /memu_tb/r_R
add wave -noupdate -expand -group Result /memu_tb/r_XL
add wave -noupdate -expand -group Result /memu_tb/r_XS
add wave -noupdate -expand -group Assertions -childformat {{/memu_tb/a_M.wrdata -radix hexadecimal}} -expand -subitemconfig {/memu_tb/a_M.wrdata {-height 17 -radix hexadecimal}} /memu_tb/a_M
add wave -noupdate -expand -group Assertions /memu_tb/a_R
add wave -noupdate -expand -group Assertions /memu_tb/a_XL
add wave -noupdate -expand -group Assertions /memu_tb/a_XS
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {430 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 290
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
WaveRestoreZoom {248 ns} {1272 ns}
bookmark add wave bookmark0 {{213 ps} {258200 fs}} 68
