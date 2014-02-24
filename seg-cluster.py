#!/usr/bin/env python

# implements a cluster algorithm as described in
# Andrea Tagarelli and George Karypis, "A Segment-based Approach To Clustering Multi-Topic Documents".
#
#

# usage:
# ./seg-cluster.py [directory name]
# ./seg-cluster.py [input file] [input file] ...

import math
import os
import sys

class Segment():
    def __init__(self, segnum, docnum, contents):
        self.docnum = docnum
        self.contents = contents
        self.segnum = segnum


class Words():
    def __init__(self):
        self.words = []
        self.rev_index = []
    def add(self, word, docnum):
        try:
            i = self.words.index(word)
            self.rev_index[i].append(docnum)
            return i
        except ValueError:
            self.words.append(word)
            self.rev_index.append([docnum])
            return len(self.words) - 1

# spherical k-means

# input: number of clusters, list of lists of words, stopping epsilon
# output: list of cluster ids

class SKMeans():
    def __init__(self, docs):
        self.words = Words()
        # turn each document into a vector
        # our vectors are actually dictionaries mapping coordinate index to value
        dvec = []
        for i in range(len(docs)):
            doc = docs[i]
            doc.sort()
            vec = {}
            last_word = ""
            last_j = None
            for word in doc:
                if word == last_word:
                    vec[last_j] += 1
                else:
                    j = self.words.add(word, i)
                    vec[j] = vec.get(j,0) + 1
                    last_word = word
                    last_j = j
            dvec.append(vec)
        # compute inverse frequencies and normalize
        # there are two vector spaces here. The first is
        # the count giving the number of times each word appears in a document
        # the second is the space giving the normalized inverse frequency of the document's words
        N = float(len(docs))
        weights = [math.log(N / len(self.words.rev_index[k])) for k in range(len(self.words.words))]
        fvec = []
        for vec in dvec:
            #print "vec",vec
            for k in vec.iterkeys():
                vec[k] *= weights[k]
            fvec.append(normalize(vec))
        self.fvec = fvec

    def means(self, num_clusters):
        # initial clustering is very simple
        # a cluster is represented as a list of indices into the document list
        clusters = [[] for i in range(num_clusters)]
        for i in range(len(self.fvec)):
            clusters[i % num_clusters].append(i)
        t = 0
        old_q_score = -1
        new_q_score = 0
        while t < 10 and new_q_score > old_q_score:
            old_q_score = new_q_score
            t += 1
            cluster_vecs = [vec_mean(c,self.fvec) for c in clusters]
            #print "t=",t,"q_score=",old_q_score,"clusters = ",clusters,"means=",cluster_vecs
            # regroup partitions
            new_q_score = 0
            clusters = [[] for i in range(num_clusters)]
            for j in range(len(self.fvec)):
                m,d = closest_mean(self.fvec[j], cluster_vecs)
                clusters[m].append(j)
                new_q_score += d
        return clusters, new_q_score

def closest_mean(vec, centroid_list):
    # since the dist is the cosine, larger values are better
    d = dist(vec, centroid_list[0])
    best = 0
    #print "dist vec",vec,"cluster 0 =",d
    for i in range(1, len(centroid_list)):
        dd = dist(vec, centroid_list[i])
        #print "dist vec",vec,"cluster",i,"=",dd
        if dd > d:
            d = dd
            best = i
    return best,d

def dist(v1, v2):
    """The cosine of the spherical angle between the two vectors"""
    result = 0
    v1k = v1.viewkeys()
    v2k = v2.viewkeys()
    a = v1k & v2k
    for k in a:
        result += v1[k] * v2[k]
    return result

def vec_mean(partition, universe):
    vec = {}
    for p in partition:
        d = universe[p]
        for k,v in d.iteritems():
            vec[k] = vec.get(k,0) + v
    vec2 = {}
    n = float(len(partition))
    for k,v in vec.iteritems():
        vec2[k] = v / n
    return normalize(vec2)

def normalize(vec):
    r = 0.0
    for k,v in vec.iteritems():
        r += v**2
    m = math.sqrt(r)
    vec2 = {}
    for k,v in vec.iteritems():
        vec2[k] = v / m
    return vec2

def readfile(fname):
    with open(fname, "r") as f:
        data = f.read()
        data = data.replace("###","")   # remove stop pattern
        return data.split()

#def z(s): return s.split()
#skm = SKMeans([
#    z("dog and cat"),
#    z("rain cat and dog"),
#    z("let sleeping dog lie"),
#    z("cat is away"),
#    z("dog is away"),
#    z("rain spain"),
#    z("dog is away"),
#    z("cat is away"),
#    z("rain in spain"),
#])
#print skm.means(3)

if len(sys.argv) == 1:
    print "Usage:"
    print "    ./seg-cluster.py [input file] [input file] ..."
#    print "    ./seg-cluster.py [directory name] ..."
    sys.exit(1)

print "loading documents"
documents = [readfile(name) for name in sys.argv[1:]]
print "indexing documents"
skm = SKMeans(documents)
for i in range(2, 1 + int(math.sqrt(len(documents)/2.0))):
    print
    print "==== %d clusters ====" % i
    clusters,score = skm.means(i)
    print "score = ", score
    print "clusters = "
    for c in clusters:
        print "\t",map(sys.argv[1:].__getitem__, c)



