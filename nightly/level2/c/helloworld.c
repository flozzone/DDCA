int main() {
	int i,k;

	puts("Hello, MiMi");

	for (k = 0; k < 10; k++) {
		/* delay loop */
		for (i = 0; i < 3000000; i++) {
			__asm__("");
		}
		/* sign of life */
		putchar('0'+k);
	}
	putchar('\n');

	return 0;
}
