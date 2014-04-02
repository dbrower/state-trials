#!/usr/bin/env python

usage = """usage:
./phrase-usage.py <phrase> <year data> cases...

requires the year data to be a CSV file in the format
<case number>, <year>, ...

The phrase is wrapped with  word beginning/ending markers, and
spaces are expanded to allow for any number of spaces.
Prefix the phrase with a percent sign to turn off this behavior.

If the phrase is prefixed with a '@' instead, it is taken as a filename.
The contents of the file is loaded, and each line is taken as a word.
The total proportion of this set of words' occurrence by year is output.

The cases is a list of files where each filename contains an integer,
which is the case's case number
"""

import re
import sys

if len(sys.argv) < 3:
    print usage
    sys.exit(1)

def try_int(x):
    try:
        return int(x)
    except:
        return None

def load_year_data(fname):
    """fname -> {case int: year int}"""
    result = {}
    with open(fname, "r") as f:
        for line in f:
            data = map(try_int, line.split(","))
            case, year = data[:2]
            if case != None and year != None:
                result[case] = year
    return result

# does not include "###" in word count
def read_case(phrase, fname):
    """(phrase string, fname string) -> (count int, words int)"""
    text = []
    with open(fname, "r") as f:
        text = " ".join(map(lambda x: x.strip(), f.readlines()))
    count = len(re.findall(phrase, text))
    text = text.replace("### ","")
    words = len(re.findall(r'\S+', text))
    return (count, words)

def wrap_phrase(phrase):
    """string -> string"""
    s = phrase.lower()
    s = s.replace(" ", r'\s+')
    return r'\b' + s + r'\b'

# year int: (count int, total int)
counts = {}
phrase = sys.argv[1]
if phrase[0] == '@':
    with open(phrase[1:], "r") as f:
        phrases = map(lambda s: wrap_phrase(s.strip()), f.readlines())
        phrase = "|".join(phrases)
elif phrase[0] == '%':
    phrase = phrase[1:]
else:
    phrase = wrap_phrase(phrase)
print '# Searching for %s' % phrase
years = load_year_data(sys.argv[2])
for fname in sys.argv[3:]:
    m = re.search(r'\d+', fname)
    if m == None:
        print "Cannot find case number in file '%s'. Skipping." % fname
        continue
    case_number = int(m.group(0))
    try:
        y = years[case_number]
    except KeyError:
        print "Cannot find year for case number %d." % case_number
        continue
    c, w = read_case(phrase, fname)
    try:
        a, b = counts[y]
        counts[y] = (a + c, b + w)
    except KeyError:
        counts[y] = (c, w)
yy = counts.keys()
yy.sort()
for y in yy:
    c, w = counts[y]
    print "%d %f" % (y, 10000 * (float(c) / float(w)))

