# -*- coding: utf-8 -*-
"""The fraction 49/98 is a curious fraction, as an inexperienced
mathematician in attempting to simplify it may incorrectly believe
that 49/98 = 4/8, which is correct, is obtained by cancelling the 9s.

We shall consider fractions like, 30/50 = 3/5, to be trivial examples.

There are exactly four non-trivial examples of this type of fraction,
less than one in value, and containing two digits in the numerator and
denominator.

If the product of these four fractions is given in its lowest common
terms, find the value of the denominator.
"""

from fractions import Fraction


def main():
    result = 1
    for x in range(11, 100):
        for y in range(x + 1, 100):
            # test criteria: y not multiple of 10
            if y % 10 == 0:
                continue

            # test criteria: not in non-trivial pattern
            if x % 10 != y / 10:
                continue

            # test criteria: is the type of fraction
            if Fraction(x, y) == Fraction(x / 10, y % 10):
                result *= Fraction(x, y)
    print result

if __name__ == '__main__':
    main()
