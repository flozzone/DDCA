#include "exceptions.h"

int main() {
	
	/* do not retry */
	__exception_retry = 0;

	puts("<<<");

	/* null-pointer load exceptions */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"lw $0, 0($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"lh $0, 0($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"lhu $0, 0($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"lb $0, 0($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"lbu $0, 0($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* null-pointer store exceptions */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"sw $0, 0($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"sh $0, 0($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"sb $0, 0($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* unaligned load exceptions */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"lw $0, 1($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"lw $0, 2($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"lh $0, 1($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"lhu $0, 1($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* unaligned store exceptions */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"sw $0, 1($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"sw $0, 2($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"sh $0, 1($0)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* consecutive exceptions */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"or $0, $0, $1\n\t"
			"lw $1, 5($1)\n\t"
			"sw $1, 0($1)\n\t"
			"sw $1, 0($1)\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* exception in BDS, branch taken */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"beqz $0, __memexcA\n\t"
			"lw $0, 0($0)\n\t"
			"nop\n"
			"__memexcA:\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* overflow just outside BDS */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"beqz $0, __memexcB\n\t"
			"nop\n"
			"lw $0, 0($0)\n\t"
			"nop\n"
			"__memexcB:\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* overflow outside BDS */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"beqz $0, __memexcC\n\t"
			"nop\n"
			"nop\n"
			"lw $0, 0($0)\n\t"
			"nop\n"
			"__memexcC:\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* overflow in BDS, branch not taken */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"bnez $0, __memexcD\n\t"
			"lw $0, 0($0)\n\t"
			"nop\n"
			"__memexcD:\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	puts(">>>");

	return 0;
}
