#!/usr/bin/env python3
import heapq, re, sys

words = re.findall("[a-z]{2,}", open("../input.txt").read().lower())
for w in heapq.nlargest(25, set(words) - set(open("../stop_words.txt").read().split(",")), words.count):
    print(w, '-', words.count(w))
