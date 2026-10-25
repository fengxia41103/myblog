# -*- coding: utf-8 -*-
"""We shall say that an n-digit number is pandigital if it makes use
of all the digits 1 to n exactly once; for example, the 5-digit
number, 15234, is 1 through 5 pandigital.

The product 7254 is unusual, as the identity, 39 × 186 = 7254,
containing multiplicand, multiplier, and product is 1 through 9
pandigital.

Find the sum of all products whose multiplicand/multiplier/product
identity can be written as a 1 through 9 pandigital.

HINT: Some products can be obtained in more than one way so be sure to
only include it once in your sum.
"""


def main():
    n = 9

    products = []
    for a in range(1, 10000):
        for b in range(1, 100):
            c = a * b
            tmp = '%d%d%d' % (a, b, c)

            if '0' in tmp:
                continue

            # too many digits
            if len(tmp) != n:
                continue

            # is 1-9 pendigital number?
            if len(set(tmp)) == len(tmp):  # exactly once
                products.append(c)
                print a, 'x', b, '=', c, tmp
    print sum(set(products))

if __name__ == '__main__':
    main()
