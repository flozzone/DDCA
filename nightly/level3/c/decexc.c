#include "exceptions.h"

int main() {
	
	/* do not retry */
	__exception_retry = 0;

	puts("<<<");

	/* MUL/DIV instructions */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"mult $0, $0\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"multu $0, $0\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"div $0, $0\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"divu $0, $0\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	/* HI/LO instructions */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"divu $0, $0\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"mflo $0\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"mfhi $0\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"mtlo $0\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"mthi $0\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	/* LOAD/STORE instructions */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"lwl $0,0($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"lwr $0,0($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"swl $0,0($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"swr $0,0($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	/* Floating-point instructions */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"add.s $f0,$f0\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"add.d $f0,$f0\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* consecutive exceptions */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"mult $0, $0\n\t"
			"mult $0, $0\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* exception in BDS, branch taken */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"beqz $0, __excdecA\n\t"
			"mult $0, $0\n"
			"nop\n"
			"__excdecA:\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* exception just outside BDS */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"beqz $0, __excdecB\n\t"
			"nop\n\t"
			"mult $0, $0\n"
			"nop\n"
			"__excdecB:\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* exception outside BDS */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"beqz $0, __excdecC\n\t"
			"nop\n\t"
			"nop\n\t"
			"mult $0, $0\n"
			"nop\n"
			"__excdecC:\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* exception in BDS, branch not taken */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"bnez $0, __excdecD\n\t"
			"mult $0, $0\n"
			"nop\n"
			"__excdecD:\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	puts(">>>");

	return 0;
}
