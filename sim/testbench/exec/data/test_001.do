# test if new_pc gets calculated correctly

force s_op.branch 1
force s_pc_in [dec2bin 8 14]
force s_op.imm [dec2bin 2 32]

force a_new_pc [dec2bin 16 14]

