# -*- coding: utf-8 -*-

import itertools


def main():
    # no 0 on both ends
    space = filter(
        lambda x: x[0] and x[-1], itertools.permutations(range(10), 10))

    # test criteria: d2d3d4 % 2 == 0
    space = filter(lambda x: x[3] % 2 == 0, space)

    # test criteria: d3d4d5 % 3 == 0
    space = filter(lambda x: (x[2] + x[3] + x[4]) % 3 == 0, space)

    # test criteria: d4d5d6 % 5 == 0
    space = filter(lambda x: x[5] in [0, 5], space)

    # test criteria: d5d6d7 % 7 == 0
    test_7 = lambda x: int(''.join([str(x) for x in x[4:7]])) % 7 == 0

    # test criteria: d6d7d8 % 11 == 0
    test_11 = lambda x: int(''.join([str(x) for x in x[5:8]])) % 11 == 0

    # test criteria: d7d8d9 % 13 == 0
    test_13 = lambda x: int(''.join([str(x) for x in x[6:9]])) % 13 == 0

    # test criteria: d8d9d10 % 17 == 0
    test_17 = lambda x: int(''.join([str(x) for x in x[7:10]])) % 17 == 0

    # all tests
    test = lambda x: test_7(x) and test_11(x) and test_13(x) and test_17(x)

    # result
    print sum([int(''.join([str(x) for x in n])) for n in filter(test, space)])

if __name__ == '__main__':
    main()
