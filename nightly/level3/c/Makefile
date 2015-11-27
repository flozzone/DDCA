PREFIX=/usr/mips

CC=${PREFIX}/bin/mips-elf-gcc -mips1 -msoft-float
LD=${PREFIX}/bin/mips-elf-ld -N -Ttext=0x40000000 --section-start .rodata=4
AS=${PREFIX}/bin/mips-elf-as
AR=${PREFIX}/bin/mips-elf-ar
OBJCOPY=${PREFIX}/bin/mips-elf-objcopy

CFLAGS=-O2 -DARCH_IS_BIG_ENDIAN=1

all: lib helloworld md5 decexc aluexc memexc intrs

helloworld: helloworld.imem.mif helloworld.dmem.mif
helloworld.elf: helloworld.o
	${LD} -o $@ crt0.o $^ -L. -lc

md5: md5.imem.mif md5.dmem.mif
md5.elf: md5.o md5main.o
	${LD} -o $@ crt0.o $^ -L. -lc

decexc: decexc.imem.mif decexc.dmem.mif
decexc.elf: decexc.o
	${LD} -o $@ crt0.o $^ -L. -lc

aluexc: aluexc.imem.mif aluexc.dmem.mif
aluexc.elf: aluexc.o
	${LD} -o $@ crt0.o $^ -L. -lc

memexc: memexc.imem.mif memexc.dmem.mif
memexc.elf: memexc.o
	${LD} -o $@ crt0.o $^ -L. -lc

intrs: intrs.imem.mif intrs.dmem.mif
intrs.elf: intrs.o
	${LD} -o $@ crt0.o $^ -L. -lc

lib: crt0.o libc.a

libc.a: exceptions.o util.o
	${AR} rc $@ $^

%.imem.hex : %.elf
	${OBJCOPY} -j .text -O ihex $< $@

%.dmem.hex : %.elf
	${OBJCOPY} -R .text -O ihex $< $@

%.mif : %.hex
	./hex2mif.pl < $< > $@

clean:
	rm -rf libc.a *.s *.o *.elf *.hex *.mif

.PHONY: all lib helloworld md5 decexc aluexc memexc intrs clean