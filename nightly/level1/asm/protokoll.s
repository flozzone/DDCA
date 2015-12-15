		.set noreorder
		.set noat
		
		.text
		.align  2
		.globl  _start
		.ent    _start
	                
_start:
        addi $1, $0, 0
        nop
        nop
loop:
        addi $1, $1, 1
        nop
        nop
        sw $1, 16($0)
        j loop
        nop
        nop
        nop