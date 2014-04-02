#!/usr/bin/env python

# ./remove-stopwords.py stopwords-99-1 bag-151.txt

import re
import sys

stopwords = set()

if len(sys.argv) < 1:
    print "usage: %s <stopword file> <files>"
    sys.exit(1)
with open(sys.argv[1], "r") as f:
    body = f.read()
    stopwords.update(body.split())

word_pat = re.compile(r'[\W\d]+')

for fname in sys.argv[2:]:
    new_file = []
    with open(fname, "r") as f:
        for line in f:
            new_line = []
            for w in word_pat.split(line):
                w = w.lower()
                if w not in stopwords:
                    new_line.append(w)
                else:
                    new_line.append("###")
            new_file.append(" ".join(new_line) + "\n")

    with open("stop-" + fname, "w") as out:
        out.write("".join(new_file))

