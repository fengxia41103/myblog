# -*- coding: utf-8 -*-

from operator import mul    # or mul=lambda x,y:x*y
from fractions import Fraction


def nCk(n, k):
    return int(reduce(mul, (Fraction(n - i, i + 1) for i in range(k)), 1))


def main():
    BENCHMARK = 10 ** 6
    n = 100
    count = 0
    for i in range(10, n + 1):
        for j in range(3, i - 2):
            if nCk(i, j) > BENCHMARK:
                count += 1
    print count

if __name__ == '__main__':
    main()
