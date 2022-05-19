Steps to add sim testbench to MiMi Project:

**Needed Files and Directories:**

* ```program/*.mif```
* ```testbench/```
* ```compile.do```
* ```core.do```
* ```level1.do```
* ```level1_tb.vhd```
* ```Makefile```
* ```txt_util.vhd```
* ```util.do```

1. Try ```make compile``` (If this works go straight to step 2, If not do Substeps)
	1. If it does not compile alter ```sim/compile.do``` to match your project files
	2. Try ```make clean``` then go to Step 1
2. Use ```make level1``` to start the test and run it! :)

*The Output gets written to ```report.txt``` and only the summary is shown in the Terminal.*