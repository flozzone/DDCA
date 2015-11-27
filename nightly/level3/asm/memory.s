		.set noreorder
		.set noat
		
		.text
		.align  2
		.globl  _start
		.ent    _start
	                
_start:
		nop

		# Test loading constants to registers
		lui $1, 0x1234
		nop
		nop
		sw $1, 4($0)
		nop
		nop
		
		ori $1, 0x5678
		nop
		nop
		sw $1, 4($0)
		nop
		nop

		lui $2, 0xfedc
		nop
		nop
		sw $2, 8($0)
		nop
		nop
		
		ori $2, 0xba98
		nop
		nop
		sw $2, 8($0)
		nop
		nop

		# Test basic stores
		sw $1, 0($2)
		sw $1, 4($2)
		sw $2, 8($1)
		sw $2, 12($1)

		# Test sub-word stores
		sh $1, 0($2)
		sh $1, 2($2)
		sh $2, 8($1)
		sh $2, 10($1)

		sb $1, 0($2)
		sb $1, 1($2)
		sb $1, 2($2)
		sb $1, 3($2)
		sb $2, 8($1)
		sb $2, 9($1)
		sb $2, 10($1)
		sb $2, 11($1)

		# Test loads
		lw $3, 4($0)
		
		lh $4, 4($0)
		lh $5, 6($0)
		lhu $6, 8($0)
		lhu $7, 10($0)

		lb $8, 4($0)
		lb $9, 5($0)
		lb $10, 6($0)
		lb $11, 7($0)
		lbu $12, 8($0)
		lbu $13, 9($0)
		lbu $14, 10($0)
		lbu $15, 11($0)

		sw $3, 4($0)
		sw $4, 4($0)
		sw $5, 4($0)
		sw $6, 4($0)
		sw $7, 4($0)
		sw $8, 4($0)
		sw $9, 4($0)
		sw $10, 4($0)
		sw $11, 4($0)
		sw $12, 4($0)
		sw $13, 4($0)
		sw $14, 4($0)
		sw $15, 4($0)

		# Test loads, with stalling
		lw $16, 4($0)
		
		lh $17, 4($0)
		lh $18, 6($0)
		lhu $19, 8($0)
		lhu $20, 10($0)

		lb $21, 4($0)
		lb $22, 5($0)
		lb $23, 6($0)
		lb $24, 7($0)
		lbu $25, 8($0)
		lbu $26, 9($0)
		lbu $27, 10($0)
		lbu $28, 11($0)

		sw $16, 4($0)
		sw $17, 4($0)
		sw $18, 4($0)
		sw $19, 4($0)
		sw $20, 4($0)
		sw $21, 4($0)
		sw $22, 4($0)
		sw $23, 4($0)
		sw $24, 4($0)
		sw $25, 4($0)
		sw $26, 4($0)
		sw $27, 4($0)
		sw $28, 4($0)

		nop
		nop
		
		.end _start
		.size _start, .-_start
