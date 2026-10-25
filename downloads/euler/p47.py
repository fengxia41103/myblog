# -*- coding: utf-8 -*-

from p10 import get_primes


def get_prime_factors(n, primes=[]):
    """Get prime factors of n.

    Arguments:
    :n: target number
    :primes: Optionally passing in a pregenerated prime list.

    Return:
    :factors: prime factors
    """
    factors = []
    if not primes:
        primes = get_primes(n)

    # find prime factors
    for p in primes:
        while n % p == 0 and n > p:
            n = n / p
            factors.append(p)
        if p > n:
            break
    factors.append(n)
    return factors


def main():
    # generate primes under an upper bound
    primes = list(get_primes(10000))

    # smallest 4 prime product = 2*3*5*7 = 210
    m = 210

    # until 4 consecutive numbers are found
    found = []
    while len(found) < 4 or found[-1] - found[-4] != 3:
        # if having 4 distinct prime factors
        if len(set(get_prime_factors(m, primes))) == 4:
            found.append(m)

        # increment
        m += 1

    # answer
    print found[-4:]

if __name__ == '__main__':
    main()
