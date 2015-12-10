do util.do

if { $argc == 0 } {
	echo "testbench parameter missing"
	echo "usage: do level1.do TEST_NAME"
	echo ""
	echo "Supported tests:"
	echo "  - minimal"
	return
}

load_testbench level1

set name $1

load_program "../nightly/level1/asm/${name}.mif"
load_test "testbench/level1/data/${name}.tc"

run