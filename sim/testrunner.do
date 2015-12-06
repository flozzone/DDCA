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

set tb $1
set data_path "testbench/$tb/data/"
set wave_path "testbench/$tb/wave.do"

if { [file isdirectory $data_path] == 0 } {
	echo "Directory at $data_path does not exist."
	return
}

if { $argc > 1 } {
	set testfiles $data_path$2
	if { [file exists $testfiles] == 0 } {
		puts "$specific does not exist"
		return
	}
} else {
	set pattern "*"
	set glob_pattern $data_path$pattern
	set testfiles [lsort [glob $glob_pattern ] ]
}


-- http://stackoverflow.com/questions/9709257/modelsim-message-viewer-empty

set venv [env]
echo $venv
if { [string match *${tb}* $venv] } {
	echo "is already loaded, skip starting simulation, but restart."
	restart
} else {
	vsim -assertdebug -msgmode both -displaymsgmode both work.${tb}_tb
}

do $wave_path

foreach file $testfiles {
  echo "Running test $file"

	set filename [file rootname [lindex [file split $file] end]]

	force testfile $filename
  do $file
  
  run 4 ps
}
