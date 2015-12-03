set path "testbench/memu/data/"



if { $argc > 0 } {
	set testfiles $path$1
	if { [file exists $specific] == 0 } {
		puts "$specific does not exist"
		return
	}
} else {
	set pattern "*"
	set glob_pattern $path$pattern
	set testfiles [lsort [glob $glob_pattern ] ]
}


-- http://stackoverflow.com/questions/9709257/modelsim-message-viewer-empty
--vsim -assertdebug -msgmode both -displaymsgmode both work.memu_tb

--do memu_tb_wave.do

foreach file $testfiles {
  puts "Running test $file"
  do $file
  force testfile $file
  run 2 ps
}
