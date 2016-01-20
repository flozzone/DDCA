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

do util.do

load_testbench ${tb}

foreach file $testfiles {
  echo "Running test $file"

    set filename [file rootname [lindex [file split $file] end]]
    force testfile $filename
    do $file
  
    run 20ns
}
