
# -*- coding: utf-8 -*-
from p10 import get_primes, is_prime


def main():
    n = 6000
    num = filter(lambda x: x % 2, set(
        [p + 2 * x * x for x in range(1, n) for p in get_primes(n)]))

    print filter(lambda x: not is_prime(x), set(range(3, n, 2)) - set(num))

if __name__ == '__main__':
    main()
