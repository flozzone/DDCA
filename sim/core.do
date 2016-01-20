source util.do
#source run_core_test.do

set use_testbench "core"
set tests_avail [list aluexc intrs memexc decexc hello]
if { $argc > 0 } {
    if { [string compare $1 "-serial" ] == 0 } {
        set use_testbench "core_serial"
        if { $argc > 1 } {
            set tests_avail $2
        }
    } else {
        set tests_avail $1
    }
}


echo "Using testbench ${use_testbench}"
load_testbench $use_testbench


# stop simulation if instruction at address 9 reached, which is the program ending loop
# see nightly/level3/c/ctrl0.c
if { [string compare ${use_testbench} core] == 0} {
    when -label PROGRAM_END {sim:/core_tb/pipeline_inst/fetch_inst/imem/address == "000000001001"} {
		force sim:/${use_testbench}_tb/int_finish 1;
		after 200 stop
	}
	when -label CLK_END {sim:/core_tb/int_stop_clk == 1} {
		echo "reached clock end"
		stop
	}
} else {
    when -label PROGRAM_END {sim:/core_serial_tb/pipeline_inst/fetch_inst/imem/address == "000000001001"} {
		force sim:/${use_testbench}_tb/int_finish 1;
		after 200 stop
	}
	when -label CLK_END {sim:/core_serial_tb/int_stop_clk == 1} {
		echo "reached clock end"
		stop
	}
}

proc finish_test { test } {
   	set tb_home "testbench/core"
    set expect_file "${tb_home}/data/$test.expect"

    set status [catch {exec diff -ayZ uart_output.log $expect_file } output]
    echo "test finished"
    
    if {$status == 0} {
        echo "SUCCESS $test"
    } elseif {$::errorCode eq "NONE"} {
		echo "ERROR: diff failed"
		echo $output
    } else {
        echo "FAILED $test"
        echo "Compare output"
        echo " <<< uart_output.log            $expect_file >>>"
        echo $output
    }
}

foreach test $tests_avail {

    echo "run test $test"

    if { [string compare $test "intrs" ] == 0 } {
        eval force -freeze sim:/${use_testbench}_tb/enable_intr_test 1
        #eval force -freeze sim:/${use_testbench}_tb/pipeline_inst/ctrl_inst/dbg_init_status "00000000000000000000000000000001" 
    } else {
        eval force -freeze sim:/${use_testbench}_tb/enable_intr_test 0
        #force -freeze sim:/core_tb/pipeline_inst/ctrl_inst/dbg_init_status "00000000000000000000000000000000"
    }

    load_program $test
	eval {noforce sim:/${use_testbench}_tb/int_stop_clk}
    eval {noforce sim:/${use_testbench}_tb/int_finish}

	onbreak { resume }

    run -all

	finish_test $test

    wave refresh

    # goto last cursor in wave view
    wave cursor see -window wave
}