#ifndef _EXCEPTIONS_H_
#define _EXCEPTIONS_H_

extern int __exception_table [16];

/* return value == 0: continue after exception */
/* return value != 0: retry execution */
int __exception_default(unsigned epc, unsigned npc, unsigned cause, unsigned *regs);

extern volatile int __exception_retry;

#endif
