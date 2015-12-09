#!/usr/bin/python

class TestSuite:

    DATA_WIDTH = 32
    ADDR_WIDTH = 21


    def __init__(self, filename):
        self.fd = open(filename, "w")
        self.cnt = 0
        self.sig = list()

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

        if self.cnt is 0:
            self.sig.append((name, l))

    def test(self, reset=True, s_busy=False, s_rddata=None, addr=None,
            rd=False, wr=False, byteena=None, wrdata=None):
        self.put(reset, "s_reset", 1)
        self.put(s_busy, "s_mem_in.busy", 1)
        self.put(s_rddata, "s_mem_in.rddata", TestSuite.DATA_WIDTH)
        self.put(addr, "a_mem_out.address", TestSuite.ADDR_WIDTH)
        self.put(rd, "a_mem_out.rd", 1)
        self.put(wr, "a_mem_out.wr", 1)
        self.put(byteena, "a_mem_out.byteena", 4)
        self.put(wrdata, "a_mem_out.wrdata", TestSuite.DATA_WIDTH)
        self.fd.write("\n")
        self.cnt += 1

suite = TestSuite("test.tc")
suite.test(reset=False)
print suite.sig
tmp = 0
for (name, l) in suite.sig:
    tmp += l
for (name, l) in suite.sig:
    if l is 1:
        print("%s <= vec(%i);" % (name, tmp-1))
        tmp -= 1
    else:
        a = tmp-1
        b = tmp-1-l
        print("%s <= vec(%i downto %i);" % (name, a, b+1))
        tmp -= l
suite.test(reset=True)
