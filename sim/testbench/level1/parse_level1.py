#!/usr/bin/python

import os, sys, re

from collections import OrderedDict
from test import TestSuite

def main(result_file, test_file, rec_file=None):

    with open(result_file, "r") as f:
        lines = f.readlines()
        test_id = 0
        tests = dict()
        max_nr = 0
        for line in lines:
            test_id += 1
            m = re.search('^# Failed test: (?P<stimuli>[\w\./]+) (?P<reason>.*) at test (?P<nr>[0-9]+)($|, expected (?P<expect>.*)$)$', line)
            if m is None:
                print("Could not decode line:\n%s" % line)
                continue
            tc = m.groupdict()

            nr = int(tc["nr"])
            if nr not in tests:
                tests[nr] = list()
            tests[nr].append(tc)

            if max_nr < nr:
                max_nr = nr
            
        def parse_test(suite, nr, tests):

            if tests is None:
                suite.test(nr)
                return

            data = dict()
            for test in tests:
                stimuli = test["stimuli"]
                reason = test["reason"]
                expect = test["expect"]
                nr = test["nr"]

                signal = ""
                value = None
                if "wrdata" in stimuli:
                    signal = "wrdata"
                elif "wr" in stimuli and "rd" in stimuli:
                    signal = "wr/rd"
                    data["wr"] = True
                    data["rd"] = True
                    continue
                elif "wr" in stimuli:
                    signal = "wr"
                elif "rd" in stimuli:
                    signal = "rd"
                elif "address" in stimuli:
                    signal = "addr"
                elif "byteena" in stimuli:
                    signal = "byteena"
                else:
                    raise Exception("could not recognize stimuli name %s" % stimuli)

                if "silence" in reason:
                    value = False
                elif "wrong" in reason:
                    value = expect

                data[signal] = value
            print "clk: %s adding test:" % nr,
            print data
            suite.test(nr, **data)

        suite = TestSuite(test_file, record=rec_file)

        suite.addSignal("s_reset", 1, alias="reset", default=True)
        suite.addSignal("s_mem_in.busy", 1, alias="busy", default=False)
        suite.addSignal("s_mem_in.rddata", TestSuite.DATA_WIDTH, alias="rddata", default=0)
        suite.addSignal("a_mem_out.address", TestSuite.ADDR_WIDTH, alias="addr", default=0)
        suite.addSignal("a_mem_out.rd", 1, alias="rd", default=False)
        suite.addSignal("a_mem_out.wr", 1, alias="wr", default=False)
        suite.addSignal("a_mem_out.byteena", 4, alias="byteena", default="1111")
        suite.addSignal("a_mem_out.wrdata", TestSuite.DATA_WIDTH, alias="wrdata", default=0)
        
        for i in range(1, max_nr+1):
            try:
                parse_test(suite, i, tests[i])
            except KeyError:
                print("There is a missing testcase for clock %i, I'll insert a blank check" % i)
                parse_test(suite, i, None)




if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("usage: %s RESULT_FILE TEST_FILE" % sys.argv[0])
        sys.exit(1)
    rec = None
    if len(sys.argv) is 4:
        rec = sys.argv[3]

    main(sys.argv[1], sys.argv[2], rec)


