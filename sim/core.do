source util.do

load_testbench core

set tests_avail [list aluexc intrs memexc decexc hello]
if { $argc == 1 } {
    set tests_avail $1
}

# stop simulation if instruction at address 9 reached, which is the program ending loop
# see nightly/level3/c/ctrl0.c
when {sim:/core_tb/pipeline_inst/fetch_inst/imem/address == "000000001001"} {stop}

foreach test $tests_avail {

	load_program $test

	onbreak {
		set tb_home "testbench/core"
		set expect_file "${tb_home}/data/$test.expect"
	
		set status [catch {diff -ayZ uart_output.log $expect_file } output]
		
		if {$status == 0} {
			echo "SUCCESS $test"
		} elseif {$::errorCode eq "NONE"} {
			echo "SUCCESS $test"
		} else {
			echo "FAILED $test"
			echo "Compare output"
			echo " <<< uart_output.log            $expect_file >>>"
			echo $output
		}

		stop
	}
	run -all

	wave refresh

	# goto last cursor in wave view
	wave cursor see -window wave
}