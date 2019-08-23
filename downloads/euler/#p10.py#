# -*- coding: utf-8 -*-

"""
The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.

Find the sum of all the primes below two million.
"""

from itertools import ifilter
from math import sqrt


def get_primes(n):
    """Generator returns prime number below n.

    Arguments:
    :n: upper bound

    Return:
    :generator: prime numbers that are less than or equal to n
    """
    if n <= 2:
        return
    yield 2
    F = [True] * n
    seq1 = xrange(3, int(sqrt(n)) + 1, 2)
    seq2 = xrange(seq1[-1] + 2, n, 2)
    for p in ifilter(F.__getitem__, seq1):
        yield p
        for q in xrange(p * p, n, 2 * p):
            F[q] = False
    for p in ifilter(F.__getitem__, seq2):
        yield p

# ideone.com/aVndFM
from itertools import count


def postponed_sieve():                   # postponed sieve, by Will Ness
    yield 2
    yield 3
    yield 5
    yield 7
    # original code David Eppstein,
    sieve = {}  # Alex Martelli, ActiveState Recipe 2002
    ps = postponed_sieve()               # a separate base Primes Supply:
    p = next(ps) and next(ps)            # (3) a Prime to add to dict
    q = p * p                              # (9) its sQuare
    for c in count(9, 2):                 # the Candidate
        if c in sieve:               # c's a multiple of some base prime
            s = sieve.pop(c)  # i.e. a composite ; or
        elif c < q:
            yield c                 # a prime
            continue
        else:   # (c==q):            # or the next base prime's square:
            s = count(q + 2 * p, 2 * p)  # (9+6, by 6 : 15,21,27,33,...)
            p = next(ps)  # (5)
            q = p * p  # (25)
        for m in s:                  # the next multiple
            if m not in sieve:       # no duplicates
                break
        sieve[m] = s                 # original test entry: ideone.com/WFv4f


def is_composite(n):
    for p in postponed_sieve():
        if n % p == 0:
            return True
        elif p * p > n:
            return False


def is_prime(n):
    return not is_composite(n)


def is_prime2(n):
    """Test function if a given number is prime.

    Argument:
    :n: number to test

    Return:
    :Boolean: true if n is prime
    """
    if n <= 1:
        return False
    elif n <= 3:
        return True
    elif n % 2 == 0 or n % 3 == 0:
        return False

    i = 5
    while i * i <= n:
        if n % i == 0 or n % (i + 2) == 0:
            return False
        i += 6
    return True


def method_1(n):
    primes = list(get_primes(n))
    print sum(primes)


def method_2(n):
    # sum 1 to n minus all the odd numbers, plus 2 back
    # since 2 is a prime
    tmp = n * n / 4 - 1 + 2

    primes = list(get_primes(1416))

    # problem space is sqrt(n)
    n = n - 1
    while n > 3:
        if n not in primes:
            for p in primes:
                if n % p == 0:
                    tmp -= n
                    break
        n -= 2

    return tmp


def main():
    n = 2000000
    # method_1(n)
    print method_2(n)
if __name__ == '__main__':
    main()
