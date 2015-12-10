#!/usr/bin/python

from collections import OrderedDict

class TestSuite:

    DATA_WIDTH = 32
    ADDR_WIDTH = 21


    def __init__(self, filename):
        self.fd = open(filename, "w")
        self.sig = OrderedDict()
        self.total_width = 0

    def __del__(self):
        self.fd.close()

    @staticmethod
    def dec2bin(dec, l):
        if dec < 0:
            return bin(dec & 2**l-1)
        else:
            return str("{:0"+str(l)+"b}").format(dec)

    @staticmethod
    def conv(arg, l):
        if isinstance(arg, basestring):
            if len(arg) > l:
                raise "String too long"
            return arg

        if isinstance(arg, (int, long)):
            return TestSuite.dec2bin(arg, l)

        if isinstance(arg, bool):
            if l is not 1:
                raise "Booleans need a length of 1"
            if arg:
                return "1"
            else:
                return "0"

        if arg is None:
            return TestSuite.dec2bin(0, l)

    def put(self, arg, name, l):
        self.fd.write(TestSuite.conv(arg, l))

    def printSignalAssignments(self):
        tmp = self.total_width

        for list_name, signature in self.sig.iteritems():
            name = signature['signal_name']
            l = signature['length']
            if l is 1:
                print("%s <= vec(%i);" % (name, tmp-1))
                tmp -= 1
            else:
                a = tmp-1
                b = tmp-1-l
                print("%s <= vec(%i downto %i);" % (name, a, b+1))
                tmp -= l

    def addSignal(self, signal_name, length, **kwargs):

        name = None
        if "alias" in kwargs:
            name = kwargs["alias"]
        else:
            name = signal_name

        if name in self.sig:
            raise "Signal %s already added" % name

        default = kwargs["default"]

        signature = dict()
        signature['length'] = length
        signature['signal_name'] = signal_name
        signature['default'] = default

        self.sig[name] = signature
        self.total_width += length

    def test(self, nr, **kwargs):

        for name, signature in self.sig.iteritems():
            if name in kwargs:
                self.put(kwargs[name], signature['signal_name'], signature['length'])
            else:
                if signature['default'] is None:
                    raise "No default value set for %s" % name
                self.put(signature['default'], signature['signal_name'], signature['length'])
        self.fd.write("\n")

suite = TestSuite("test.tc")

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
