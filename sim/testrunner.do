#
# Test runner for testbenches
#


# USAGE: do testrunner.do TESTBENCH [SPECIFIC_DATA_FILE]
# EXAMPLE: do testrunner.do regfile
# EXAMPLE: do testrunner.do regfile test_001.do

if { $argc == 0 } {
	echo "testbench parameter missing"
	echo "usage: do testrunner.do TESTBENCH \[SPECIFIC_DATA_FILE\]"
	return
}

set path "testbench/$1/data/"

if { [file isdirectory $path] == 0 } {
	echo "could not find testbench at $path"
	return
}

if { $argc > 1 } {
	set testfiles $path$2
	if { [file exists $testfiles] == 0 } {
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

	set filename [file rootname [lindex [file split $file] end]]
	force testfile $filename
  do $file
  
  run 2 ps
}
