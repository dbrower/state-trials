#!/usr/bin/env python

usage = """usage:
./phrase-usage.py  <phrase list> "--" cases...

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

if len(sys.argv) < 4:
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
    """(phrase string, fname string) -> (count int, stopped_words int, all_words int)"""
    text = []
    with open(fname, "r") as f:
        text = " ".join(map(lambda x: x.strip(), f.readlines()))
    count = len(re.findall(phrase, text))
    all_words = len(re.findall(r'\S+', text))
    text = text.replace("### ","")
    words = len(re.findall(r'\S+', text))
    return (count, words, all_words)

def wrap_phrase(phrase):
    """string -> string"""
    s = phrase.lower()
    s = s.replace(" ", r'\s+')
    return r'\b' + s + r'\b'

# year int: (count int, total int)
counts = {}
phrase_list = []
case_index = 1
for phrase in sys.argv[1:]:
    case_index += 1
    if phrase == "--":
        break
    #elif phrase[0] == '@':
    with open(phrase, "r") as f:
        p = map(lambda s: wrap_phrase(s.strip()), f.readlines())
        phrase = "|".join(p)
    #elif phrase[0] == '%':
    #    phrase = phrase[1:]
    #else:
    #    phrase = wrap_phrase(phrase)
    phrase_list.append(phrase)
if case_index >= len(sys.argv):
    print "Missing '--' separator in command line"
    sys.exit(1)
#print '# Searching for %s' % sys.argv[1:case_index-1]
print '# case %s stopped unstopped' % (" ".join(sys.argv[1:case_index-1]))
#years = load_year_data(sys.argv[1])
for fname in sys.argv[case_index:]:
    m = re.search(r'\d+', fname)
    if m == None:
        print "Cannot find case number in file '%s'. Skipping." % fname
        continue
    case_number = int(m.group(0))
    counts[case_number] = []
    for phrase in phrase_list:
        c, w, a = read_case(phrase, fname)
        counts[case_number].append((c, w, a))
yy = counts.keys()
yy.sort()
for y in yy:
    clist = counts[y]
    print " ".join(["%d" % y] + ["%f" % (10000 * (float(c) / float(w))) for c,w,a in clist] + ["%d %d" % (clist[0][1], clist[0][2])])
    #print "%d %f %d" % (y, 10000 * (float(c) / float(w)), w)

