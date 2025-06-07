# -*- coding: utf-8 -*-
"""
A unit fraction contains 1 in the numerator. The decimal
representation of the unit fractions with denominators 2 to 10 are
given:

1/2	= 	0.5
1/3	= 	0.(3)
1/4	= 	0.25
1/5	= 	0.2
1/6	= 	0.1(6)
1/7	= 	0.(142857)
1/8	= 	0.125
1/9	= 	0.(1)
1/10	= 	0.1

Where 0.1(6) means 0.166666..., and has a 1-digit recurring cycle. It
can be seen that 1/7 has a 6-digit recurring cycle.

Find the value of d < 1000 for which 1/d contains the longest
recurring cycle in its decimal fraction part.
"""

import re


def decimal_fraction(m, n, max_digits=10):
    """Generate division digits up to specified count.

    Back to the very basic of how division is done.
    We keep track of the remainder and multiple as many 10s as
    needed so it can be divided by the given divisor again,
    and on and on and on.

    Arguments:
    m -- numerator
    n -- denominator
    """

    count = 0
    while m and count < max_digits:
        while m < n:
            m *= 10
        yield m / n

        # remainder
        m = m - m / n * n
        count += 1


def main():
    n = 1000

    # regex pattern to identify recurring substring
    recurring_pattern = re.compile(r'^(\d+?)((\d+?)\3+)$')

    max_found = 0
    for x in range(1, n):
        # this magic number is troublesome
        # better, we should replace this with a while loop.
        max_digits_to_search = 10000
        digits = ''.join(str(y)
                         for y in decimal_fraction(1, x, max_digits_to_search))
        tmp = recurring_pattern.findall(digits)
        if tmp:
            pattern = tmp[0][-1]
            if len(pattern) > max_found:
                max_found = len(pattern)
                # print digits
                print x, len(pattern)  # , tmp


if __name__ == '__main__':
    main()
