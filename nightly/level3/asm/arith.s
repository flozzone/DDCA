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

		# Test arithmetic
		add $3, $1, $2
		addu $4, $1, $2
		sub $5, $1, $2
		subu $6, $1, $2
		and $7, $1, $2
		or $8, $1, $2
		xor $9, $1, $2
		nor $10, $1, $2
		slt $11, $1, $2
		sltu $12, $1, $2
		sll $13, $2, 4
		srl $14, $2, 4
		sra $15, $2, 4
		sllv $16, $2, $1
		srlv $17, $2, $1
		srav $18, $2, $1
		addi $19, $1, 1
		addiu $20, $1, 1
		addi $21, $1, 0xffff
		addiu $22, $1, 0xffff
		slti $23, $1, 0xffff
		sltiu $24, $1, 0xffff
		slti $25, $2, 0xffff
		sltiu $26, $2, 0xffff
		andi $27, $1, 0xffff
		ori $28, $1, 0xffff
		xori $29, $1, 0xffff
		
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
		sw $29, 4($0)
		
		nop
		nop

		.end _start
		.size _start, .-_start
