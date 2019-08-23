# -*- coding: utf-8 -*-

"""The number 3797 has an interesting property. Being prime itself,
it is possible to continuously remove digits from left to right, and
remain prime at each stage: 3797, 797, 97, and 7. Similarly we can
work from right to left: 3797, 379, 37, and 3.

Find the sum of the only eleven primes that are both truncatable from
left to right and right to left.

NOTE: 2, 3, 5, and 7 are not considered to be truncatable primes.
"""

from p10 import is_prime, get_primes
import itertools


def method_1():
    n = 5000000
    ends = ['3', '7']
    digits = ends + ['9']

    primes = []

    # test criteria: 3,7,9
    test = (lambda x: not (set(str(x)) - set(digits)))
    for i in range(1, n):
        if test(i) and is_prime(i):
            primes.append(i)

    # truncate variation primality test
    # test criteria: truncated variation (both left & right) is a prime
    test = (
        lambda x, i: set([int(''.join(x[:-i])),  int(''.join(x[i:]))]) < set(primes))

    count = 0
    for num in map(list, map(str, primes)):
        if num[0] not in ends and num[-1] not in ends:
            continue

        i = 1
        while i < len(num) and test(num, i):
            i += 1

        # good
        if i == len(num):
            count += 1
            print count, int(''.join(num))


def method_2():
    ends = [3, 7]
    digits = [3, 7, 9]

    test_1 = (lambda x, i: is_prime(int(''.join(x[-i:]))))
    test_2 = (lambda x, i: is_prime(int(''.join(x[:i]))))

    count = 0
    digit_count = 2
    result = []
    while count < 11:  # use the hint
        print 'on digit count', digit_count

        # break down a number to coefficients and 10s
        coeff = [ends] + [digits for i in range(digit_count - 2)] + [ends]

        # iterate problem space
        for c in itertools.product(*coeff):
            if c[:2] not in [(3, 7), (7, 3)]:
                continue

            # test criteria: circular variation is a prime?
            i = 1
            tmp = map(str, c)
            while i < len(tmp) and test_1(tmp, i) and test_2(tmp, i):
                i += 1

            # test criteria: circulars are primes and itself is a prime
            if i == len(c):
                num = int(''.join(tmp))

                if is_prime(num):
                    count += 1
                    print 'found:', count, digit_count, num
                    result.append(num)

        digit_count += 1

    print sum(result), result


def extend_right(num, depth):
    """Recursion by extending number from left to right.

    Arguments:
        depth: recursive depth

    Return:
        found: extended number that is a prime
    """
    digits = [3, 7, 9]
    found = []

    print 'working on right', depth, num
    for d in digits:
        to_right = num * 10 + d

        # extending left to right
        if is_prime(to_right):
            found.append(to_right)
            found += extend_right(to_right, depth + 1)
    return found


def extend_left(num, depth):
    """Recursion by extending number from right to left.
    """
    digits = [3, 7, 9]
    found = []

    print 'working on left', depth, num
    for d in digits:
        to_left = d * (10 ** len(str(num))) + num

        if is_prime(to_left):
            found.append(to_left)
            found += extend_left(to_left, depth + 1)
    return found


def method_3():
    # this is the entire problem space
    found = []
    for p in get_primes(100):
        found += extend_right(p, depth=0)
        found += extend_left(p, depth=0)

    # test circular variables
    result = []
    test_1 = (lambda x, i: is_prime(int(''.join(x[-i:]))))
    test_2 = (lambda x, i: is_prime(int(''.join(x[:i]))))
    for f in map(str, set(found)):
        i = 1
        while i < len(f) and test_1(f, i) and test_2(f, i):
            i += 1

        if i == len(f):
            print 'found one', f
            result.append(int(f))
    print result, len(result), sum(result)


def main():
    method_3()

if __name__ == '__main__':
    main()
