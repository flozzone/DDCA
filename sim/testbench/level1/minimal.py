#!/usr/bin/python

from test import TestSuite

suite = TestSuite("data/minimal.tc")

suite.addSignal("s_reset", 1, alias="reset", default=True)
suite.addSignal("s_mem_in.busy", 1, alias="busy", default=False)
suite.addSignal("s_mem_in.rddata", TestSuite.DATA_WIDTH, alias="rddata", default=0)
suite.addSignal("a_mem_out.address", TestSuite.ADDR_WIDTH, alias="addr", default=0)
suite.addSignal("a_mem_out.rd", 1, alias="rd", default=False)
suite.addSignal("a_mem_out.wr", 1, alias="wr", default=False)
suite.addSignal("a_mem_out.byteena", 4, alias="byteena", default="1111")
suite.addSignal("a_mem_out.wrdata", TestSuite.DATA_WIDTH, alias="wrdata", default=0)

suite.printSignalAssignments()

# minimal.s
#_start:
#    nop
#    lw $0,4($0)
#    nop
#    nop
#    sw $0,8($0)
#    nop
#    nop
#
#    .end _start

suite.test(1)
suite.test(2)
suite.test(3)
suite.test(4)
suite.test(5, rd=True, addr="000000000000000000100")
suite.test(6)
suite.test(7)
suite.test(8, addr="000000000000000001000", byteena="1111", wrdata="00000000000000000000000000000000")
suite.test(9)
suite.test(10)
