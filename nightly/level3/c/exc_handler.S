/* To be included by crt0.S */

		.set noat
		.set noreorder

		.text
		.org 0x80
		.globl __exception_entry
		.ent __exception_entry
__exception_entry:
		# save register values
		addiu	$sp, -512
		sw		$1, 4($sp)
		sw		$2, 8($sp)
		sw		$3, 12($sp)
		sw		$4, 16($sp)
		sw		$5, 20($sp)
		sw		$6, 24($sp)
		sw		$7, 28($sp)
		sw		$8, 32($sp)
		sw		$9, 36($sp)
		sw		$10, 40($sp)
		sw		$11, 44($sp)
		sw		$12, 48($sp)
		sw		$13, 52($sp)
		sw		$14, 56($sp)
		sw		$15, 60($sp)
		sw		$16, 64($sp)
		sw		$17, 68($sp)
		sw		$18, 72($sp)
		sw		$19, 76($sp)
		sw		$20, 80($sp)
		sw		$21, 84($sp)
		sw		$22, 88($sp)
		sw		$23, 92($sp)
		sw		$24, 96($sp)
		sw		$25, 100($sp)
		sw		$26, 104($sp)
		sw		$27, 108($sp)
		sw		$28, 112($sp)
		sw		$29, 116($sp)
		sw		$30, 120($sp)
		sw		$31, 124($sp)

		# remember npc in kernel register 0
		mfc0	$k0, $15
		# remember epc in kernel register 1
		mfc0	$k1, $14
		# take into account the branch delay slot
		mfc0	$at, $13
		slt		$at, $at, 0
		sll		$at, $at, 2
		sub		$k1, $k1, $at

		# cause register provides offset to exception table
		mfc0	$at, $13
		andi	$at, $at, 0x3c
		addiu	$at, __exception_table
		lw		$at, 0($at)

		# arguments for exception handler
		mfc0	$a0, $15
		mfc0	$a1, $14
		mfc0	$a2, $13
		move	$a3, $sp
		
		jal		$at
		nop

		# check where to return to
		beqz	$v0, $L0
		nop
		move	$k0, $k1
		
$L0:	
		# restore register values
		lw		$31, 124($sp)
		lw		$30, 120($sp)
		# lw		$29, 116($sp) # $sp
		lw		$28, 112($sp)
		# lw		$27, 108($sp) # $k0
		# lw		$26, 104($sp) # $k1
		lw		$25, 100($sp)
		lw		$24, 96($sp)
		lw		$23, 92($sp)
		lw		$22, 88($sp)
		lw		$21, 84($sp)
		lw		$20, 80($sp)
		lw		$19, 76($sp)
		lw		$18, 72($sp)
		lw		$17, 68($sp)
		lw		$16, 64($sp)
		lw		$15, 60($sp)
		lw		$14, 56($sp)
		lw		$13, 52($sp)
		lw		$12, 48($sp)
		lw		$11, 44($sp)
		lw		$10, 40($sp)
		lw		$9, 36($sp)
		lw		$8, 32($sp)
		lw		$7, 28($sp)
		lw		$6, 24($sp)
		lw		$5, 20($sp)
		lw		$4, 16($sp)
		lw		$3, 12($sp)
		lw		$2, 8($sp)
		lw		$1, 4($sp)
		addiu	$sp, 512

		# enable exceptions and return
		mfc0	$k1, $12
		ori		$k1, $k1, 1
		jr		$k0
		mtc0	$k1, $12
		.end __exception_entry
		.size __exception_entry, .-__exception_entry

		.data
		.globl __exception_table
		.size  __exception_table, 64
__exception_table:
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
		.word __exception_default
