# -*- coding: utf-8 -*-

from p10 import get_primes, is_prime


def main():
    """
    Examine a special cases: n=0.

    n=0: this reveals that "b" needs to be a prime. Therefore, we first
    find all primes under 1000.

    Then we eumerate all combinations of (a,b) and test for primality
    of n*n+a*n+b.

    """
    n = 1000
    all_primes = list(get_primes(n))

    max_count = 0

    # iterate all b
    for b in all_primes:
        # abs(a)<b, and a must be an odd number
        for a in range(-1 * b, b, 2):
            count = 0
            for i in range(1, n + 1):
                tmp = i * i + a * i + b
                if tmp > 0 and (tmp in all_primes or is_prime(tmp)):
                    # count for generated primes
                    count += 1
                else:
                    break

            # keep score
            if count > max_count:
                max_count = count
                print max_count, a, b, a * b

if __name__ == '__main__':
    main()
