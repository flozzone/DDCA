ifneq (,$(findstring Microsoft,$(shell uname -r)))
	vsim = vsim.exe
else
	vsim = vsim
endif

compile:
	$(vsim) -c -do "do compile.do;quit -f"

level1: compile
	$(vsim)  -c -do "do level1.do;quit -f"

clean:
	rm -rf work
	rm -f transcript
	rm -f *.wlf
	rm -f modelsim.ini
	rm -f imem.mif
	
.PHONY: clean level1