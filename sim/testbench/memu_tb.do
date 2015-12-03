-- http://stackoverflow.com/questions/9709257/modelsim-message-viewer-empty
vsim -assertcover -assertdebug -msgmode both -displaymsgmode both work.memu_tb
run 2 us
