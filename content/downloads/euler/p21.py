# -*- coding: utf-8 -*-
"""Let d(n) be defined as the sum of proper divisors of n (numbers
less than n which divide evenly into n).  If d(a) = b and d(b) = a,
where a ≠ b, then a and b are an amicable pair and each of a and b are
called amicable numbers.

For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20,
22, 44, 55 and 110; therefore d(220) = 284. The proper divisors of 284
are 1, 2, 4, 71 and 142; so d(284) = 220.

Evaluate the sum of all the amicable numbers under 10000.
"""


def divisor(n):
    d = 1

    # we only need to search
    # n/2+1 for a divisor
    while d < (n / 2 + 1):
        if n % d == 0:
            yield d
        d += 1


def main():
    n = 10000
    amicable_numbers = []

    # enumerate all numbers under given "n"
    # and test for amicable numbers per requirement
    # listed in the problem
    while n > 0:
        if n not in amicable_numbers:
            test = sum(divisor(n))
            if n == test:
                # a=b
                pass
            elif n == sum(divisor(test)):
                amicable_numbers += [n, test]
        n -= 1

    print sum(set(amicable_numbers))

if __name__ == '__main__':
    main()
