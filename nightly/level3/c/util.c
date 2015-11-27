#define UART_STATUS (*((volatile char*)(-8)))
#define UART_DATA (*((volatile char*)(-4)))

int getchar() {
	while ((UART_STATUS & 0x02) == 0) {
		/* wait for UART */
	}
	/* read from UART */
	return UART_DATA;
}

int putchar(int c) {
	while ((UART_STATUS & 0x01) == 0) {
		/* wait for UART */
	}
	/* write to UART */
    UART_DATA = c;
	return c;
}

int putstring(const char *s) {
	while (*s != '\0') {
		putchar(*s++);
	}
	return 0;
}

int puts(const char *s) {
	putstring(s);
	putchar('\n');
	return 0;
}

void *memcpy(void *dest, const void *src, unsigned n) {
	while (n-- > 0) {
		*(char*)dest++ = *(char*)src++;
	}
	return dest;
}

unsigned strlen(const char *s) {
	unsigned i = 0;
	while (*s++ != '\0') {
		i++;
	}
	return i;
}

int strcmp(const char *s1, const char *s2) {
	for (;;) {
		char a = *s1++;
		char b = *s2++;
		if (a == '\0' && b == '\0') {
			return 0;
		}
		int d = a - b;
		if (d != 0) {
			return d;
		}
	}
}
