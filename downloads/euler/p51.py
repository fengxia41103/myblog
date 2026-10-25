# -*- coding: utf-8 -*-

from p10 import get_primes


def main():
    for p in get_primes(10000000):
        if len(str(p)) - len(set(str(p))) >= 2:
            print p

if __name__ == "__main__":
    main()
