# -*- coding: utf-8 -*-

"""A Pythagorean triplet is a set of three natural numbers, a < b < c,
for which,

a^2 + b^2 = c^2
For example, 3^2 + 4^2 = 9 + 16 = 25 = 5^2.

There exists exactly one Pythagorean triplet for which a + b + c =
1000.  Find the product abc.
"""

import itertools


def method_1(n):
    tmp_sum = 0
    for a, b, c in itertools.combinations(range(1, n), 3):
        tmp_sum = a + b + c
        if tmp_sum != n:
            continue

        #a, b, c = sorted([a, b, c])

        if c * c - a * a - b * b == 0:
            print '%d^2+%d^2=%d^2' % (a, b, c)
            print a * b * c
            break


def method_2(n):
    for a, b in itertools.combinations(range(1, n), 2):
        c = n - b - a
        if c in [a, b]:
            continue
        a, b, c = sorted([a, b, c])

        if c * c - a * a - b * b == 0:
            print '%d^2+%d^2=%d^2' % (a, b, c)
            print a * b * c
            break


def main():
    n = 1000
    # method_1(n)
    method_2(n)

if __name__ == '__main__':
    main()
