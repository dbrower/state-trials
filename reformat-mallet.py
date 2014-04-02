#!/usr/bin/env python

# reformat the mallet output file

import fileinput


for line in fileinput.input():
    parts = line.split("\t")
    if len(parts) < 2:
        continue
    coord = {}
    i = 1
    while i + 2 <= len(parts):
        coord[int(parts[i])] = parts[i+1]
        i += 2
    result = [parts[0]]
    for i in range(10):
        result.append(coord.get(i, 0))
    print ",".join(result)

