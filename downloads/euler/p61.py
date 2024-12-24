# -*- coding: utf-8 -*-

from p44 import pentagonal_generator
from p45 import triangle_generator,  hexagonal_generator


def square_generator(n):
    m = 1
    while m < n:
        yield m * m
        m += 1


def heptagonal_generator(n):
    m = 1
    while m < n:
        yield m * (5 * m - 3) / 2
        m += 1


def octagonal_generator(n):
    m = 1
    while m < n:
        yield m * (3 * m - 2)
        m += 1


def search_me(data, a, found, test, N=4):
    print 'search_me', a, found
    for b in data:
        if len(found) == N:
            print 'found', found
            yield found
            break

        if test(a, b):
            found.append(b)
            # print 'appending', a, b
            search_me(data, b, found, test, N)


def main():
    N = 10000
    p3 = filter(lambda x: x > 1000 and x < N, list(triangle_generator(N)))
    p4 = filter(lambda x: x > 1000 and x < N, list(square_generator(N)))
    p5 = filter(lambda x: x > 1000 and x < N, list(pentagonal_generator(N)))
    p6 = filter(lambda x: x > 1000 and x < N, list(hexagonal_generator(N)))
    p7 = filter(lambda x: x > 1000 and x < N, list(heptagonal_generator(N)))
    p8 = filter(lambda x: x > 1000 and x < N, list(octagonal_generator(N)))

    data = reduce(lambda x, y: x + y, [p3, p4, p5, p6, p7, p8])
    test_cyclic = lambda a, b: (a - int(b / 100)) % 100 == 0
    for d in data:
        for f in search_me(data, d, [d], test_cyclic, 4):
            print '*' * 20, d, f
        # if len(found) == 4 and test_cyclic(found[0], found[-1]):
        #    print 'mine', found

if __name__ == '__main__':
    main()
