		.set noreorder
		.set noat

		.text
		.align  2
		.globl  _start
		.ent    _start
	                
_start:
		nop

		# ALU forwarding, operand A
		addi $1, $0, 0x55
		addi $1, $0, 0xAA
		sub $2, $1, $0
		sub $3, $1, $0
		sub $4, $1, $0
		sub $5, $1, $0
		sw $2, 4($0)
		sw $3, 8($0)
		sw $4, 12($0)
		sw $5, 16($0)

		# ALU forwarding, operand B
		addi $6, $0, 0x33
		addi $6, $0, 0xCC
		sub $7, $0, $6
		sub $8, $0, $6
		sub $9, $0, $6
		sub $10, $0, $6
		sw $7, 4($0)
		sw $8, 8($0)
		sw $9, 12($0)
		sw $10, 16($0)

		# Forward loaded data
		lw $11, 4($0)
		nop				# Load delay slot
		sub $12, $11, $0
		sub $13, $11, $0
		sub $14, $11, $0
		sw $12, 4($0)
		sw $13, 8($0)
		sw $14, 12($0)

		lw $15, 4($0)
		nop				# Load delay slot
		sub $16, $0, $15
		sub $17, $0, $15
		sub $18, $0, $15
		sw $16, 4($0)
		sw $17, 8($0)
		sw $18, 12($0)

		# Forward load addresses
		addi $19, $0, 0x80
		lw $31, 4($19)
		lw $31, 8($19)
		lw $31, 12($19)

		# Forward store data
		addi $20, $0, 0x1234
		sw $20, 4($0)
		sw $20, 8($0)
		sw $20, 12($0)

		# Forward store addresses
		addi $21, $0, 0x80
		sw $0, 4($21)
		sw $0, 8($21)
		sw $0, 12($21)

		# No forwarding of register $0
		ori $0, $0, 0x99
		add $1, $0, $0
		add $2, $0, $0
		add $3, $0, $0
		sw $1, 4($0)
		sw $2, 8($0)
		sw $3, 12($0)		
		
		# Check if only registers are forwarded		
		addi $4, $0, -4
		addi $5, $0, 4
		addi $6, $0, 4
		addi $7, $0, 4
		sw $5, 4($0)
		sw $6, 8($0)
		sw $7, 12($0)		

		addi $4, $0, -4
		addiu $5, $0, 4
		addiu $6, $0, 4
		addiu $7, $0, 4
		sw $5, 4($0)
		sw $6, 8($0)
		sw $7, 12($0)		

		nor $31, $0, $0
		addi $4, $0, -4
		andi $5, $31, 4
		andi $6, $31, 4
		andi $7, $31, 4
		sw $5, 4($0)
		sw $6, 8($0)
		sw $7, 12($0)		

		addi $4, $0, -4
		ori $5, $0, 4
		ori $6, $0, 4
		ori $7, $0, 4
		sw $5, 4($0)
		sw $6, 8($0)
		sw $7, 12($0)		

		addi $4, $0, -4
		xori $5, $0, 4
		xori $6, $0, 4
		xori $7, $0, 4
		sw $5, 4($0)
		sw $6, 8($0)
		sw $7, 12($0)		

		addi $4, $0, -4
		lui $5, 4
		lui $6, 4
		lui $7, 4
		sw $5, 4($0)
		sw $6, 8($0)
		sw $7, 12($0)		

		addi $4, $0, -4
		slti $5, $0, 4
		slti $6, $0, 4
		slti $7, $0, 4
		sw $5, 4($0)
		sw $6, 8($0)
		sw $7, 12($0)		

		ori $30, $0, 0xffff
		addi $4, $0, -4
		sltiu $5, $30, 4
		sltiu $6, $30, 4
		sltiu $7, $30, 4
		sw $5, 4($0)
		sw $6, 8($0)
		sw $7, 12($0)		

		.end _start
		.size _start, .-_start
