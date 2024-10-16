# -*- coding: utf-8 -*-

"""The number, 197, is called a circular prime because all rotations
of the digits: 197, 971, and 719, are themselves prime.

There are thirteen such primes below 100: 2, 3, 5, 7, 11, 13, 17, 31,
37, 71, 73, 79, and 97.

How many circular primes are there below one million?
"""

from p10 import is_prime
from itertools import permutations
from collections import deque


def main():
    n = 1000000

    results = []
    for digits in range(2, 7):
        # save all primes of n-digit
        primes = []

        tens = [10 ** i for i in range(digits)]
        coeff = permutations([1, 3, 7, 9] * digits, digits)

        # iterate coefficient combo
        for c in set(coeff):
            # test criteria: 1 or 7 in coeff
            if 1 not in c and 7 not in c:
                continue

            # target number
            num = reduce(lambda x, y: x + y, [x * y for x, y in zip(c, tens)])

            # test criteria: is prime?
            if is_prime(num):
                primes.append(c)

        # test criteria: is circular variation a prime?
        for c in primes:
            # circular
            tmp = deque(c)
            i = 1
            while tuple(tmp) in primes and i < digits + 1:
                tmp.rotate(-1)
                i += 1
            if i == digits + 1:
                print '%d digits' % digits, c
                results.append(c)

    # plus 2,3,5,7 back
    print len(set(results)) + 4


if __name__ == '__main__':
    main()
