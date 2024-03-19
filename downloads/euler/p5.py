# -*- coding: utf-8 -*-

"""
2520 is the smallest number that can be divided by each of the numbers
from 1 to 10 without any remainder.

What is the smallest positive number that is evenly divisible by all
of the numbers from 1 to 20?
"""


import itertools


def method_1(target):
    """Method 1 is a bit over complex.  We are to turn all target values
    into a list of prime factors.  Then we compare each factor list to
    compute how many 2s, 3s.. and so on each list represents. We then
    take the max count of 2s, 3s... and so on to form a master list.
    This master list will be able to derive all target values.
    """
    results = {}

    # find prime factors
    for i in range(1, target):
        factors = []

        j = 2
        while j * j <= i:
            while i % j == 0 and i > j:
                i = i / j
                factors.append(j)
            j += 1

        factors.append(i)
        for key, g in itertools.groupby(factors):
            if key in results:
                results[key] = max(len(list(g)), results[key])
            else:
                results[key] = len(list(g))

    multiple = []
    for key, count in results.iteritems():
        multiple += [key] * count

    print reduce(lambda x, y: x * y, multiple)


def method_2(target):
    """Method 2 uses a base factor list
    to iterate. The idea is to divide target as much
    as possible using all factors on the list. If there is
    still a remainder, add that to factor list. This way,
    we are searching the minimum factor list that represents
    a target value.
    """
    factors = [2, ]
    for i in range(1, target):
        for f in factors:
            if i % f == 0:
                i = i / f
        factors.append(i)
    print reduce(lambda x, y: x * y, factors)


def main():
    n = 20

    method_1(n)
    method_2(n)

if __name__ == '__main__':
    main()
