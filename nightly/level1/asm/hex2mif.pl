#!/usr/bin/perl
# 2005 - David Grant.
# Take an ihex input from STDIN, and write a .mif file to STDOUT
# This script could probably be implemented with something like:
#    $#!@_%^$@%$@%$_!^$@#^@%$#@_%$@^&!%$_!%!%&$*(#^#@%^) 
# But I perfer the somewhat readable version.

# Flow from within the Nios2 SDK Shell:
# nios2-elf-as file.asm -o file.o
# nios2-elf-objcopy file.o --target ihex file.hex
# cat file.hex | perl hex2mif.pl > file.mif

sub conv {
	my ($in) = @_;
#   Changes endianness
#	$out = substr($in,6,2).substr($in,4,2).substr($in,2,2).substr($in,0,2);
	$out = $in;
	return hex $out;
}

my @code = ();
$hiaddr = 0;

while (<STDIN>) {
	$l = $_;
	$count = (hex substr($l, 1, 2)) / 4;
	$addr = (hex substr($l, 3, 4)) / 4;
	$type = (hex substr($l, 7, 2));
	last if $type eq 1;
	next if $type eq 5; # ignore record type 5
	if ($type eq 4) {   # upper 16 bits of address, topmost 2 bits are bogus
		$hiaddr = ((hex substr($l, 9, 4)) & 0x3fff) << 16;
		next;
	}
	if ($type eq 0) {   # actual data
		for($x=0; $x<$count; $x++) {
			$code[$hiaddr + $addr + $x] = conv(substr($l, 9+8*$x, 8));
		}
		next;
	}
	printf("Unknown Intel hex record: %s\n", $l);
}

print("WIDTH=32;\n");
print("ADDRESS_RADIX=HEX;\n");
print("DATA_RADIX=HEX;\n");
print("DEPTH=".@code.";\n");
print("CONTENT BEGIN\n");
for($x=0; $x<@code; $x++) {
	printf("\t%08x : %08x;\n", $x, $code[$x]);
}
print("END;\n");

