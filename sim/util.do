proc num_to_vect {num len} {
	return [format "%llb" $num]
}

proc dec2bin {i {width {}}} {
    #returns the binary representation of $i
    # width determines the length of the returned string (left truncated or added left 0)
    # use of width allows concatenation of bits sub-fields

    set res {}
    if {$i<0} {
        set sign -
        set i [expr {abs($i)}]
    } else {
        set sign {}
    }
    while {$i>0} {
        set res [expr {$i%2}]$res
        set i [expr {$i/2}]
    }
    if {$res == {}} {set res 0}

    if {$width != {}} {
        append d [string repeat 0 $width] $res
        set res [string range $d [string length $res] end]
    }
    return $sign$res
}

# http://stackoverflow.com/questions/9709257/modelsim-message-viewer-empty
proc load_testbench {name} {
	set venv [env]
	echo $venv
	if { [string match *${name}* $venv] } {
		echo "is already loaded, skip starting simulation, but restart."
		restart
	} else {
		vsim -t 100fs -assertdebug -msgmode both -displaymsgmode both work.${name}_tb

		set wave_path "testbench/${name}/wave.do"
		if { [file exists $wave_path] == 1} {
			do $wave_path
		} else {
			echo "Wave file not found."
		}
	}
}

proc load_program {path} {
	set prog_path "../src/imem.mif"

	if {[file exists $path] == 0} {
		error "program at $path does not exist"
	}

	if {[file exists ${prog_path}.orig] == 0} {
		file copy $prog_path ${prog_path}.orig
	}

	file copy -force $path $prog_path
}

proc load_test {path} {
	set test_path "../src/test.tc"

	if {[file exists $path] == 0} {
		error "test at $path does not exist"
	}

	file copy -force $path $test_path
}