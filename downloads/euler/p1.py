# -*- coding: utf-8 -*-

"""If we list all the natural numbers below 10 that are multiples of
3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.

Find the sum of all the multiples of 3 or 5 below 1000.

"""

import sys


def natural_number_divisible(n, d):
    '''Find natural number between [1,n] that is
    divisible by "d".
    '''
    num = 0
    while num < n:
        if num and not num % d:  # num%d=0
            yield num
        num += d


def main():
    n = 1000

    result = 0
    for d in [3, 5]:
        for c in natural_number_divisible(n, d):
            result += c

    # multiple of 3*5 has been counted twice
    for c in natural_number_divisible(n, 3 * 5):
        result -= c

    # final result
    print result

if __name__ == '__main__':
    main()
