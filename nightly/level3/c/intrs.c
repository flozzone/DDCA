#include "exceptions.h"

volatile int cnt = 0;

int main() {	
	/* die upon exceptions */
	__exception_retry = -1;

	/* wait for interrupts to occur */
	for (;;) {
		int i = cnt;
		cnt++;
		if (cnt != i+1) {
			puts("!");
		}
	}
}
