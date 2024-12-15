# -*- coding: utf-8 -*-

"""145 is a curious number, as 1! + 4! + 5! = 1 + 24 + 120 = 145.

Find the sum of all numbers which are equal to the sum of the
factorial of their digits.

Note: as 1! = 1 and 2! = 2 are not sums they are not included.
"""

from math import factorial


def main():
    # bound
    n = 100000

    # factorials of 0-9. Note: f(0) = 1
    factorials = [factorial(x) for x in range(0, 10)]

    # iterate all nubmers in bound
    result = 0
    for x in range(1, n):
        tmp = sum(factorials[int(s)] for s in str(x))
        if x == tmp:
            result += x
            print tmp
    print result - (1 + 2)

if __name__ == '__main__':
    main()
