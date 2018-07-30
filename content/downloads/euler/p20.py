# -*- coding: utf-8 -*-
"""
n! means n × (n − 1) × ... × 3 × 2 × 1

For example, 10! = 10 × 9 × ... × 3 × 2 × 1 = 3628800,
and the sum of the digits in the number 10! is 3 + 6 + 2 + 8 + 8 + 0 + 0 = 27.

Find the sum of the digits in the number 100!
"""


def main():
    n = 100
    p = 1

    while n > 0:
        p = p * n
        n = n - 1

    print sum([int(x) for x in str(p)])

if __name__ == '__main__':
    main()
