-- http://stackoverflow.com/questions/9709257/modelsim-message-viewer-empty
vsim -assertcover -assertdebug -msgmode both -displaymsgmode both work.memu_tb
do memu_tb_wave.do

force s_op.memread 0
force s_op.memwrite 0
force s_op.memtype MEM_W
force s_A 000000000000000000000
force s_W 00000000000000000000000000000000
force s_D 00000000000000000000000000000000

force a_M.address 000000000000000000000
force a_M.rd 0
force a_M.wr 0
force a_M.byteena 1111
force a_M.wrdata 00000000000000000000000000000000

run 2 ps
