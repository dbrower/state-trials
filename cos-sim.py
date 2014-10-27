#!/usr/bin/env python

# ./cos-sim.py [file1] [file2]
#
# computes the cosine simularity between the two files.
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

def norm(mapp):
    result = 0.0
    for w,k in mapp.iteritems():
        result += k**2
    return math.sqrt(result)

def cossim(map1, map2):
    words = set(map1.keys()).intersection(map2.keys())
    result = 0.0
    for w in words:
        result += map1[w] * map2[w]
    result /= norm(map1) * norm(map2)
    return result

if len(sys.argv) < 3:
    print "usage: %s file1 file2" % sys.argv[0]
    sys.exit(1)
data1 = file_to_map(sys.argv[1])
data2 = file_to_map(sys.argv[2])
print cossim(data1, data2)
