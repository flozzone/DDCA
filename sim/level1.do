do util.do

set tests_avail [list minimal arith memory jump fwd ctrl]

if { $argc == 1 && $1 == "-help" } {
    echo "testbench parameter missing"
    echo "usage: do level1.do TEST_NAME"
    echo ""
    echo "Supported tests: ${tests_avail}"
    return
}

if { $argc == 1 } {
    set tests_avail $1
}

foreach test $tests_avail {
    load_test "testbench/level1/data/${test}.tc"
    load_program "testbench/level1/program" ${test}

    load_testbench level1

    run -all
}