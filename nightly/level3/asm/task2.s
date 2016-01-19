		.set noreorder
		.set noat
		
		.text
		.align  2
		.globl  _start
		.ent    _start
	                
_start:
loop:   j loop
        addi $1, $1, 1
        addi $2, $2, 1
        nop
		
		.end _start
		.size _start, .-_start
