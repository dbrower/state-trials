#!/usr/bin/env python

# ./segment.py [files]
#
# it will create many files of the form <name>-<segnumber>.txt


import re
import sys

stopwords = set()

if len(sys.argv) < 1:
    print "usage: %s <files>" % sys.argv[0]
    sys.exit(1)
for fname in sys.argv[1:]:
    paragraphs = []
    p = []
    with open(fname, "r") as f:
        for line in f:
            if line.strip() == "":
                # don't keep empty paragraphs, or paragraphs containing
                # only one or two lines
                if len(p) > 2:
                    paragraphs.append(p)
                p = []
                continue
            p.append(line)
        if len(p) > 2:
            paragraphs.append(p)

    fbase,sep,ext = fname.rpartition(".")
    if fbase == '':
        fbase = ext
        ext = ''
    else:
        ext = "." + ext
    n = 0
    for para in paragraphs:
        n += 1
        with open("%s-%d%s" % (fbase, n, ext), "w") as out:
            out.write("".join(para))

