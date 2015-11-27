PREFIX=/usr/mips

CC=${PREFIX}/bin/mips-elf-gcc -mips1 -msoft-float
LD=${PREFIX}/bin/mips-elf-ld -N -Ttext=0x40000000 --section-start .rodata=4
AS=${PREFIX}/bin/mips-elf-as
AR=${PREFIX}/bin/mips-elf-ar
OBJCOPY=${PREFIX}/bin/mips-elf-objcopy

CFLAGS=-O2 -DARCH_IS_BIG_ENDIAN=1

all: minimal.mif arith.mif memory.mif jump.mif

%.elf: %.o
	${LD} -o $@ $^

%.o : %.s
	${AS} -o $@ $<

%.hex : %.elf
	${OBJCOPY} -j .text -O ihex $< $@

%.mif : %.hex
	./hex2mif.pl < $< > $@

clean:
	rm -rf *.o *.elf *.hex *.mif

.PHONY: all lib conf clean
