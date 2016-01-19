		.set noreorder
		.set noat
		
		.text
		.align  2
		.globl  _start
		.ent    _start
	                
_start:
		addi $1 , $0 , 7
		addi $2 , $0 , 5
		and $1 , $2 , $1
		nop
		nop
		
		.end _start
		.size _start, .-_start
