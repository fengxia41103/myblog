# -*- coding: utf-8 -*-

import csv
import string


def main():
    get_score = lambda x: sum([string.ascii_uppercase.find(i) + 1 for i in x])

    names = None
    with open('p042_words.txt', 'rb') as f:
        names = list(csv.reader(f))[0]
    word_scores = dict((n, get_score(n)) for n in names)
    triangle_numbers = [
        n * (n + 1) / 2 for n in range(1, max(word_scores.values()) / 2)]

    result = filter(lambda x: word_scores[x] in triangle_numbers, word_scores)
    print len(result)

if __name__ == '__main__':
    main()
