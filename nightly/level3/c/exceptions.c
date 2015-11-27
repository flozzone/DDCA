static void clear_pending(int i) {
	int cause;
	__asm__("mfc0 %0, $13" : "=r"(cause));
	cause &= ~(1 << (i+10));
	__asm__("mtc0 %0, $13" : : "r"(cause));	
}

static void dump(unsigned v) {
	int i;
	for (i = 0; i < 8; i++) {
		int num = (v >> (28-4*i)) & 0xf;
		char digit = num <= 9 ? num + '0' : num - 10 + 'A';
		putchar(digit);
	}
}

static void dump_regs(unsigned *regs) {
	int i;
	puts("Regs: ");
	for (i = 0; i < 32; i++) {		
		dump(regs[i]);
		if ((i & 0x03) == 0x03) {
			putchar('\n');			
		} else {
			putchar(' ');
		}
	}
}

static void dump_all(unsigned npc, unsigned epc, unsigned cause, unsigned *regs) {
	putstring("EPC: ");
	dump(epc);
	putchar('\n');

	putstring("NPC: ");
	dump(npc);
	putchar('\n');

	putstring("Cause: ");
	dump(cause);
	putchar('\n');

	dump_regs(regs);
}

volatile int __exception_retry = 0;

int __exception_default(unsigned npc, unsigned epc, unsigned cause, unsigned *regs) {
	unsigned num = (cause >> 2) & 0xf;

	if (num != 0) {
		char digit = num <= 9 ? num + '0' : num - 10 + 'A';
		putstring("X#");
		putchar(digit);
		putchar('\n');

		/* dump_all(npc, epc, cause, regs); */
		dump(epc);
		putchar('\n');
		dump(npc);
		putchar('\n');
		dump(cause);
		putchar('\n');

		/* do as we are told */
		int retry = __exception_retry;
		if (retry < 0) {
			for (;;); /* die */
		} else {
			return __exception_retry;
		}
	} else {
		int i;
		char digit = 'X';

		num = (cause >> 10) & 0x1f;
		for (i = 0; i < 5; i++) {
			if (num & (1 << i)) {
				digit = '0'+i;
				clear_pending(i);
				break;
			}
		}		

		putstring("I#");
		putchar(digit);
		putchar('\n');

		if (epc != npc) {
			dump(epc);
			putchar('\n');
			dump(npc);
			putchar('\n');
		}
		dump(cause & 0x7fffffff); // don't care about BDS
		putchar('\n');
		
		/* re-execute interrupted instruction */
		return 1;
	}

	/* die */
	/* for(;;); */
	/* keep going */
	/* return 0; */
	/* try again */
	/* return 1; */
}
