vlib work
vmap work work

vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis 	 ../src/core_pack.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/op_pack.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/ctrl.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/regfile.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/decode.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/ram/src/dp_ram_1c1r1w.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/ram/src/dp_ram_1c1r1w_beh.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/alu.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/exec.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/testbenches/exec_tb.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis 	 ../src/imem_altera.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/fetch.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/math/src/math_pkg.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/ram/src/ram_pkg.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/ram/src/fifo_1c1r1w.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/ram/src/fifo_1c1r1w_mixed.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/fwd.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/jmpu.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/memu.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/mem.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/testbenches/memu_tb.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/pll_altera.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/ocram_altera.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/wb.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/pipeline.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/testbenches/regfile_tb.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/synchronizer/src/sync_pkg.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/synchronizer/src/sync.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/synchronizer/src/sync_beh.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/serial_port/src/serial_port_receiver_pkg.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/serial_port/src/serial_port_receiver.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/serial_port/src/serial_port_receiver_beh.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/serial_port/src/serial_port_transmitter_pkg.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/serial_port/src/serial_port_transmitter.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/serial_port/src/serial_port_transmitter_beh.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/serial_port/src/serial_port_pkg.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/serial_port/src/serial_port.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/serial_port/src/serial_port_beh.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/testbench_util/src/testbench_util_pkg.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/serial_port/src/serial_port_testbench.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/serial_port_wrapper.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/testbenches/txt_util.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/core.vhd
vcom -reportprogress 300 -work work -2008 -explicit -check_synthesis -O0 -check_synthesis ../src/mimi.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/testbenches/level1_tb.vhd
vcom -reportprogress 300 -work work -2002 -explicit ../src/testbenches/alu_tb.vhd
vcom -reportprogress 300 -work work -2008 -explicit ../src/testbenches/core_tb.vhd