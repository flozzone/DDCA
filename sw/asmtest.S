        .set    noreorder
		.set	noat

        .text
        .align  2
        .globl  _start
        .ent    _start
                
_start:
		nop
		ori $2, $0, 0x1234
		ori $3, $0, 0x5678
		add $4, $2, $3

$loop:
        j               $loop
        nop

		.end	_start
		.size	_start, .-_start
