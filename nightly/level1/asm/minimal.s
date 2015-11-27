		.set noreorder
		.set noat

		.text
		.align  2
		.globl  _start
		.ent    _start
	                
_start:
		nop
		lw $0,4($0)
		nop
		nop
		sw $0,8($0)
		nop
		nop

		.end _start
		.size _start, .-_start
