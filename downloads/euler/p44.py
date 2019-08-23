
# -*- coding: utf-8 -*-

import itertools


def pentagonal_generator(n):
    m = 1
    while m < n:
        yield m * (3 * m - 1) / 2
        m += 1


def method_1():
    n = 3000
    pentagonals = list(pentagonal_generator(n))
    for a, b in itertools.combinations(pentagonals, 2):
        if a + b in pentagonals and abs(a - b) in pentagonals:
            print 'found', a, b, a + b, abs(a - b)


def method_2():
    n = 3000
    pentagonals = list(pentagonal_generator(n))

    # if a, b are two adjacent pentagonal numbers,
    # then a-b fits a pattern: 3n+1
    diffs = filter(lambda x: (x - 1) % 3 == 0, pentagonals)

    for c in diffs:
        for b in filter(lambda x: x < c, pentagonals):
            if c + b in pentagonals and c + 2 * b in pentagonals:
                print 'found', b, c + b, c + 2 * b, c
                return


def main():
    # method_1()
    method_2()

if __name__ == '__main__':
    main()
