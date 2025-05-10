# -*- coding: utf-8 -*-

from fractions import Fraction


def method_1():
    # nth iteration floating number form
    nth = lambda n: 1 + \
        Fraction(1, reduce(lambda x, y: Fraction(1, x) + y, [2] * n))

    # all in fractional form
    frac = map(nth, range(1, 1001))

    # test: numerator has more digits
    result = filter(
        lambda x: len(str(x.numerator)) > len(str(x.denominator)), frac)

    print len(result)


def method_2():
    n, d = 1, 2
    count = 0
    for i in range(2, 1001):
        n, d = d, d * 2 + n

        # test: numerator has more digits
        if len(str(n + d)) > len(str(d)):
            count += 1
    print count


def main():
    method_2()

if __name__ == '__main__':
    main()
