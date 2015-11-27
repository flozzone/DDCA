		.set noreorder
		.set noat
		
		.text
		.align  2
		.globl  _start
		.ent    _start
	                
_start:
		nop
		addi $1, $0, -1
		addi $2, $0, 1
		ori $3, $0, 0x55
		ori $4, _func
		ori $5, jr_test

		# Test J
		j j_okay
		nop
		nop
		nop
		sw $3, 4($0)			# not executed if correct
j_okay:	
		sw $0, 4($0)
		
		# Test BNE
		bne $0, $0, bne_false_fail
		nop
		nop
		nop		
bne_false_okay:
		sw $0, 8($0)
		bne $0, $1, bne_true_okay
		nop
		nop
		nop
		sw $3, 12($0)			# not executed if correct		
bne_true_okay:
		sw $0, 12($0)		
		j bne_end
		nop
		nop
		nop				
bne_false_fail:
		sw $3, 8($0)
bne_end:

		# Test BEQ
		beq $0, $1, beq_false_fail
		nop
		nop
		nop		
beq_false_okay:
		sw $0, 16($0)
		beq $0, $0, beq_true_okay
		nop
		nop
		nop
		sw $3, 20($0)			# not executed if correct		
beq_true_okay:
		sw $0, 20($0)		
		j beq_end
		nop
		nop
		nop				
beq_false_fail:
		sw $3, 16($0)
beq_end:

		# Test BGTZ
		bgtz $0, bgtz_false1_fail
		nop
		nop
		nop		
bgtz_false1_okay:
		sw $0, 24($0)
		bgtz $1, bgtz_false2_fail
		nop
		nop
		nop		
bgtz_false2_okay:
		sw $0, 28($0)		
		bgtz $2, bgtz_true_okay
		nop
		nop
		nop
		sw $3, 32($0)			# not executed if correct		
bgtz_true_okay:
		sw $0, 32($0)		
		j bgtz_end
		nop
		nop
		nop				
bgtz_false1_fail:
		sw $3, 24($0)
bgtz_false2_fail:
		sw $3, 28($0)
bgtz_end:

		# Test BLEZ
		blez $2, blez_false_fail
		nop
		nop
		nop		
blez_false_okay:
		sw $0, 24($0)
		blez $0, blez_true1_okay
		nop
		nop
		nop		
		sw $3, 28($0)			# not executed if correct		
blez_true1_okay:
		sw $0, 28($0)		
		blez $1, blez_true2_okay
		nop
		nop
		nop
		sw $3, 32($0)			# not executed if correct		
blez_true2_okay:
		sw $0, 32($0)		
		j blez_end
		nop
		nop
		nop				
blez_false_fail:
		sw $3, 24($0)
blez_end:

		# Test BLTZ
		bltz $0, bltz_false1_fail
		nop
		nop
		nop		
bltz_false1_okay:
		sw $0, 24($0)
		bltz $2, bltz_false2_fail
		nop
		nop
		nop		
bltz_false2_okay:
		sw $0, 28($0)		
		bltz $1, bltz_true_okay
		nop
		nop
		nop
		sw $3, 32($0)			# not executed if correct		
bltz_true_okay:
		sw $0, 32($0)		
		j bltz_end
		nop
		nop
		nop				
bltz_false1_fail:
		sw $3, 24($0)
bltz_false2_fail:
		sw $3, 28($0)
bltz_end:

		# Test BGEZ
		bgez $1, bgez_false_fail
		nop
		nop
		nop		
bgez_false_okay:
		sw $0, 24($0)
		bgez $0, bgez_true1_okay
		nop
		nop
		nop		
		sw $3, 28($0)			# not executed if correct		
bgez_true1_okay:
		sw $0, 28($0)		
		bgez $2, bgez_true2_okay
		nop
		nop
		nop
		sw $3, 32($0)			# not executed if correct		
bgez_true2_okay:
		sw $0, 32($0)		
		j bgez_end
		nop
		nop
		nop				
bgez_false_fail:
		sw $3, 24($0)
bgez_end:

		# Test JR
		jr $5
		nop
		nop
		nop
		sw $3, 36($0)			# not executed if correct
jr_test:		
		sw $0, 36($0)		

		# Test JAL
		jal _func
		nop
		nop						# should return here, these two NOPs are executed twice
		nop
		sw $0, 44($0)

		# Test JALR
		jalr $4
		nop
		nop						# should return here, these two NOPs are executed twice
		nop
		sw $0, 48($0)

		# Test BLTZAL
		bltzal $0, _subfunc1	# should not branch
		nop
		nop
		nop
		sw $0, 52($0)
		bltzal $1, _subfunc1
		nop
		nop						# should return here, these two NOPs are executed twice
		nop
		sw $0, 56($0)
		bltzal $2, _subfunc1	# should not branch
		nop
		nop
		nop
		sw $0, 60($0)

		# Test BGEZAL
		bgezal $0, _subfunc1
		nop
		nop						# should return here, these two NOPs are executed twice
		nop
		sw $0, 52($0)
		bgezal $1, _subfunc1	# should not branch
		nop
		nop
		nop
		sw $0, 56($0)
		bgezal $2, _subfunc1
		nop
		nop						# should return here, these two NOPs are executed twice
		nop
		sw $0, 60($0)

		# Endless loop
loop:	sw $0, 64($0)
		j loop
		nop
		nop
		nop

_subfunc1:
		sw $0, 68($0)
		jr $31
		nop
		nop
		nop
		
		.end _start
		.size _start, .-_start

		.text
		.align  2
		.globl  _func
		.ent    _func        
_func:
		sw $0, 40($0)
		jr $31
		nop
		nop
		nop

		.end _func
		.size _func, .-_func
