ifneq (,$(findstring Microsoft,$(shell uname -r)))
	vsim = vsim.exe
else
	vsim = vsim
endif




compile:
	$(vsim) -c -do "do compile.do;quit -f"

clean:
	rm -rf work
	rm -f transcript
	rm -f *.wlf
	rm -f modelsim.ini
	rm -f imem.mif	rm -f imem.mif
	