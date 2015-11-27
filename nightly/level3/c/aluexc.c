#include "exceptions.h"

int main() {
	
	/* do not retry */
	__exception_retry = 0;

	puts("<<<");

	/* a >= 0, b >= 0, a+b < 0, immediate */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"li $1, 0x7fffffff\n\t"
			"addi $1, 1\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* a < 0, b < 0, a+b >= 0, immediate */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"li $1, 0x80000000\n\t"
			"addi $1, -1\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* a >= 0, b >= 0, a+b < 0 */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"li $1, 0x7fffffff\n\t"
			"li $2, 1\n\t"
			"add $1, $2\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* a < 0, b < 0, a+b >= 0 */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"li $1, 0x80000000\n\t"
			"li $2, -1\n\t"
			"add $1, $2\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* a >= 0, b < 0, a-b < 0 */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"li $1, 0x7fffffff\n\t"
			"li $2, -1\n\t"
			"sub $1, $2\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* a < 0, b >= 0, a-b >= 0 */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"li $1, 0x80000000\n\t"
			"li $2, 1\n\t"
			"sub $1, $2\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* consecutive overflows */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"li $1, 0x7fffffff\n\t"
			"addi $1, 1\n\t"
			"addi $1, 1\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* overflow in BDS, branch taken */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"li $1, 0x7fffffff\n\t"
			"beqz $0, __aluexcA\n\t"
			"addi $1, 1\n\t"
			"nop\n"
			"__aluexcA:\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* overflow just outside BDS */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"li $1, 0x7fffffff\n\t"
			"beqz $0, __aluexcB\n\t"
			"nop\n"
			"addi $1, 1\n\t"
			"nop\n"
			"__aluexcB:\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* overflow outside BDS */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"li $1, 0x7fffffff\n\t"
			"beqz $0, __aluexcC\n\t"
			"nop\n"
			"nop\n"
			"addi $1, 1\n\t"
			"nop\n"
			"__aluexcC:\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	/* overflow in BDS, branch not taken */
	__asm__(".set noreorder\n\t"
			".set noat\n\t"
			"li $1, 0x7fffffff\n\t"
			"bnez $0, __aluexcD\n\t"
			"addi $1, 1\n\t"
			"nop\n"
			"__aluexcD:\n\t"
			"nop\n\t"
			"nop\n\t"
			"nop\n\t");

	puts(">>>");

	return 0;
}
