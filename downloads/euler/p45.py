
# -*- coding: utf-8 -*-

from p44 import pentagonal_generator


def triangle_generator(n):
    m = 1
    while m < n:
        yield m * (m + 1) / 2
        m += 1


def hexagonal_generator(n):
    m = 1
    while m < n:
        yield m * (2 * m - 1)
        m += 1


def main():
    result = []
    n = 0
    while len(result) < 4:
        n += 10000
        result = set(pentagonal_generator(n)) & set(
            triangle_generator(n)) & set(hexagonal_generator(n))

    print n, result

if __name__ == '__main__':
    main()
