PROJECT=asmtest

PREFIX=/usr/mips

CC=${PREFIX}/bin/mips-elf-gcc -mips1 -msoft-float
LD=${PREFIX}/bin/mips-elf-ld -N -Ttext=0x40000000 --section-start .rodata=4
AR=${PREFIX}/bin/mips-elf-ar
OBJCOPY=${PREFIX}/bin/mips-elf-objcopy

CFLAGS=-O2 -DARCH_IS_BIG_ENDIAN=1

all: lib conf

conf: ${PROJECT}.imem.mif ${PROJECT}.dmem.mif
	cp ${PROJECT}.imem.mif ../src/imem.mif
	cp ${PROJECT}.dmem.mif ../src/dmem.mif

helloworld.elf: helloworld.o
	${LD} -o $@ crt0.o $^ -L. -lc

asmtest.elf: asmtest.o
	${LD} -o $@ $^

lib: crt0.o libc.a

libc.a: util.o
	${AR} rc $@ $^

%.imem.hex : %.elf
	${OBJCOPY} -j .text -O ihex $< $@

%.dmem.hex : %.elf
	${OBJCOPY} -R .text -O ihex $< $@

%.mif : %.hex
	./hex2mif.pl < $< > $@

clean:
	rm -rf *.o *.elf *.hex *.mif *~

.PHONY: all lib conf clean
