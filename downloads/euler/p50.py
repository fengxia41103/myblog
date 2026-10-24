# -*- coding: utf-8 -*-

from p10 import get_primes


def main():
    n = 1000000
    primes = sorted(get_primes(n))

    # set max window size
    window = 1
    while sum(primes[:window]) < n:
        window += 1

    # moving window
    while window > 1:
        # moving window start and end
        start = 0
        end = start + window

        # move till the end of prime list
        while end < len(primes):
            # test: always true, is sum of primes
            tmp = sum(primes[start:end])

            # too big, skip
            if tmp > n:
                break

            # test: is prime, < n
            elif tmp < n and tmp in primes:
                print 'found', window, tmp
                return

            # sliding window
            start += 1
            end = start + window - 1

        # try next window size
        window -= 1

if __name__ == '__main__':
    main()
