#!/usr/bin/env python

# ./jaq-sim.py [file1] [file2]
#
# computes the Jaccard simularity between the two files.
# A word is a sequence of the following characters
# A-Z, a-z, -, '

import math
import re
import sys

word_chars = re.compile("[A-Za-z][A-Za-z'-]*")
nonword_chars = re.compile("[^A-Za-z]+")

def file_to_map(fname):
    with open(fname, "r") as f:
        content = f.read()
    words = nonword_chars.split(content)
    result = {}
    for w in words:
        ww = w.lower()
        result[ww] = 1 + result.get(ww, 0)
    del result['']
    return result

def union_max(map1, map2):
    result = {}
    for k,v in map1.iteritems():
        result[k] = v
    for k,v in map2.iteritems():
        result[k] = max(v, result.get(k,0))
    return result

def sum_keys(mapp):
    return sum(mapp.values())

def sum_min_keys(map1, map2, keys):
    result = 0
    for k in keys:
        result += min(map1[k], map2[k])
    return result

def cossim(map1, map2):
    k1 = set(map1.keys())
    both = k1.intersection(map2.keys())
    alltogether = k1.union(map2.keys())
    w = float(sum_min_keys(map1, map2, both))
    return w / (sum_keys(map1) + sum_keys(map2) - w)

if len(sys.argv) < 3:
    print "usage: %s file1 file2" % sys.argv[0]
    sys.exit(1)
data1 = file_to_map(sys.argv[1])
data2 = file_to_map(sys.argv[2])
print cossim(data1, data2)
