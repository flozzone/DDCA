-- http://stackoverflow.com/questions/9709257/modelsim-message-viewer-empty
vsim -assertcover -assertdebug -msgmode both -displaymsgmode both work.memu_tb

do memu_tb_wave.do

foreach file [lsort [glob testbench/memu/data/*]] {
  puts "Running test $file"
  do $file
  force testfile $file
  run 2 ps
}
