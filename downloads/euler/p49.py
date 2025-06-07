# -*- coding: utf-8 -*-

from p10 import is_prime


def main():
    primes = sorted([x for x in range(1000, 10000) if is_prime(x)])
    for a in primes:
        b = a + 3330
        c = b + 3330

        # test 1: are primes
        if b in primes and c in primes:
            # test 2: are permutations of each other
            if set(str(a)) == set(str(b)) == set(str(c)):
                print a, b, c

if __name__ == '__main__':
    main()
