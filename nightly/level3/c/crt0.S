	.set	noreorder

	.text
	.align	2
	.globl	_start
	.ent	_start
		
_start:
	nop
	la		$gp,_gp
	la		$sp,0x1000
	jal		main
	nop

$loop:
	j		$loop
	nop

	.end	_start
	.size	_start, .-_start

#include "exc_handler.S"
