		.set noreorder
		.set noat

		.text
		.align  2
		.globl  _start
		.ent    _start
	                
_start:
		nop

		ori $1, $0, 1
		ori $2, $0, 0
		ori $3, $0, 0
		ori $4, $0, 0

		# Test branch delay slot if not executed
		bne $0, $0, bne_false	# branch not executed, change $2, $3, $4
		addiu $2, $2, 1
		addiu $3, $3, 1
		addiu $4, $4, 1
bne_false:
		sw $2, 4($0)
		sw $3, 8($0)
		sw $4, 12($0)

		# Test Branch delay slot if executed
		bne $0, $1, bne_true	# branch executed, changle only $2
		addiu $2, $2, 1
		addiu $3, $3, 1
		addiu $4, $4, 1
bne_true:
		sw $2, 4($0)
		sw $3, 8($0)
		sw $4, 12($0)

		# Test forwarding to branch in cycle -1
		addiu $1, $1, -1
		beq $0, $1, beq_fwd		# branch executed, change only $2
		addiu $2, $2, 1
		addiu $3, $3, 1
		addiu $4, $4, 1
beq_fwd:
		sw $2, 4($0)
		sw $3, 8($0)
		sw $4, 12($0)

		# Test forwarding to branch in cycle -2
		addiu $1, $1, 1
		nop
		bne $0, $1, bne_fwd		# branch executed, change only $2
		addiu $2, $2, 1
		addiu $3, $3, 1
		addiu $4, $4, 1
bne_fwd:
		sw $2, 4($0)
		sw $3, 8($0)
		sw $4, 12($0)

		.end _start
		.size _start, .-_start
