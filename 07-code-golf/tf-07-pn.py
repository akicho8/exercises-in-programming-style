#!/usr/bin/env python3
# My golf score is slightly lower!  
# Best wishes, Peter Norvig
import re, sys, collections

stopwords = set(open('../stop_words.txt').read().split(','))
words = re.findall('[a-z]{2,}', open("../input.txt").read().lower())
counts = collections.Counter(w for w in words if w not in stopwords)
for (w, c) in counts.most_common(25):
    print(w, '-', c)
