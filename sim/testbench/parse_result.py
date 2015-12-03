#!/usr/bin/python


import os, sys, re



def clean_value(value):
    ret = value.strip().replace("-", "X")
    if len(ret) > 1:
        return "\"" + ret + "\""
    return ret

def parse_patterns(line, names):
    name_dict = dict()
    name_list = names.split(" ")
    for name in name_list:
        rec_list = name.split(".")
        if len(rec_list) > 1:
            if rec_list[0] not in name_dict:
                name_dict[rec_list[0]] = list()
            name_dict[rec_list[0]].append(rec_list[1])
        else:
            name_dict[name] = name
    #print name_dict

    m = re.findall('(?P<simplekey>\w+)=(?P<value>\w+)|(?P<listkey>\w+)=\((?P<record>.+)\)', line)
    value_dict = dict()
    for simplekey, value, listkey, record in m:
        if simplekey:
            value_dict[simplekey] = clean_value(value)
        else:
            value_dict[listkey] = list()
            reclist = record.split(",")
            for rec in reclist:
                value_dict[listkey].append(clean_value(rec))
    #print value_dict

    force_dict = dict()
    for key, val in value_dict.iteritems():
        if not isinstance(val, list):
            if not key in name_dict:
                print "key: " + key + " not found in pattern " + str(name_dict)
                assert False
            force_dict[key] = val
        else:
            if not key in name_dict:
                print "record key: " + key + " not found in pattern " + str(name_dict)
                assert False

            for i in range(0, len(val)):
                force_dict[key + "." + name_dict[key][i]] = val[i]

    print force_dict
    return force_dict

def main(result_file, out_folder, stimuli_pattern, expect_pattern):

    if not os.path.isdir(out_folder):
        os.mkdir(out_folder)

    with open(result_file, "r") as f:
        lines = f.readlines()
        test_id = 0
        for line in lines:
            test_id += 1
            test_file = out_folder + "/test" + str(test_id) + ".do"
            m = re.search('^# Failed test: (?P<stimuli>.+), result (?P<result>.+), expected (?P<expect>.+)', line)
            testcase = m.groupdict()
            stimuli_dict = parse_patterns(testcase["stimuli"], stimuli_pattern)
            expect_dict = parse_patterns(testcase["expect"], expect_pattern)

            with open(test_file, "w") as f:
                for key, value in stimuli_dict.iteritems():
                    f.write("force s_" + key + " " + value + "\n")
                for key, value in expect_dict.iteritems():
                    f.write("force a_" + key + " " + value + "\n")

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("usage: %s RESULT_FILE OUTPUT_FOLDER STIMULI_PATTERN EXPECT_PATTERN" % sys.argv[0])
        print("\nexample: ./parse_result.py memu/test_output.txt memu/data \"op.memread op.memwrite op.memtype A W D\" \"M.address M.rd M.wr M.byteena M.wrdata R XL XS\"")
        sys.exit(1)
    main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
